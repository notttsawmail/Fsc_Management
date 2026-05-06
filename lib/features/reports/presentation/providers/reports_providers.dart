import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/reports_local_data_source.dart';
import '../../data/repositories/reports_repository_impl.dart';
import '../../data/services/reports_pdf_service.dart';
import '../../domain/entities/analytics_dashboard.dart';
import '../../domain/entities/calendar_sales_day.dart';
import '../../domain/entities/daily_sales_report.dart';
import '../../domain/entities/report_date_filter.dart';
import '../../domain/repositories/reports_repository.dart';
import '../../domain/services/nepali_report_clock.dart';
import '../../domain/services/sales_report_generator.dart';
import '../../domain/usecases/get_analytics_dashboard.dart';
import '../../domain/usecases/get_calendar_sales.dart';
import '../../domain/usecases/get_sales_report.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

final nepaliReportClockProvider = Provider<NepaliReportClock>((ref) {
  return NepaliReportClock();
});

final salesReportGeneratorProvider = Provider<SalesReportGenerator>((ref) {
  return SalesReportGenerator(ref.watch(nepaliReportClockProvider));
});

final reportsLocalDataSourceProvider = FutureProvider<ReportsLocalDataSource>((
  ref,
) {
  return ReportsLocalDataSource.open();
});

final reportsRepositoryProvider = FutureProvider<ReportsRepository>((
  ref,
) async {
  final dataSource = await ref.watch(reportsLocalDataSourceProvider.future);
  final clock = ref.watch(nepaliReportClockProvider);
  return ReportsRepositoryImpl(
    localDataSource: dataSource,
    clock: clock,
    generator: ref.watch(salesReportGeneratorProvider),
  );
});

final reportsPdfServiceProvider = Provider<ReportsPdfService>((ref) {
  return ReportsPdfService(ref.watch(nepaliReportClockProvider));
});

final reportDateFilterProvider = StateProvider<ReportDateFilter>((ref) {
  return ReportDateFilter.today();
});

final selectedCalendarMonthProvider = StateProvider<DateTime>((ref) {
  final now = ref.watch(nepaliReportClockProvider).now();
  return DateTime(now.year, now.month);
});

final selectedCalendarDateProvider = StateProvider<DateTime?>((ref) => null);

final salesReportProvider = FutureProvider.autoDispose<DailySalesReport>((
  ref,
) async {
  final repository = await ref.watch(reportsRepositoryProvider.future);
  final filter = ref.watch(reportDateFilterProvider);
  return GetSalesReport(repository)(filter);
});

final analyticsDashboardProvider =
    FutureProvider.autoDispose<AnalyticsDashboard>((ref) async {
      final repository = await ref.watch(reportsRepositoryProvider.future);
      return GetAnalyticsDashboard(repository)();
    });

final calendarSalesProvider =
    FutureProvider.autoDispose<List<CalendarSalesDay>>((ref) async {
      final repository = await ref.watch(reportsRepositoryProvider.future);
      final month = ref.watch(selectedCalendarMonthProvider);
      return GetCalendarSales(repository)(month);
    });

final selectedCalendarDayReportProvider =
    FutureProvider.autoDispose<DailySalesReport?>((ref) async {
      final selectedDate = ref.watch(selectedCalendarDateProvider);
      if (selectedDate == null) {
        return null;
      }
      final repository = await ref.watch(reportsRepositoryProvider.future);
      return repository.getDayReport(selectedDate);
    });

final reportPdfBytesProvider = FutureProvider.autoDispose
    .family<Uint8List, DailySalesReport>((ref, report) {
      return ref
          .watch(reportsPdfServiceProvider)
          .buildDailySalesPdf(report: report);
    });

final reportsPdfControllerProvider =
    StateNotifierProvider<ReportsPdfController, AsyncValue<String?>>((ref) {
      return ReportsPdfController(ref);
    });

class ReportsPdfController extends StateNotifier<AsyncValue<String?>> {
  ReportsPdfController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> share(DailySalesReport report) async {
    state = const AsyncLoading();
    try {
      final settings = await _ref.read(appSettingsProvider.future);
      await _ref
          .read(reportsPdfServiceProvider)
          .shareDailySalesPdf(report: report, shopName: settings.shopName);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<String> save(DailySalesReport report) async {
    state = const AsyncLoading();
    try {
      final settings = await _ref.read(appSettingsProvider.future);
      final path = await _ref
          .read(reportsPdfServiceProvider)
          .saveDailySalesPdf(report: report, shopName: settings.shopName);
      state = AsyncData(path);
      return path;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
