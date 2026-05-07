import '../repositories/receipt_barcode_repository.dart';

class BarcodeService {
  const BarcodeService(this._repository);

  final ReceiptBarcodeRepository _repository;

  Future<String> generateUnique({int? itemId}) {
    return _repository.generateUniqueBarcode(itemId: itemId);
  }

  Future<void> ensureUnique({
    required String barcode,
    int? excludingItemId,
  }) async {
    final normalized = barcode.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('Barcode cannot be empty.');
    }
    final unique = await _repository.isBarcodeUnique(
      barcode: normalized,
      excludingItemId: excludingItemId,
    );
    if (!unique) {
      throw StateError('Barcode already exists.');
    }
  }
}
