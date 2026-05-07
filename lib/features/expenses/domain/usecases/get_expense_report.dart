import '../entities/expense_report.dart';
import '../repositories/expense_repository.dart';

class GetExpenseReport {
  const GetExpenseReport(this._repository);

  final ExpenseRepository _repository;

  Future<ExpenseReport> call({
    required DateTime startInclusive,
    required DateTime endInclusive,
    required String label,
  }) {
    return _repository.getReport(
      startInclusive: startInclusive,
      endInclusive: endInclusive,
      label: label,
    );
  }
}
