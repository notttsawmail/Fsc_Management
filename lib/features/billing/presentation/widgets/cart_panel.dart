import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/currency_formatters.dart';
import '../../domain/entities/billing_enums.dart';
import '../providers/billing_providers.dart';
import 'item_quantity_controls.dart';

class CartPanel extends ConsumerWidget {
  const CartPanel({super.key, required this.onCheckout});

  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final activeToken = cart.activeToken;
    final cartController = ref.read(cartProvider.notifier);
    final paymentMethod = ref.watch(selectedPaymentMethodProvider);

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 240),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Token ${activeToken.tokenNumber}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${cart.tokens.length} open token${cart.tokens.length == 1 ? '' : 's'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('${cart.totalItems} items'),
                    IconButton(
                      tooltip: 'Clear token',
                      onPressed: cart.isEmpty ? null : cartController.clear,
                      icon: const Icon(Icons.delete_sweep_outlined),
                    ),
                    IconButton(
                      tooltip: 'Close token',
                      onPressed: cartController.closeActiveToken,
                      icon: const Icon(Icons.close_fullscreen_outlined),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: cart.isEmpty
                  ? const Center(child: Text('No items in this token'))
                  : ListView.separated(
                      itemCount: activeToken.items.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final cartItem = activeToken.items[index];
                        final available = cart.availableFor(cartItem.item);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      cartItem.item.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Remove',
                                    onPressed: () => cartController.removeItem(
                                      cartItem.item.id,
                                    ),
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                              Text('${nepaliRupees(cartItem.item.price)} each'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  ItemQuantityControls(
                                    quantity: cartItem.quantity,
                                    canIncrease:
                                        !cartItem.item.isTrackableInventory ||
                                        available > 0,
                                    onDecrease: () => cartController
                                        .decreaseQuantity(cartItem.item.id),
                                    onIncrease: () => cartController
                                        .increaseQuantity(cartItem.item),
                                  ),
                                  const Spacer(),
                                  Flexible(
                                    child: Text(
                                      nepaliRupees(cartItem.lineTotal),
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            _TotalRow(label: 'Subtotal', value: activeToken.subtotal),
            _TotalRow(
              label: 'Total',
              value: activeToken.totalAmount,
              isTotal: true,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField(
              initialValue: paymentMethod,
              decoration: const InputDecoration(labelText: 'Payment method'),
              items: const [
                DropdownMenuItem(
                  value: PaymentMethod.cash,
                  child: Text('Cash'),
                ),
                DropdownMenuItem(
                  value: PaymentMethod.phonePay,
                  child: Text('Phone Pay'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(selectedPaymentMethodProvider.notifier).state =
                      value;
                }
              },
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: cart.isEmpty ? null : onCheckout,
              icon: const Icon(Icons.payments_outlined),
              label: const Text('Confirm payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final double value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final style = isTotal
        ? Theme.of(context).textTheme.titleLarge
        : Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Flexible(
            child: Text(
              nepaliRupees(value),
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
