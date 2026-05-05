import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/inventory_local_data_source.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/usecases/add_inventory_item.dart';
import '../../domain/usecases/adjust_inventory_quantity.dart';
import '../../domain/usecases/delete_inventory_item.dart';
import '../../domain/usecases/update_inventory_item.dart';
import '../../domain/usecases/watch_inventory_items.dart';

final inventoryLocalDataSourceProvider =
    FutureProvider<InventoryLocalDataSource>((ref) {
      return InventoryLocalDataSource.open();
    });

final inventoryRepositoryProvider = FutureProvider<InventoryRepository>((
  ref,
) async {
  final dataSource = await ref.watch(inventoryLocalDataSourceProvider.future);
  return InventoryRepositoryImpl(dataSource);
});

final inventorySearchQueryProvider = StateProvider<String>((ref) => '');

final inventoryItemsProvider = StreamProvider.autoDispose<List<InventoryItem>>((
  ref,
) async* {
  final repository = await ref.watch(inventoryRepositoryProvider.future);
  final searchQuery = ref.watch(inventorySearchQueryProvider);
  yield* WatchInventoryItems(repository)(searchQuery: searchQuery);
});

final inventoryCategoriesProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  final repository = await ref.watch(inventoryRepositoryProvider.future);
  return repository.getCategories();
});

final inventoryControllerProvider =
    StateNotifierProvider<InventoryController, AsyncValue<void>>((ref) {
      return InventoryController(ref);
    });

class InventoryController extends StateNotifier<AsyncValue<void>> {
  InventoryController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<InventoryRepository> get _repository =>
      _ref.read(inventoryRepositoryProvider.future);

  Future<void> addItem(InventoryItem item) async {
    await _run(() async {
      final repository = await _repository;
      await AddInventoryItem(repository)(item);
      _ref.invalidate(inventoryCategoriesProvider);
    });
  }

  Future<void> updateItem(InventoryItem item) async {
    await _run(() async {
      final repository = await _repository;
      await UpdateInventoryItem(repository)(item);
      _ref.invalidate(inventoryCategoriesProvider);
    });
  }

  Future<void> deleteItem(int id) async {
    await _run(() async {
      final repository = await _repository;
      await DeleteInventoryItem(repository)(id);
      _ref.invalidate(inventoryCategoriesProvider);
    });
  }

  Future<void> adjustQuantity({required int id, required int delta}) async {
    await _run(() async {
      final repository = await _repository;
      await AdjustInventoryQuantity(repository)(id: id, delta: delta);
    });
  }

  Future<String> saveImageLocally(String sourcePath) async {
    final repository = await _repository;
    return repository.saveImageLocally(sourcePath);
  }

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
