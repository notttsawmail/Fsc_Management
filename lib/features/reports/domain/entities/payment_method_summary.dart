import '../../../billing/domain/entities/billing_enums.dart';

class PaymentMethodSummary {
  const PaymentMethodSummary({
    required this.paymentMethod,
    required this.orderCount,
    required this.totalAmount,
  });

  final PaymentMethod paymentMethod;
  final int orderCount;
  final double totalAmount;
}
