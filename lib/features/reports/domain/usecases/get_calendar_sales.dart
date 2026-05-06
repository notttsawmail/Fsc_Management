import '../entities/calendar_sales_day.dart';
import '../repositories/reports_repository.dart';

class GetCalendarSales {
  const GetCalendarSales(this._repository);

  final ReportsRepository _repository;

  Future<List<CalendarSalesDay>> call(DateTime month) {
    return _repository.getCalendarSales(month);
  }
}
