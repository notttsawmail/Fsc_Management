import '../entities/expense.dart';
import '../entities/expense_filters.dart';
import '../repositories/expense_repository.dart';

class WatchExpenses {
  const WatchExpenses(this._repository);

  final ExpenseRepository _repository;

  Stream<List<Expense>> call(ExpenseFilters filters) {
    return _repository.watchExpenses(filters);
  }
}
