import '../entities/inventory_item.dart';
import '../repositories/inventory_repository.dart';

class FindInventoryItemByBarcode {
  const FindInventoryItemByBarcode(this._repository);

  final InventoryRepository _repository;

  Future<InventoryItem?> call(String barcode) {
    return _repository.findByBarcode(barcode);
  }
}
