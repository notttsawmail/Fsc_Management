import 'package:flutter/material.dart';

import '../../../../core/formatters/currency_formatters.dart';
import '../../domain/entities/billing_enums.dart';
import '../../domain/entities/billing_order.dart';
import '../../../receipt_barcode/presentation/screens/receipt_preview_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.order});

  final BillingOrder order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order complete')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                const Icon(Icons.check_circle, size: 72, color: Colors.green),
                const SizedBox(height: 12),
                Text(
                  'Token ${order.tokenNumber}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(order.orderId),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _InfoRow(label: 'Date', value: order.nepaliDate),
          _InfoRow(label: 'Payment', value: order.paymentMethod.label),
          _InfoRow(label: 'Status', value: order.orderStatus.label),
          const Divider(height: 32),
          ...order.items.map(
            (item) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item.itemName),
              subtitle: Text(
                '${item.quantity} x ${nepaliRupees(item.unitPrice)}',
              ),
              trailing: Text(nepaliRupees(item.lineTotal)),
            ),
          ),
          const Divider(height: 32),
          _InfoRow(
            label: 'Total',
            value: nepaliRupees(order.totalAmount),
            isStrong: true,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ReceiptPreviewScreen(order: order),
              ),
            ),
            icon: const Icon(Icons.receipt_long_outlined),
            label: const Text('Receipt'),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.point_of_sale_outlined),
            label: const Text('New bill'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  final String label;
  final String value;
  final bool isStrong;

  @override
  Widget build(BuildContext context) {
    final style = isStrong
        ? Theme.of(context).textTheme.titleLarge
        : Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              style: style,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
