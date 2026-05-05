import 'package:flutter/material.dart';

class InventoryEmptyState extends StatelessWidget {
  const InventoryEmptyState({super.key, required this.isSearching});

  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSearching
                  ? Icons.search_off_rounded
                  : Icons.inventory_2_outlined,
              size: 72,
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'No matching items' : 'No inventory items yet',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try searching by name, item code, or category.'
                  : 'Add your first stock item to start tracking inventory.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
