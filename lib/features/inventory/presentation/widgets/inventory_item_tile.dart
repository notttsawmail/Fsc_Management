import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddEditInventoryItemScreen(item: item),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ItemImagePreview(imagePath: item.imagePath),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (item.isLowStock)
                          Tooltip(
                            message: 'Low stock',
                            child: Icon(
                              Icons.warning_amber_rounded,
                              size: 20,
                              color: theme.colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.itemCode} • ${item.category}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _QuantityStepper(item: item),
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(
                            item.isTrackableInventory
                                ? 'Tracked'
                                : 'Not tracked',
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Decrease quantity',
            visualDensity: VisualDensity.compact,
            onPressed: item.quantity == 0
                ? null
                : () => ref
                      .read(inventoryControllerProvider.notifier)
                      .adjustQuantity(id: item.id, delta: -1),
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          IconButton(
            tooltip: 'Increase quantity',
            visualDensity: VisualDensity.compact,
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

enum _InventoryAction { edit, delete }
