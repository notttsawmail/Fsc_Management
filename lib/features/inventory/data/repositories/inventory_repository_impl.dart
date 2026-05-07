import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_data_source.dart';
import '../models/inventory_item_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl(this._localDataSource);

  final InventoryLocalDataSource _localDataSource;

  @override
  Stream<List<InventoryItem>> watchItems({String searchQuery = ''}) {
    return _localDataSource
        .watchItems(searchQuery: searchQuery)
        .map((items) => items.map((item) => item.toEntity()).toList());
  }

  @override
  Future<List<String>> getCategories() => _localDataSource.getCategories();

  @override
  Future<InventoryItem?> findByBarcode(String barcode) async {
    final item = await _localDataSource.findByBarcode(barcode);
    return item?.toEntity();
  }

  @override
  Future<bool> isBarcodeUnique({
    required String barcode,
    int? excludingItemId,
  }) {
    return _localDataSource.isBarcodeUnique(
      barcode: barcode,
      excludingItemId: excludingItemId,
    );
  }

  @override
  Future<void> addItem(InventoryItem item) {
    final now = DateTime.now();
    final itemToSave = item.copyWith(
      id: 0,
      quantity: item.quantity < 0 ? 0 : item.quantity,
      createdAt: now,
      updatedAt: now,
    );
    return _localDataSource.putItem(InventoryItemModel.fromEntity(itemToSave));
  }

  @override
  Future<void> updateItem(InventoryItem item) {
    final itemToSave = item.copyWith(
      quantity: item.quantity < 0 ? 0 : item.quantity,
      updatedAt: DateTime.now(),
    );
    return _localDataSource.putItem(InventoryItemModel.fromEntity(itemToSave));
  }

  @override
  Future<void> deleteItem(int id) => _localDataSource.deleteItem(id);

  @override
  Future<void> adjustQuantity({required int id, required int delta}) async {
    final existing = await _localDataSource.getItem(id);
    if (existing == null) {
      return;
    }
    final nextQuantity = existing.quantity + delta;
    existing
      ..quantity = nextQuantity < 0 ? 0 : nextQuantity
      ..updatedAt = DateTime.now();
    await _localDataSource.putItem(existing);
  }

  @override
  Future<String> saveImageLocally(String sourcePath) {
    return _localDataSource.saveImageLocally(sourcePath);
  }
}
