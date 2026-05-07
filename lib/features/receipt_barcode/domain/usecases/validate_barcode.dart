import '../services/barcode_service.dart';

class ValidateBarcode {
  const ValidateBarcode(this._service);

  final BarcodeService _service;

  Future<void> call({required String barcode, int? excludingItemId}) {
    return _service.ensureUnique(
      barcode: barcode,
      excludingItemId: excludingItemId,
    );
  }
}
