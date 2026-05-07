import 'package:isar/isar.dart';

import '../../../../core/data/app_isar.dart';
import '../../../billing/data/models/billing_order_model.dart';
import '../../../expenses/data/models/expense_model.dart';
import '../../../inventory/data/models/inventory_item_model.dart';

class ReportsLocalDataSource {
  ReportsLocalDataSource._(this._isar);

  final Isar _isar;

  static Future<ReportsLocalDataSource> open() async {
    final isar = await AppIsar.open();
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

  Future<List<ExpenseModel>> getExpensesForMonth(DateTime month) {
    final start = DateTime(month.year, month.month);
    final end = DateTime(
      month.year,
      month.month + 1,
    ).subtract(const Duration(milliseconds: 1));
    return getExpensesBetween(startInclusive: start, endInclusive: end);
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
