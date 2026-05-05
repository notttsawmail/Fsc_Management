import '../repositories/billing_repository.dart';

class CancelOrder {
  const CancelOrder(this._repository);

  final BillingRepository _repository;

  Future<void> call(int id) => _repository.cancelOrder(id);
}
