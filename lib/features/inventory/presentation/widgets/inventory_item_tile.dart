import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/currency_formatters.dart';
import '../../domain/entities/inventory_item.dart';
import '../providers/inventory_providers.dart';
import '../screens/add_edit_inventory_item_screen.dart';
import 'item_image_preview.dart';

class InventoryItemTile extends ConsumerWidget {
  const InventoryItemTile({super.key, required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final quantityLabel = item.isTrackableInventory
        ? '${item.quantity} in stock'
        : 'Stock not tracked';
    final stockTone = item.isLowStock
        ? theme.colorScheme.errorContainer
        : theme.colorScheme.secondaryContainer;
    final stockTextTone = item.isLowStock
        ? theme.colorScheme.onErrorContainer
        : theme.colorScheme.onSecondaryContainer;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddEditInventoryItemScreen(item: item),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemImagePreview(imagePath: item.imagePath, size: 78),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                            ),
                          ),
                        ),
                        if (item.isLowStock)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  size: 16,
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Low stock',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onErrorContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MetaBadge(
                          icon: Icons.tag_outlined,
                          label: item.itemCode,
                        ),
                        _MetaBadge(
                          icon: Icons.category_outlined,
                          label: item.category,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            nepaliRupees(item.price),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: stockTone,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            quantityLabel,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: stockTextTone,
                            ),
                          ),
                        ),
                        _QuantityStepper(item: item),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            item.isTrackableInventory
                                ? 'Tracked inventory'
                                : 'Catalog only',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_InventoryAction>(
                tooltip: 'Item actions',
                onSelected: (action) async {
                  switch (action) {
                    case _InventoryAction.edit:
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              AddEditInventoryItemScreen(item: item),
                        ),
                      );
                    case _InventoryAction.delete:
                      if (!context.mounted) return;
                      await _confirmDelete(context, ref);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _InventoryAction.edit,
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit'),
                    ),
                  ),
                  PopupMenuItem(
                    value: _InventoryAction.delete,
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('This will remove ${item.name} from inventory.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;
    await ref.read(inventoryControllerProvider.notifier).deleteItem(item.id);
  }
}

class _QuantityStepper extends ConsumerWidget {
  const _QuantityStepper({required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Decrease quantity',
            constraints: const BoxConstraints.tightFor(width: 42, height: 42),
            onPressed: item.quantity == 0
                ? null
                : () => ref
                      .read(inventoryControllerProvider.notifier)
                      .adjustQuantity(id: item.id, delta: -1),
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 44,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            tooltip: 'Increase quantity',
            constraints: const BoxConstraints.tightFor(width: 42, height: 42),
            onPressed: () => ref
                .read(inventoryControllerProvider.notifier)
                .adjustQuantity(id: item.id, delta: 1),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum _InventoryAction { edit, delete }
