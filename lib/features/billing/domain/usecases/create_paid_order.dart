import '../entities/billing_order.dart';
import '../repositories/billing_repository.dart';

class CreatePaidOrder {
  const CreatePaidOrder(this._repository);

  final BillingRepository _repository;

  Future<BillingOrder> call(BillingOrder draft) {
    if (draft.items.isEmpty) {
      throw ArgumentError('Cart is empty.');
    }
    if (draft.totalAmount <= 0) {
      throw ArgumentError('Order total must be greater than zero.');
    }
    return _repository.createPaidOrder(draft);
  }
}
