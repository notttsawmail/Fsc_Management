import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../billing/data/models/billing_order_model.dart';
import '../../../inventory/data/models/inventory_item_model.dart';
import '../../../settings/data/models/app_settings_model.dart';
import '../../../settings/data/models/low_stock_notification_model.dart';

class ReportsLocalDataSource {
  ReportsLocalDataSource._(this._isar);

  final Isar _isar;

  static Future<ReportsLocalDataSource> open() async {
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
    return ReportsLocalDataSource._(isar);
  }

  Future<List<BillingOrderModel>> getOrdersBetween({
    required String startNepaliDate,
    required String endNepaliDate,
  }) {
    return _isar.billingOrderModels
        .filter()
        .nepaliDateBetween(startNepaliDate, endNepaliDate)
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<List<BillingOrderModel>> getOrdersForMonth(DateTime month) {
    final start = DateTime(month.year, month.month);
    final end = DateTime(
      month.year,
      month.month + 1,
    ).subtract(const Duration(days: 1));
    return getOrdersBetween(
      startNepaliDate: _compactDate(start),
      endNepaliDate: _compactDate(end),
    );
  }

  Future<List<InventoryItemModel>> getInventoryItems() {
    return _isar.inventoryItemModels.where().sortByName().findAll();
  }

  String _compactDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
