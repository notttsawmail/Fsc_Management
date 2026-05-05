import '../repositories/inventory_repository.dart';

class AdjustInventoryQuantity {
  const AdjustInventoryQuantity(this._repository);

  final InventoryRepository _repository;

  Future<void> call({required int id, required int delta}) {
    return _repository.adjustQuantity(id: id, delta: delta);
  }
}
