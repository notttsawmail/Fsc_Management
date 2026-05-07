import '../../../../core/formatters/currency_formatters.dart';
import '../../../billing/domain/entities/billing_enums.dart';
import '../../../billing/domain/entities/billing_order.dart';
import '../../../settings/domain/entities/app_settings.dart';

String receiptMoney(AppSettings settings, double amount) {
  return nepaliRupees(amount);
}

String receiptDateTime(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '${value.year}-$month-$day $hour:$minute';
}

String receiptFileName(BillingOrder order) {
  return 'receipt_token_${order.tokenNumber}_${order.orderId}.pdf'.replaceAll(
    RegExp(r'[^A-Za-z0-9_.-]'),
    '_',
  );
}

String receiptPaymentLabel(BillingOrder order) => order.paymentMethod.label;
