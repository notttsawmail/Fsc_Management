import 'expense.dart';
import 'expense_category_summary.dart';
import 'expense_trend_point.dart';
import 'profit_period_summary.dart';

class ExpenseAnalytics {
  const ExpenseAnalytics({
    required this.totalExpenses,
    required this.totalSales,
    required this.netProfit,
    required this.highestExpenseCategory,
    required this.categorySummaries,
    required this.trends,
    required this.todayExpenses,
    required this.todayProfit,
    required this.weeklyProfit,
    required this.monthlyProfit,
    required this.recentExpenses,
  });

  final double totalExpenses;
  final double totalSales;
  final double netProfit;
  final ExpenseCategorySummary? highestExpenseCategory;
  final List<ExpenseCategorySummary> categorySummaries;
  final List<ExpenseTrendPoint> trends;
  final double todayExpenses;
  final ProfitPeriodSummary todayProfit;
  final ProfitPeriodSummary weeklyProfit;
  final ProfitPeriodSummary monthlyProfit;
  final List<Expense> recentExpenses;
}
