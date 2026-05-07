import '../entities/expense_analytics.dart';
import '../repositories/expense_repository.dart';

class GetExpenseAnalytics {
  const GetExpenseAnalytics(this._repository);

  final ExpenseRepository _repository;

  Future<ExpenseAnalytics> call({
    required DateTime startInclusive,
    required DateTime endInclusive,
  }) {
    return _repository.getAnalytics(
      startInclusive: startInclusive,
      endInclusive: endInclusive,
    );
  }
}
