import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/inventory_providers.dart';
import '../widgets/inventory_empty_state.dart';
import '../widgets/inventory_item_tile.dart';
import '../widgets/inventory_loading_state.dart';
import 'add_edit_inventory_item_screen.dart';

class InventoryListScreen extends ConsumerStatefulWidget {
  const InventoryListScreen({super.key});

  @override
  ConsumerState<InventoryListScreen> createState() =>
      _InventoryListScreenState();
}

class _InventoryListScreenState extends ConsumerState<InventoryListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(inventorySearchQueryProvider);
    final inventoryItems = ref.watch(inventoryItemsProvider);
    final controllerState = ref.watch(inventoryControllerProvider);

    ref.listen<AsyncValue<void>>(inventoryControllerProvider, (previous, next) {
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
        title: const Text('Inventory'),
        actions: [
          if (controllerState.isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search by item name, code, or category',
              leading: const Icon(Icons.search),
              trailing: [
                if (searchQuery.isNotEmpty)
                  IconButton(
                    tooltip: 'Clear search',
                    onPressed: () {
                      _searchController.clear();
                      ref.read(inventorySearchQueryProvider.notifier).state =
                          '';
                    },
                    icon: const Icon(Icons.close),
                  ),
              ],
              onChanged: (value) {
                ref.read(inventorySearchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: inventoryItems.when(
              loading: () => const InventoryLoadingState(),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(error.toString(), textAlign: TextAlign.center),
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return InventoryEmptyState(
                    isSearching: searchQuery.isNotEmpty,
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(inventoryItemsProvider);
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 96),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return InventoryItemTile(item: items[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddEditInventoryItemScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
    );
  }
}
