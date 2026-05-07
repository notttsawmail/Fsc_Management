import 'package:isar/isar.dart';

import '../../../../core/data/app_isar.dart';
import '../../../billing/data/models/billing_order_model.dart';

class ReceiptBarcodeLocalDataSource {
  ReceiptBarcodeLocalDataSource._(this._isar);

  final Isar _isar;

  static Future<ReceiptBarcodeLocalDataSource> open() async {
    final isar = await AppIsar.open();
    return ReceiptBarcodeLocalDataSource._(isar);
  }

  Stream<List<BillingOrderModel>> watchReceiptOrders() {
    return _isar.billingOrderModels.where().sortByCreatedAtDesc().watch(
      fireImmediately: true,
    );
  }

  Future<BillingOrderModel?> getReceiptOrder(int id) {
    return _isar.billingOrderModels.get(id);
  }
}
