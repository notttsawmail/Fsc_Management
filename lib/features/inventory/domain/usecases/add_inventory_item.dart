import '../entities/inventory_item.dart';
import '../repositories/inventory_repository.dart';

class AddInventoryItem {
  const AddInventoryItem(this._repository);

  final InventoryRepository _repository;

  Future<void> call(InventoryItem item) {
    _validate(item);
    return _repository.addItem(item);
  }

  void _validate(InventoryItem item) {
    if (item.name.trim().isEmpty) {
      throw ArgumentError('Item name is required.');
    }
    if (item.itemCode.trim().isEmpty) {
      throw ArgumentError('Item code is required.');
    }
    if (item.category.trim().isEmpty) {
      throw ArgumentError('Category is required.');
    }
    if (item.price < 0) {
      throw ArgumentError('Price cannot be negative.');
    }
    if (item.quantity < 0) {
      throw ArgumentError('Quantity cannot be below 0.');
    }
    if (item.lowStockLimit < 0) {
      throw ArgumentError('Low stock limit cannot be negative.');
    }
  }
}
