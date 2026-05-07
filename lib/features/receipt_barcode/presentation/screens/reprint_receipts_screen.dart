import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/currency_formatters.dart';
import '../../data/services/receipt_formatters.dart';
import '../providers/receipt_barcode_providers.dart';
import 'receipt_preview_screen.dart';

class ReprintReceiptsScreen extends ConsumerWidget {
  const ReprintReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(receiptOrdersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Reprint receipts')),
      body: orders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No receipts found'));
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final order = items[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(order.tokenNumber.toString()),
                ),
                title: Text('Token ${order.tokenNumber}'),
                subtitle: Text(
                  '${receiptDateTime(order.createdAt)} | ${receiptPaymentLabel(order)}',
                ),
                trailing: Text(nepaliRupees(order.totalAmount)),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReceiptPreviewScreen(order: order),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
