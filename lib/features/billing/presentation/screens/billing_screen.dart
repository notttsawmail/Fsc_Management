import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/currency_formatters.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../../../inventory/presentation/widgets/item_image_preview.dart';
import '../../../receipt_barcode/presentation/providers/receipt_barcode_providers.dart';
import '../../domain/entities/billing_order.dart';
import '../providers/billing_providers.dart';
import '../widgets/cart_panel.dart';
import '../widgets/item_quantity_controls.dart';
import '../widgets/payment_dialog.dart';
import 'order_success_screen.dart';

class BillingScreen extends ConsumerWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final token = ref.watch(nextTokenProvider);
    final isBusy = ref.watch(billingControllerProvider).isLoading;

    ref.listen<AsyncValue<int>>(nextTokenProvider, (previous, next) {
      next.whenData(
        (value) => ref.read(cartProvider.notifier).syncNextTokenSeed(value),
      );
    });

    ref.listen<AsyncValue<BillingOrder?>>(billingControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: token.when(
                data: (value) => Text('Next $value'),
                loading: () => const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, _) => const Text('Token unavailable'),
              ),
            ),
          ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: isBusy,
        child: Column(
          children: [
            _TokenTabs(cart: cart),
            const Divider(height: 1),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 1100;
                  final isTablet = constraints.maxWidth >= 720;
                  final inventoryPane = _InventorySearchPane(cart: cart);
                  final cartPane = CartPanel(
                    onCheckout: () => _showPaymentDialog(context, ref),
                  );

                  if (isDesktop) {
                    final cartWidth = (constraints.maxWidth * 0.34).clamp(
                      380.0,
                      460.0,
                    );
                    return Row(
                      children: [
                        Expanded(flex: 3, child: inventoryPane),
                        const VerticalDivider(width: 1),
                        SizedBox(width: cartWidth, child: cartPane),
                      ],
                    );
                  }

                  if (isTablet) {
                    return Row(
                      children: [
                        Expanded(flex: 5, child: inventoryPane),
                        const VerticalDivider(width: 1),
                        Expanded(flex: 4, child: cartPane),
                      ],
                    );
                  }

                  return _MobileBillingLayout(
                    inventoryPane: inventoryPane,
                    cartPane: cartPane,
                    hasItems: !cart.isEmpty,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPaymentDialog(BuildContext context, WidgetRef ref) async {
    final cart = ref.read(cartProvider).activeToken;
    final paymentMethod = ref.read(selectedPaymentMethodProvider);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => PaymentDialog(
        paymentMethod: paymentMethod,
        totalAmount: cart.totalAmount,
        onConfirm: () async {
          Navigator.of(dialogContext).pop();
          try {
            final order = await ref
                .read(billingControllerProvider.notifier)
                .confirmPayment(paymentMethod);
            final printerSettings = await ref.read(
              printerSettingsProvider.future,
            );
            if (printerSettings.autoPrintAfterBilling) {
              try {
                await ref
                    .read(receiptActionControllerProvider.notifier)
                    .printThermal(order);
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Auto print failed: $error')),
                  );
                }
              }
            }
            if (context.mounted) {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OrderSuccessScreen(order: order),
                ),
              );
            }
          } catch (_) {
            // Provider listener displays the error.
          }
        },
      ),
    );
  }
}

class _MobileBillingLayout extends ConsumerWidget {
  const _MobileBillingLayout({
    required this.inventoryPane,
    required this.cartPane,
    required this.hasItems,
  });

  final Widget inventoryPane;
  final Widget cartPane;
  final bool hasItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(billingMobileTabProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  icon: Icon(Icons.restaurant_menu_outlined),
                  label: Text('Items'),
                ),
                ButtonSegment(
                  value: 1,
                  icon: Icon(Icons.receipt_long_outlined),
                  label: Text('Cart'),
                ),
              ],
              selected: {selectedTab},
              showSelectedIcon: false,
              onSelectionChanged: (selection) {
                ref.read(billingMobileTabProvider.notifier).state =
                    selection.first;
              },
            ),
          ),
        ),
        Expanded(child: selectedTab == 0 ? inventoryPane : cartPane),
      ],
    );
  }
}

class _TokenTabs extends ConsumerWidget {
  const _TokenTabs({required this.cart});

  final CartState cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(cartProvider.notifier);
    final activeToken = cart.activeToken;
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 640;
          final veryCompact = constraints.maxWidth < 390;
          final summaryCard = InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _showTokenManager(context),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    activeToken.isEmpty
                        ? Icons.confirmation_number_outlined
                        : Icons.receipt_long_outlined,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Token ${activeToken.tokenNumber}',
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${cart.tokens.length} open | ${activeToken.totalItems} items | ${nepaliRupees(activeToken.totalAmount, decimals: false)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          );

          final tokenButton = compact
              ? IconButton.filledTonal(
                  tooltip: 'Open tokens',
                  onPressed: () => _showTokenManager(context),
                  icon: const Icon(Icons.table_restaurant_outlined),
                )
              : FilledButton.tonalIcon(
                  onPressed: () => _showTokenManager(context),
                  icon: const Icon(Icons.table_restaurant_outlined),
                  label: Text('Open tokens (${cart.tokens.length})'),
                );

          final newTokenButton = compact
              ? IconButton.filled(
                  tooltip: 'New token',
                  onPressed: controller.addToken,
                  icon: const Icon(Icons.add),
                )
              : FilledButton.icon(
                  onPressed: controller.addToken,
                  icon: const Icon(Icons.add),
                  label: const Text('New token'),
                );

          if (veryCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                summaryCard,
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: tokenButton),
                    const SizedBox(width: 8),
                    newTokenButton,
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: summaryCard),
              const SizedBox(width: 8),
              tokenButton,
              const SizedBox(width: 8),
              newTokenButton,
            ],
          );
        },
      ),
    );
  }

  Future<void> _showTokenManager(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 720) {
      return showDialog<void>(
        context: context,
        builder: (_) => const Dialog(
          insetPadding: EdgeInsets.all(24),
          child: SizedBox(width: 620, child: _TokenManager()),
        ),
      );
    }
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) {
        final height = MediaQuery.sizeOf(context).height * 0.8;
        return SafeArea(
          child: SizedBox(height: height, child: _TokenManager()),
        );
      },
    );
  }
}

class _TokenManager extends ConsumerStatefulWidget {
  const _TokenManager();

  @override
  ConsumerState<_TokenManager> createState() => _TokenManagerState();
}

class _TokenManagerState extends ConsumerState<_TokenManager> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final controller = ref.read(cartProvider.notifier);
    final query = _searchQuery.trim();
    final filteredTokens = query.isEmpty
        ? cart.tokens
        : cart.tokens
              .where((token) => token.tokenNumber.toString().contains(query))
              .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Open tokens',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: controller.addToken,
                icon: const Icon(Icons.add),
                label: const Text('New'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Search token number',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () => setState(() => _searchQuery = ''),
                      icon: const Icon(Icons.close),
                    ),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredTokens.isEmpty
                ? const Center(child: Text('No matching tokens'))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final narrow = constraints.maxWidth < 430;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: constraints.maxWidth >= 560
                              ? 280
                              : 420,
                          mainAxisExtent: narrow ? 174 : 158,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: filteredTokens.length,
                        itemBuilder: (context, index) {
                          final token = filteredTokens[index];
                          final isActive = token.id == cart.activeTokenId;
                          return InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              controller.selectToken(token.id);
                              Navigator.of(context).maybePop();
                            },
                            child: Ink(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer
                                    : Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                  color: isActive
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).dividerColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        child: Text(
                                          token.tokenNumber.toString(),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Token ${token.tokenNumber}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isActive)
                                        const Icon(Icons.check_circle),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text('${token.totalItems} items'),
                                  Text(
                                    nepaliRupees(token.totalAmount),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const Spacer(),
                                  if (narrow)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: () {
                                              controller.selectToken(token.id);
                                              Navigator.of(context).maybePop();
                                            },
                                            icon: const Icon(
                                              Icons.login_outlined,
                                            ),
                                            label: const Text('Open'),
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: 'Clear',
                                          onPressed: token.isEmpty
                                              ? null
                                              : () => controller.clearToken(
                                                  token.id,
                                                ),
                                          icon: const Icon(
                                            Icons.delete_sweep_outlined,
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: 'Remove token',
                                          onPressed: () =>
                                              controller.closeToken(token.id),
                                          icon: const Icon(Icons.close),
                                        ),
                                      ],
                                    )
                                  else
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              controller.selectToken(token.id);
                                              Navigator.of(context).maybePop();
                                            },
                                            child: const Text('Open'),
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: 'Clear',
                                          onPressed: token.isEmpty
                                              ? null
                                              : () => controller.clearToken(
                                                  token.id,
                                                ),
                                          icon: const Icon(
                                            Icons.delete_sweep_outlined,
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: 'Remove token',
                                          onPressed: () =>
                                              controller.closeToken(token.id),
                                          icon: const Icon(Icons.close),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _InventorySearchPane extends ConsumerWidget {
  const _InventorySearchPane({required this.cart});

  final CartState cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(billingInventoryItemsProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search item name, code, or category',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Clear search',
                onPressed: () =>
                    ref.read(billingSearchQueryProvider.notifier).state = '',
                icon: const Icon(Icons.close),
              ),
            ),
            onChanged: (value) =>
                ref.read(billingSearchQueryProvider.notifier).state = value,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: items.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Unable to load inventory: $error')),
              data: (inventoryItems) {
                if (inventoryItems.isEmpty) {
                  return const Center(child: Text('No matching items'));
                }
                return ListView.separated(
                  itemCount: inventoryItems.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = inventoryItems[index];
                    return _BillingInventoryTile(item: item, cart: cart);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BillingInventoryTile extends ConsumerWidget {
  const _BillingInventoryTile({required this.item, required this.cart});

  final InventoryItem item;
  final CartState cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = cart.availableFor(item);
    final canAdd = !item.isTrackableInventory || available > 0;
    final activeQuantity = cart.activeQuantityFor(item.id);
    final stockText = item.isTrackableInventory
        ? 'Available: $available'
        : 'Not tracked';

    void addItem() {
      try {
        ref.read(cartProvider.notifier).addItem(item);
      } catch (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }

    final controls = activeQuantity > 0
        ? ItemQuantityControls(
            quantity: activeQuantity,
            canIncrease: canAdd,
            onDecrease: () =>
                ref.read(cartProvider.notifier).decreaseQuantity(item.id),
            onIncrease: addItem,
          )
        : FilledButton.tonalIcon(
            onPressed: canAdd ? addItem : null,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add'),
          );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: canAdd ? addItem : null,
            child: Ink(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _ItemImage(imagePath: item.imagePath),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ItemDetails(
                                item: item,
                                stockText: stockText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              nepaliRupees(item.price),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            controls,
                          ],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        _ItemImage(imagePath: item.imagePath),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ItemDetails(item: item, stockText: stockText),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              nepaliRupees(item.price),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            controls,
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _ItemImage extends StatelessWidget {
  const _ItemImage({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return ItemImagePreview(imagePath: imagePath, size: 64);
  }
}

class _ItemDetails extends StatelessWidget {
  const _ItemDetails({required this.item, required this.stockText});

  final InventoryItem item;
  final String stockText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lowStock = item.isLowStock;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _BillingMetaBadge(icon: Icons.tag_outlined, label: item.itemCode),
            _BillingMetaBadge(
              icon: Icons.category_outlined,
              label: item.category,
            ),
            _BillingMetaBadge(
              icon: lowStock
                  ? Icons.warning_amber_rounded
                  : Icons.inventory_2_outlined,
              label: stockText,
              backgroundColor: lowStock
                  ? theme.colorScheme.errorContainer
                  : theme.colorScheme.surfaceContainerHighest,
              foregroundColor: lowStock
                  ? theme.colorScheme.onErrorContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ],
    );
  }
}

class _BillingMetaBadge extends StatelessWidget {
  const _BillingMetaBadge({
    required this.icon,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final fg = foregroundColor ?? theme.colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
