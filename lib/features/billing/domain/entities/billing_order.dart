import 'billing_enums.dart';
import 'billing_order_item.dart';

class BillingOrder {
  const BillingOrder({
    required this.id,
    required this.orderId,
    required this.tokenNumber,
    required this.items,
    required this.subtotal,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.createdAt,
    required this.nepaliDate,
  });

  final int id;
  final String orderId;
  final int tokenNumber;
  final List<BillingOrderItem> items;
  final double subtotal;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final DateTime createdAt;
  final String nepaliDate;

  BillingOrder copyWith({
    int? id,
    String? orderId,
    int? tokenNumber,
    List<BillingOrderItem>? items,
    double? subtotal,
    double? totalAmount,
    PaymentMethod? paymentMethod,
    PaymentStatus? paymentStatus,
    OrderStatus? orderStatus,
    DateTime? createdAt,
    String? nepaliDate,
  }) {
    return BillingOrder(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      createdAt: createdAt ?? this.createdAt,
      nepaliDate: nepaliDate ?? this.nepaliDate,
    );
  }
}
