import '../../../billing/domain/entities/billing_order.dart';
import '../../../reports/domain/services/nepali_report_clock.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_analytics.dart';
import '../../domain/entities/expense_filters.dart';
import '../../domain/entities/expense_report.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/services/profit_analytics_service.dart';
import '../datasources/expense_local_data_source.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl({
    required ExpenseLocalDataSource localDataSource,
    required NepaliReportClock clock,
    required ProfitAnalyticsService analyticsService,
  }) : _localDataSource = localDataSource,
       _clock = clock,
       _analyticsService = analyticsService;

  final ExpenseLocalDataSource _localDataSource;
  final NepaliReportClock _clock;
  final ProfitAnalyticsService _analyticsService;

  @override
  Stream<List<Expense>> watchExpenses(ExpenseFilters filters) {
    return _localDataSource.watchExpenses().map((models) {
      final query = filters.searchQuery.trim().toLowerCase();
      final start = filters.startDate == null
          ? null
          : _clock.startOfDay(filters.startDate!);
      final end = filters.endDate == null
          ? null
          : _clock.endOfDay(filters.endDate!);
      return models
          .map((model) => model.toEntity())
          .where((expense) {
            final matchesSearch =
                query.isEmpty ||
                expense.title.toLowerCase().contains(query) ||
                expense.category.toLowerCase().contains(query) ||
                expense.description.toLowerCase().contains(query);
            final matchesCategory =
                filters.category == null ||
                expense.category.toLowerCase() ==
                    filters.category!.toLowerCase();
            final matchesStart =
                start == null || !expense.expenseDate.isBefore(start);
            final matchesEnd = end == null || !expense.expenseDate.isAfter(end);
            return matchesSearch &&
                matchesCategory &&
                matchesStart &&
                matchesEnd;
          })
          .toList(growable: false);
    });
  }

  @override
  Future<List<Expense>> getExpensesBetween({
    required DateTime startInclusive,
    required DateTime endInclusive,
  }) async {
    final models = await _localDataSource.getExpensesBetween(
      startInclusive: startInclusive,
      endInclusive: endInclusive,
    );
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<void> saveExpense(Expense expense) {
    return _localDataSource.putExpense(ExpenseModel.fromEntity(expense));
  }

  @override
  Future<void> deleteExpense(int id) => _localDataSource.deleteExpense(id);

  @override
  Future<ExpenseAnalytics> getAnalytics({
    required DateTime startInclusive,
    required DateTime endInclusive,
  }) async {
    final expenses = await getExpensesBetween(
      startInclusive: startInclusive,
      endInclusive: endInclusive,
    );
    final orders = await _ordersBetween(startInclusive, endInclusive);
    return _analyticsService.buildAnalytics(
      now: _clock.now(),
      startInclusive: startInclusive,
      endInclusive: endInclusive,
      expenses: expenses,
      orders: orders,
    );
  }

  @override
  Future<ExpenseReport> getReport({
    required DateTime startInclusive,
    required DateTime endInclusive,
    required String label,
  }) async {
    final expenses = await getExpensesBetween(
      startInclusive: startInclusive,
      endInclusive: endInclusive,
    );
    final orders = await _ordersBetween(startInclusive, endInclusive);
    final totalSales = orders.fold(
      0.0,
      (total, order) => total + order.totalAmount,
    );
    final totalExpenses = expenses.fold(
      0.0,
      (total, expense) => total + expense.amount,
    );
    final analytics = _analyticsService.buildAnalytics(
      now: _clock.now(),
      startInclusive: startInclusive,
      endInclusive: endInclusive,
      expenses: expenses,
      orders: orders,
    );
    return ExpenseReport(
      label: label,
      startDate: startInclusive,
      endDate: endInclusive,
      expenses: expenses,
      totalSales: totalSales,
      totalExpenses: totalExpenses,
      analytics: analytics,
    );
  }

  Future<List<BillingOrder>> _ordersBetween(
    DateTime start,
    DateTime end,
  ) async {
    final models = await _localDataSource.getOrdersBetween(
      startNepaliDate: _clock.compactDate(start),
      endNepaliDate: _clock.compactDate(end),
    );
    return models
        .map((model) => model.toEntity())
        .where((order) => order.orderStatus.name != 'cancelled')
        .toList(growable: false);
  }
}
