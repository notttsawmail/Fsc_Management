import '../entities/billing_order.dart';

abstract class BillingRepository {
  Future<int> nextTokenNumber({required String nepaliDate});

  Future<BillingOrder> createPaidOrder(BillingOrder draft);

  Future<void> cancelOrder(int id);

  Stream<List<BillingOrder>> watchOrders();
}
