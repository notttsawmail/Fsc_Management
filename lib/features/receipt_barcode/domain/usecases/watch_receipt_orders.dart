import '../../../billing/domain/entities/billing_order.dart';
import '../repositories/receipt_barcode_repository.dart';

class WatchReceiptOrders {
  const WatchReceiptOrders(this._repository);

  final ReceiptBarcodeRepository _repository;

  Stream<List<BillingOrder>> call() => _repository.watchReceiptOrders();
}
