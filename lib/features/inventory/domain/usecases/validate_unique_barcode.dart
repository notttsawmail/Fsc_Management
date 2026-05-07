import '../repositories/inventory_repository.dart';

class ValidateUniqueBarcode {
  const ValidateUniqueBarcode(this._repository);

  final InventoryRepository _repository;

  Future<bool> call({required String barcode, int? excludingItemId}) {
    return _repository.isBarcodeUnique(
      barcode: barcode,
      excludingItemId: excludingItemId,
    );
  }
}
