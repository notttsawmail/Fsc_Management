import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../inventory/data/models/inventory_item_model.dart';
import '../../../settings/data/models/app_settings_model.dart';
import '../../../settings/data/models/low_stock_notification_model.dart';
import '../models/billing_order_model.dart';

class BillingLocalDataSource {
  BillingLocalDataSource._(this._isar);

  final Isar _isar;

  static Future<BillingLocalDataSource> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        InventoryItemModelSchema,
        BillingOrderModelSchema,
        AppSettingsModelSchema,
        LowStockNotificationModelSchema,
      ],
      directory: dir.path,
      name: 'fsc_inventory',
    );
    return BillingLocalDataSource._(isar);
  }

  Stream<List<BillingOrderModel>> watchOrders() {
    return _isar.billingOrderModels.where().sortByCreatedAtDesc().watch(
      fireImmediately: true,
    );
  }

  Future<int> nextTokenNumber({required String nepaliDate}) async {
    final latest = await _isar.billingOrderModels
        .filter()
        .nepaliDateEqualTo(nepaliDate)
        .sortByTokenNumberDesc()
        .findFirst();
    return (latest?.tokenNumber ?? 0) + 1;
  }

  Future<BillingOrderModel> createPaidOrder(BillingOrderModel draft) async {
    return _isar.writeTxn(() async {
      final token = await _availableTokenNumberInTxn(
        nepaliDate: draft.nepaliDate,
        requestedToken: draft.tokenNumber,
      );
      final order = draft
        ..id = Isar.autoIncrement
        ..tokenNumber = token;

      for (final orderItem in order.items) {
        final inventoryItem = await _isar.inventoryItemModels.get(
          orderItem.inventoryItemId,
        );
        if (inventoryItem == null) {
          throw StateError('${orderItem.itemName} no longer exists.');
        }
        if (inventoryItem.isTrackableInventory &&
            inventoryItem.quantity < orderItem.quantity) {
          throw StateError('Not enough stock for ${inventoryItem.name}.');
        }
        if (inventoryItem.isTrackableInventory) {
          inventoryItem
            ..quantity = inventoryItem.quantity - orderItem.quantity
            ..updatedAt = DateTime.now();
          await _isar.inventoryItemModels.put(inventoryItem);
        }
      }

      final savedId = await _isar.billingOrderModels.put(order);
      return (await _isar.billingOrderModels.get(savedId))!;
    });
  }

  Future<void> cancelOrder(int id) async {
    await _isar.writeTxn(() async {
      final order = await _isar.billingOrderModels.get(id);
      if (order == null || order.orderStatus == 'cancelled') {
        return;
      }

      for (final orderItem in order.items) {
        final inventoryItem = await _isar.inventoryItemModels.get(
          orderItem.inventoryItemId,
        );
        if (inventoryItem == null || !inventoryItem.isTrackableInventory) {
          continue;
        }
        inventoryItem
          ..quantity = inventoryItem.quantity + orderItem.quantity
          ..updatedAt = DateTime.now();
        await _isar.inventoryItemModels.put(inventoryItem);
      }

      order
        ..orderStatus = 'cancelled'
        ..paymentStatus = 'pending';
      await _isar.billingOrderModels.put(order);
    });
  }

  Future<int> _availableTokenNumberInTxn({
    required String nepaliDate,
    required int requestedToken,
  }) async {
    if (requestedToken > 0) {
      final existing = await _isar.billingOrderModels
          .filter()
          .nepaliDateEqualTo(nepaliDate)
          .tokenNumberEqualTo(requestedToken)
          .findFirst();
      if (existing == null) {
        return requestedToken;
      }
    }

    final latest = await _isar.billingOrderModels
        .filter()
        .nepaliDateEqualTo(nepaliDate)
        .sortByTokenNumberDesc()
        .findFirst();
    return (latest?.tokenNumber ?? 0) + 1;
  }
}
