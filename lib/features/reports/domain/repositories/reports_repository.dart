import '../../../billing/domain/entities/billing_order.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../entities/analytics_dashboard.dart';
import '../entities/calendar_sales_day.dart';
import '../entities/daily_sales_report.dart';
import '../entities/report_date_filter.dart';

abstract class ReportsRepository {
  Future<DailySalesReport> getSalesReport(ReportDateFilter filter);

  Future<List<CalendarSalesDay>> getCalendarSales(DateTime month);

  Future<DailySalesReport> getDayReport(DateTime date);

  Future<AnalyticsDashboard> getDashboard();

  Future<List<BillingOrder>> getOrdersForFilter(ReportDateFilter filter);

  Future<List<InventoryItem>> getInventoryItems();
}
