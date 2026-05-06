import '../entities/analytics_dashboard.dart';
import '../repositories/reports_repository.dart';

class GetAnalyticsDashboard {
  const GetAnalyticsDashboard(this._repository);

  final ReportsRepository _repository;

  Future<AnalyticsDashboard> call() {
    return _repository.getDashboard();
  }
}
