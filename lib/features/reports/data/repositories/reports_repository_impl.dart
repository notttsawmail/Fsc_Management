import '../../../billing/domain/entities/billing_order.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../../domain/entities/analytics_dashboard.dart';
import '../../domain/entities/calendar_sales_day.dart';
import '../../domain/entities/daily_sales_report.dart';
import '../../domain/entities/report_date_filter.dart';
import '../../domain/repositories/reports_repository.dart';
import '../../domain/services/nepali_report_clock.dart';
import '../../domain/services/sales_report_generator.dart';
import '../datasources/reports_local_data_source.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  ReportsRepositoryImpl({
    required ReportsLocalDataSource localDataSource,
    required NepaliReportClock clock,
    required SalesReportGenerator generator,
  }) : _localDataSource = localDataSource,
       _clock = clock,
       _generator = generator;

  final ReportsLocalDataSource _localDataSource;
  final NepaliReportClock _clock;
  final SalesReportGenerator _generator;

  @override
  Future<DailySalesReport> getSalesReport(ReportDateFilter filter) async {
    final orders = await getOrdersForFilter(filter);
    return _generator.buildReport(filter: filter, orders: orders);
  }

  @override
  Future<DailySalesReport> getDayReport(DateTime date) {
    return getSalesReport(ReportDateFilter.customDate(date));
  }

  @override
  Future<List<CalendarSalesDay>> getCalendarSales(DateTime month) async {
    final orderModels = await _localDataSource.getOrdersForMonth(month);
    final orders = orderModels.map((order) => order.toEntity()).toList();
    return _generator.buildCalendar(month: month, orders: orders);
  }

  @override
  Future<AnalyticsDashboard> getDashboard() async {
    final todayReport = await getSalesReport(ReportDateFilter.today());
    final inventoryItems = await getInventoryItems();
    return _generator.buildDashboard(
      todayReport: todayReport,
      inventoryItems: inventoryItems,
    );
  }

  @override
  Future<List<BillingOrder>> getOrdersForFilter(ReportDateFilter filter) async {
    final range = _clock.resolve(filter);
    final orderModels = await _localDataSource.getOrdersBetween(
      startNepaliDate: _clock.compactDate(range.startInclusive),
      endNepaliDate: _clock.compactDate(range.endInclusive),
    );
    return orderModels.map((order) => order.toEntity()).toList();
  }

  @override
  Future<List<InventoryItem>> getInventoryItems() async {
    final itemModels = await _localDataSource.getInventoryItems();
    return itemModels.map((item) => item.toEntity()).toList();
  }
}
