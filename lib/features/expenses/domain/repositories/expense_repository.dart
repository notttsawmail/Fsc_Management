import '../entities/expense.dart';
import '../entities/expense_analytics.dart';
import '../entities/expense_filters.dart';
import '../entities/expense_report.dart';

abstract class ExpenseRepository {
  Stream<List<Expense>> watchExpenses(ExpenseFilters filters);

  Future<List<Expense>> getExpensesBetween({
    required DateTime startInclusive,
    required DateTime endInclusive,
  });

  Future<void> saveExpense(Expense expense);

  Future<void> deleteExpense(int id);

  Future<ExpenseAnalytics> getAnalytics({
    required DateTime startInclusive,
    required DateTime endInclusive,
  });

  Future<ExpenseReport> getReport({
    required DateTime startInclusive,
    required DateTime endInclusive,
    required String label,
  });
}
