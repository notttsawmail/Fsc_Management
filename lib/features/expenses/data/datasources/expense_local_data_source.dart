import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../billing/data/models/billing_order_model.dart';
import '../../../inventory/data/models/inventory_item_model.dart';
import '../../../settings/data/models/app_settings_model.dart';
import '../../../settings/data/models/low_stock_notification_model.dart';
import '../models/expense_model.dart';

class ExpenseLocalDataSource {
  ExpenseLocalDataSource._(this._isar);

  final Isar _isar;

  static Future<ExpenseLocalDataSource> open() async {
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
    return ExpenseLocalDataSource._(isar);
  }

  Stream<List<ExpenseModel>> watchExpenses() {
    return _isar.expenseModels.where().sortByExpenseDateDesc().watch(
      fireImmediately: true,
    );
  }

  Future<List<ExpenseModel>> getExpensesBetween({
    required DateTime startInclusive,
    required DateTime endInclusive,
  }) {
    return _isar.expenseModels
        .filter()
        .expenseDateBetween(startInclusive, endInclusive)
        .sortByExpenseDateDesc()
        .findAll();
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

  Future<void> putExpense(ExpenseModel expense) {
    return _isar.writeTxn(() => _isar.expenseModels.put(expense));
  }

  Future<void> deleteExpense(int id) {
    return _isar.writeTxn(() => _isar.expenseModels.delete(id));
  }
}
