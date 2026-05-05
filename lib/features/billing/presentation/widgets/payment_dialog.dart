import 'package:flutter/material.dart';

import '../../domain/entities/billing_enums.dart';

class PaymentDialog extends StatelessWidget {
  const PaymentDialog({
    super.key,
    required this.paymentMethod,
    required this.totalAmount,
    required this.onConfirm,
  });

  final PaymentMethod paymentMethod;
  final double totalAmount;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final isPhonePay = paymentMethod == PaymentMethod.phonePay;
    return AlertDialog(
      title: Text(isPhonePay ? 'Phone Pay payment' : 'Cash payment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total: Rs ${totalAmount.toStringAsFixed(2)}'),
          if (isPhonePay) ...[
            const SizedBox(height: 12),
            const Text(
              'Confirm only after the Phone Pay payment is completed.',
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: onConfirm,
          child: Text(isPhonePay ? 'Payment completed' : 'Mark paid'),
        ),
      ],
    );
  }
}
