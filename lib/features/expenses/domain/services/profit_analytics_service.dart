import '../../../billing/domain/entities/billing_enums.dart';
import '../../../billing/domain/entities/billing_order.dart';
import '../entities/expense.dart';
import '../entities/expense_analytics.dart';
import '../entities/expense_category_summary.dart';
import '../entities/expense_trend_point.dart';
import '../entities/profit_period_summary.dart';

class ProfitAnalyticsService {
  const ProfitAnalyticsService();

  ExpenseAnalytics buildAnalytics({
    required DateTime now,
    required DateTime startInclusive,
    required DateTime endInclusive,
    required List<Expense> expenses,
    required List<BillingOrder> orders,
  }) {
    final activeOrders = _activeOrders(orders);
    final totalExpenses = _expenseTotal(expenses);
    final totalSales = _salesTotal(activeOrders);
    final categorySummaries = _categorySummaries(expenses);
    final highestCategory = categorySummaries.isEmpty
        ? null
        : ([
            ...categorySummaries,
          ]..sort((a, b) => b.totalAmount.compareTo(a.totalAmount))).first;

    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = _endOfDay(todayStart);
    final weekStart = todayStart.subtract(
      Duration(days: todayStart.weekday - 1),
    );
    final monthStart = DateTime(now.year, now.month);

    return ExpenseAnalytics(
      totalExpenses: totalExpenses,
      totalSales: totalSales,
      netProfit: totalSales - totalExpenses,
      highestExpenseCategory: highestCategory,
      categorySummaries: categorySummaries,
      trends: _trends(
        startInclusive: startInclusive,
        endInclusive: endInclusive,
        expenses: expenses,
        orders: activeOrders,
      ),
      todayExpenses: _expenseTotal(
        _expensesInRange(expenses, todayStart, todayEnd),
      ),
      todayProfit: _period(
        label: 'Today',
        start: todayStart,
        end: todayEnd,
        expenses: expenses,
        orders: activeOrders,
      ),
      weeklyProfit: _period(
        label: 'This week',
        start: weekStart,
        end: todayEnd,
        expenses: expenses,
        orders: activeOrders,
      ),
      monthlyProfit: _period(
        label: 'This month',
        start: monthStart,
        end: todayEnd,
        expenses: expenses,
        orders: activeOrders,
      ),
      recentExpenses:
          ([...expenses]
                ..sort((a, b) => b.expenseDate.compareTo(a.expenseDate)))
              .take(5)
              .toList(growable: false),
    );
  }

  List<BillingOrder> _activeOrders(List<BillingOrder> orders) {
    return orders
        .where((order) => order.orderStatus != OrderStatus.cancelled)
        .toList(growable: false);
  }

  double _salesTotal(List<BillingOrder> orders) {
    return orders.fold(0, (total, order) => total + order.totalAmount);
  }

  double _expenseTotal(List<Expense> expenses) {
    return expenses.fold(0, (total, expense) => total + expense.amount);
  }

  List<ExpenseCategorySummary> _categorySummaries(List<Expense> expenses) {
    final totalsByCategory = <String, double>{};
    final countsByCategory = <String, int>{};
    for (final expense in expenses) {
      totalsByCategory.update(
        expense.category,
        (total) => total + expense.amount,
        ifAbsent: () => expense.amount,
      );
      countsByCategory.update(
        expense.category,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    final summaries = [
      for (final entry in totalsByCategory.entries)
        ExpenseCategorySummary(
          category: entry.key,
          totalAmount: entry.value,
          expenseCount: countsByCategory[entry.key] ?? 0,
        ),
    ];
    summaries.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
    return summaries;
  }

  List<ExpenseTrendPoint> _trends({
    required DateTime startInclusive,
    required DateTime endInclusive,
    required List<Expense> expenses,
    required List<BillingOrder> orders,
  }) {
    final trends = <ExpenseTrendPoint>[];
    final start = DateTime(
      startInclusive.year,
      startInclusive.month,
      startInclusive.day,
    );
    final end = DateTime(
      endInclusive.year,
      endInclusive.month,
      endInclusive.day,
    );
    for (
      var date = start;
      !date.isAfter(end);
      date = date.add(const Duration(days: 1))
    ) {
      final dayEnd = _endOfDay(date);
      final dayExpenses = _expenseTotal(
        _expensesInRange(expenses, date, dayEnd),
      );
      final daySales = _salesTotal(_ordersInRange(orders, date, dayEnd));
      trends.add(
        ExpenseTrendPoint(
          date: date,
          totalExpenses: dayExpenses,
          totalSales: daySales,
          netProfit: daySales - dayExpenses,
        ),
      );
    }
    return trends;
  }

  ProfitPeriodSummary _period({
    required String label,
    required DateTime start,
    required DateTime end,
    required List<Expense> expenses,
    required List<BillingOrder> orders,
  }) {
    return ProfitPeriodSummary(
      label: label,
      startDate: start,
      endDate: end,
      totalSales: _salesTotal(_ordersInRange(orders, start, end)),
      totalExpenses: _expenseTotal(_expensesInRange(expenses, start, end)),
    );
  }

  List<Expense> _expensesInRange(
    List<Expense> expenses,
    DateTime start,
    DateTime end,
  ) {
    return expenses
        .where(
          (expense) =>
              !expense.expenseDate.isBefore(start) &&
              !expense.expenseDate.isAfter(end),
        )
        .toList(growable: false);
  }

  List<BillingOrder> _ordersInRange(
    List<BillingOrder> orders,
    DateTime start,
    DateTime end,
  ) {
    return orders
        .where(
          (order) =>
              !order.createdAt.isBefore(start) && !order.createdAt.isAfter(end),
        )
        .toList(growable: false);
  }

  DateTime _endOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day, 23, 59, 59, 999);
  }
}
