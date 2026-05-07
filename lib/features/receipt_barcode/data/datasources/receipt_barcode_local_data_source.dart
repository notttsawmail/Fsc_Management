import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../billing/data/models/billing_order_model.dart';
import '../../../expenses/data/models/expense_model.dart';
import '../../../inventory/data/models/inventory_item_model.dart';
import '../../../settings/data/models/app_settings_model.dart';
import '../../../settings/data/models/low_stock_notification_model.dart';

class ReceiptBarcodeLocalDataSource {
  ReceiptBarcodeLocalDataSource._(this._isar);

  final Isar _isar;

  static Future<ReceiptBarcodeLocalDataSource> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        InventoryItemModelSchema,
        BillingOrderModelSchema,
        ExpenseModelSchema,
        AppSettingsModelSchema,
        LowStockNotificationModelSchema,
      ],
      directory: dir.path,
      name: 'fsc_inventory',
    );
    return ReceiptBarcodeLocalDataSource._(isar);
  }

  Stream<List<BillingOrderModel>> watchReceiptOrders() {
    return _isar.billingOrderModels.where().sortByCreatedAtDesc().watch(
      fireImmediately: true,
    );
  }

  Future<BillingOrderModel?> getReceiptOrder(int id) {
    return _isar.billingOrderModels.get(id);
  }

  Future<InventoryItemModel?> findItemByBarcode(String barcode) {
    return _isar.inventoryItemModels
        .filter()
        .barcodeEqualTo(barcode.trim(), caseSensitive: false)
        .findFirst();
  }

  Future<bool> isBarcodeUnique({
    required String barcode,
    int? excludingItemId,
  }) async {
    final existing = await findItemByBarcode(barcode);
    return existing == null || existing.id == excludingItemId;
  }
}
