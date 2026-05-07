import 'expense.dart';
import 'expense_analytics.dart';
import 'profit_period_summary.dart';

class ExpenseReport {
  const ExpenseReport({
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.expenses,
    required this.totalSales,
    required this.totalExpenses,
    required this.analytics,
  });

  final String label;
  final DateTime startDate;
  final DateTime endDate;
  final List<Expense> expenses;
  final double totalSales;
  final double totalExpenses;
  final ExpenseAnalytics analytics;

  double get netProfit => totalSales - totalExpenses;

  ProfitPeriodSummary get profitSummary {
    return ProfitPeriodSummary(
      label: label,
      startDate: startDate,
      endDate: endDate,
      totalSales: totalSales,
      totalExpenses: totalExpenses,
    );
  }
}
