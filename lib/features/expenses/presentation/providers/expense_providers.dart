import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../reports/domain/services/nepali_report_clock.dart';
import '../../../reports/presentation/providers/reports_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../data/datasources/expense_local_data_source.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../data/services/expense_pdf_service.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_analytics.dart';
import '../../domain/entities/expense_enums.dart';
import '../../domain/entities/expense_filters.dart';
import '../../domain/entities/expense_report.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/services/profit_analytics_service.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_expense_analytics.dart';
import '../../domain/usecases/get_expense_report.dart';
import '../../domain/usecases/save_expense.dart';
import '../../domain/usecases/watch_expenses.dart';

final expenseLocalDataSourceProvider = FutureProvider<ExpenseLocalDataSource>((
  ref,
) {
  return ExpenseLocalDataSource.open();
});

final profitAnalyticsServiceProvider = Provider<ProfitAnalyticsService>((ref) {
  return const ProfitAnalyticsService();
});

final expenseRepositoryProvider = FutureProvider<ExpenseRepository>((
  ref,
) async {
  final dataSource = await ref.watch(expenseLocalDataSourceProvider.future);
  return ExpenseRepositoryImpl(
    localDataSource: dataSource,
    clock: ref.watch(nepaliReportClockProvider),
    analyticsService: ref.watch(profitAnalyticsServiceProvider),
  );
});

final expenseFiltersProvider = StateProvider<ExpenseFilters>((ref) {
  return const ExpenseFilters();
});

final expenseCategoriesProvider = StreamProvider.autoDispose<List<String>>((
  ref,
) async* {
  final dataSource = await ref.watch(expenseLocalDataSourceProvider.future);
  yield* dataSource.watchExpenses().map((models) {
    final categories = <String>{};
    for (final model in models) {
      categories.add(normalizeExpenseCategory(model.category));
    }
    final sorted = categories.toList();
    sorted.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return sorted;
  });
});

final expensesProvider = StreamProvider.autoDispose<List<Expense>>((
  ref,
) async* {
  final repository = await ref.watch(expenseRepositoryProvider.future);
  final filters = ref.watch(expenseFiltersProvider);
  yield* WatchExpenses(repository)(filters);
});

final expenseAnalyticsProvider = FutureProvider.autoDispose<ExpenseAnalytics>((
  ref,
) async {
  final repository = await ref.watch(expenseRepositoryProvider.future);
  final clock = ref.watch(nepaliReportClockProvider);
  final now = clock.now();
  final start = DateTime(now.year, now.month);
  final end = clock.endOfDay(now);
  return GetExpenseAnalytics(repository)(
    startInclusive: start,
    endInclusive: end,
  );
});

final expenseReportRangeProvider = StateProvider<ExpenseReportRange>((ref) {
  final clock = ref.watch(nepaliReportClockProvider);
  final today = clock.startOfDay(clock.now());
  return ExpenseReportRange(
    label: 'Today (${clock.displayDate(today)})',
    startDate: today,
    endDate: clock.endOfDay(today),
  );
});

final expenseReportProvider = FutureProvider.autoDispose<ExpenseReport>((
  ref,
) async {
  final repository = await ref.watch(expenseRepositoryProvider.future);
  final range = ref.watch(expenseReportRangeProvider);
  return GetExpenseReport(repository)(
    startInclusive: range.startDate,
    endInclusive: range.endDate,
    label: range.label,
  );
});

final expensePdfServiceProvider = Provider<ExpensePdfService>((ref) {
  return ExpensePdfService(ref.watch(nepaliReportClockProvider));
});

final expensePdfBytesProvider = FutureProvider.autoDispose
    .family<Uint8List, ExpenseReport>((ref, report) {
      return ref
          .watch(expensePdfServiceProvider)
          .buildExpenseReportPdf(report: report);
    });

final expenseControllerProvider =
    StateNotifierProvider<ExpenseController, AsyncValue<void>>((ref) {
      return ExpenseController(ref);
    });

final expensePdfControllerProvider =
    StateNotifierProvider<ExpensePdfController, AsyncValue<String?>>((ref) {
      return ExpensePdfController(ref);
    });

class ExpenseReportRange {
  const ExpenseReportRange({
    required this.label,
    required this.startDate,
    required this.endDate,
  });

  final String label;
  final DateTime startDate;
  final DateTime endDate;
}

class ExpenseController extends StateNotifier<AsyncValue<void>> {
  ExpenseController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> save(Expense expense) async {
    state = const AsyncLoading();
    try {
      final repository = await _ref.read(expenseRepositoryProvider.future);
      await SaveExpense(repository)(expense);
      _ref.invalidate(expenseAnalyticsProvider);
      _ref.invalidate(expenseReportProvider);
      _ref.invalidate(calendarSalesProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> delete(int id) async {
    state = const AsyncLoading();
    try {
      final repository = await _ref.read(expenseRepositoryProvider.future);
      await DeleteExpense(repository)(id);
      _ref.invalidate(expenseAnalyticsProvider);
      _ref.invalidate(expenseReportProvider);
      _ref.invalidate(calendarSalesProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

class ExpensePdfController extends StateNotifier<AsyncValue<String?>> {
  ExpensePdfController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> share(ExpenseReport report) async {
    state = const AsyncLoading();
    try {
      final settings = await _ref.read(appSettingsProvider.future);
      await _ref
          .read(expensePdfServiceProvider)
          .shareExpenseReportPdf(report: report, shopName: settings.shopName);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<String> save(ExpenseReport report) async {
    state = const AsyncLoading();
    try {
      final settings = await _ref.read(appSettingsProvider.future);
      final path = await _ref
          .read(expensePdfServiceProvider)
          .saveExpenseReportPdf(report: report, shopName: settings.shopName);
      state = AsyncData(path);
      return path;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

DateTime nepaliNow(NepaliReportClock clock) => clock.now();
