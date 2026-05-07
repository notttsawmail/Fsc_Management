import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/billing/data/models/billing_order_model.dart';
import '../../features/expenses/data/models/expense_model.dart';
import '../../features/inventory/data/models/inventory_item_model.dart';
import '../../features/settings/data/models/app_settings_model.dart';
import '../../features/settings/data/models/low_stock_notification_model.dart';

class AppIsar {
  AppIsar._();

  static const _databaseName = 'fsc_inventory';

  static Isar? _instance;
  static Future<Isar>? _opening;

  static Future<Isar> open() async {
    final existing = _instance;
    if (existing != null && existing.isOpen) {
      return existing;
    }

    final opening = _opening;
    if (opening != null) {
      return opening;
    }

    final future = _openInternal();
    _opening = future;

    try {
      final isar = await future;
      _instance = isar;
      return isar;
    } finally {
      _opening = null;
    }
  }

  static Future<Isar> _openInternal() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [
        InventoryItemModelSchema,
        BillingOrderModelSchema,
        ExpenseModelSchema,
        AppSettingsModelSchema,
        LowStockNotificationModelSchema,
      ],
      directory: dir.path,
      name: _databaseName,
    );
  }
}
