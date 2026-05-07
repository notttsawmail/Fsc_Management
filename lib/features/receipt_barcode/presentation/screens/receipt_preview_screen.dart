import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../billing/domain/entities/billing_order.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../data/services/receipt_formatters.dart';
import '../providers/receipt_barcode_providers.dart';
import 'printer_settings_screen.dart';

class ReceiptPreviewScreen extends ConsumerWidget {
  const ReceiptPreviewScreen({super.key, required this.order});

  final BillingOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final actionState = ref.watch(receiptActionControllerProvider);

    ref.listen<AsyncValue<String?>>(receiptActionControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (message) {
          if (message == null || message.isEmpty) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message.startsWith('/') ? 'Saved to $message' : message,
              ),
            ),
          );
        },
        error: (error, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString()))),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt preview'),
        actions: [
          IconButton(
            tooltip: 'Printer settings',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PrinterSettingsScreen()),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: settings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (appSettings) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          appSettings.shopName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (appSettings.shopAddress.isNotEmpty)
                          Text(
                            appSettings.shopAddress,
                            textAlign: TextAlign.center,
                          ),
                        const Divider(height: 24),
                        _InfoRow(
                          label: 'Token',
                          value: order.tokenNumber.toString(),
                        ),
                        _InfoRow(label: 'Order', value: order.orderId),
                        _InfoRow(
                          label: 'Date',
                          value: receiptDateTime(order.createdAt),
                        ),
                        _InfoRow(
                          label: 'Payment',
                          value: receiptPaymentLabel(order),
                        ),
                        const Divider(height: 24),
                        for (final item in order.items)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemName,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                _InfoRow(
                                  label:
                                      '${item.quantity} x ${receiptMoney(appSettings, item.unitPrice)}',
                                  value: receiptMoney(
                                    appSettings,
                                    item.lineTotal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Divider(height: 24),
                        _InfoRow(
                          label: 'Total',
                          value: receiptMoney(appSettings, order.totalAmount),
                          strong: true,
                        ),
                        const SizedBox(height: 14),
                        const Text('Thank you', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: actionState.isLoading
                    ? null
                    : () => ref
                          .read(receiptActionControllerProvider.notifier)
                          .printThermal(order),
                icon: const Icon(Icons.print_outlined),
                label: const Text('Thermal'),
              ),
              OutlinedButton.icon(
                onPressed: actionState.isLoading
                    ? null
                    : () => ref
                          .read(receiptActionControllerProvider.notifier)
                          .printPdf(order),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Print PDF'),
              ),
              OutlinedButton.icon(
                onPressed: actionState.isLoading
                    ? null
                    : () => ref
                          .read(receiptActionControllerProvider.notifier)
                          .savePdf(order),
                icon: const Icon(Icons.download_outlined),
                label: const Text('Save'),
              ),
              OutlinedButton.icon(
                onPressed: actionState.isLoading
                    ? null
                    : () => ref
                          .read(receiptActionControllerProvider.notifier)
                          .sharePdf(order),
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = strong
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
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
