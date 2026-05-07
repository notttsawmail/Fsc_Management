import '../entities/inventory_item.dart';

abstract class InventoryRepository {
  Stream<List<InventoryItem>> watchItems({String searchQuery = ''});

  Future<List<String>> getCategories();

  Future<void> addItem(InventoryItem item);

  Future<void> updateItem(InventoryItem item);

  Future<void> deleteItem(int id);

  Future<void> adjustQuantity({required int id, required int delta});

  Future<String> saveImageLocally(String sourcePath);
}
