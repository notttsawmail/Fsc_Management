import '../repositories/inventory_repository.dart';

class DeleteInventoryItem {
  const DeleteInventoryItem(this._repository);

  final InventoryRepository _repository;

  Future<void> call(int id) => _repository.deleteItem(id);
}
