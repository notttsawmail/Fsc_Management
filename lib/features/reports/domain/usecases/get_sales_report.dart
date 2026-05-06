import '../entities/daily_sales_report.dart';
import '../entities/report_date_filter.dart';
import '../repositories/reports_repository.dart';

class GetSalesReport {
  const GetSalesReport(this._repository);

  final ReportsRepository _repository;

  Future<DailySalesReport> call(ReportDateFilter filter) {
    return _repository.getSalesReport(filter);
  }
}
