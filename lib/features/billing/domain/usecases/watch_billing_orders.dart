import '../entities/billing_order.dart';
import '../repositories/billing_repository.dart';

class WatchBillingOrders {
  const WatchBillingOrders(this._repository);

  final BillingRepository _repository;

  Stream<List<BillingOrder>> call() => _repository.watchOrders();
}
