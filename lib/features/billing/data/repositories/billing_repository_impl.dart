import '../../domain/entities/billing_order.dart';
import '../../domain/repositories/billing_repository.dart';
import '../datasources/billing_local_data_source.dart';
import '../models/billing_order_model.dart';

class BillingRepositoryImpl implements BillingRepository {
  BillingRepositoryImpl(this._localDataSource);

  final BillingLocalDataSource _localDataSource;

  @override
  Future<int> nextTokenNumber({required String nepaliDate}) {
    return _localDataSource.nextTokenNumber(nepaliDate: nepaliDate);
  }

  @override
  Future<BillingOrder> createPaidOrder(BillingOrder draft) async {
    final saved = await _localDataSource.createPaidOrder(
      BillingOrderModel.fromEntity(draft),
    );
    return saved.toEntity();
  }

  @override
  Future<void> cancelOrder(int id) => _localDataSource.cancelOrder(id);

  @override
  Stream<List<BillingOrder>> watchOrders() {
    return _localDataSource.watchOrders().map(
      (orders) => orders.map((order) => order.toEntity()).toList(),
    );
  }
}
