import 'package:isar/isar.dart';

import '../../domain/entities/billing_enums.dart';
import '../../domain/entities/billing_order.dart';
import '../../domain/entities/billing_order_item.dart';

part 'billing_order_model.g.dart';

@collection
class BillingOrderModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String orderId;

  @Index(composite: [CompositeIndex('nepaliDate')])
  late int tokenNumber;

  @Index(caseSensitive: false)
  late String nepaliDate;

  late List<BillingOrderItemModel> items;
  late double subtotal;
  late double totalAmount;
  late String paymentMethod;
  late String paymentStatus;
  late String orderStatus;

  @Index()
  late DateTime createdAt;

  BillingOrder toEntity() {
    return BillingOrder(
      id: id,
      orderId: orderId,
      tokenNumber: tokenNumber,
      items: items.map((item) => item.toEntity()).toList(),
      subtotal: subtotal,
      totalAmount: totalAmount,
      paymentMethod: _paymentMethodFromName(paymentMethod),
      paymentStatus: _paymentStatusFromName(paymentStatus),
      orderStatus: _orderStatusFromName(orderStatus),
      createdAt: createdAt,
      nepaliDate: nepaliDate,
    );
  }

  static BillingOrderModel fromEntity(BillingOrder order) {
    return BillingOrderModel()
      ..id = order.id == 0 ? Isar.autoIncrement : order.id
      ..orderId = order.orderId
      ..tokenNumber = order.tokenNumber
      ..nepaliDate = order.nepaliDate
      ..items = order.items
          .map(BillingOrderItemModel.fromEntity)
          .toList(growable: false)
      ..subtotal = order.subtotal
      ..totalAmount = order.totalAmount
      ..paymentMethod = order.paymentMethod.name
      ..paymentStatus = order.paymentStatus.name
      ..orderStatus = order.orderStatus.name
      ..createdAt = order.createdAt;
  }

  static PaymentMethod _paymentMethodFromName(String name) {
    return PaymentMethod.values.firstWhere(
      (value) => value.name == name,
      orElse: () => PaymentMethod.cash,
    );
  }

  static PaymentStatus _paymentStatusFromName(String name) {
    return PaymentStatus.values.firstWhere(
      (value) => value.name == name,
      orElse: () => PaymentStatus.pending,
    );
  }

  static OrderStatus _orderStatusFromName(String name) {
    return OrderStatus.values.firstWhere(
      (value) => value.name == name,
      orElse: () => OrderStatus.pending,
    );
  }
}

@embedded
class BillingOrderItemModel {
  late int inventoryItemId;
  late String itemName;
  late String itemCode;
  late double unitPrice;
  late int quantity;
  late double lineTotal;

  BillingOrderItem toEntity() {
    return BillingOrderItem(
      inventoryItemId: inventoryItemId,
      itemName: itemName,
      itemCode: itemCode,
      unitPrice: unitPrice,
      quantity: quantity,
      lineTotal: lineTotal,
    );
  }

  static BillingOrderItemModel fromEntity(BillingOrderItem item) {
    return BillingOrderItemModel()
      ..inventoryItemId = item.inventoryItemId
      ..itemName = item.itemName
      ..itemCode = item.itemCode
      ..unitPrice = item.unitPrice
      ..quantity = item.quantity
      ..lineTotal = item.lineTotal;
  }
}
