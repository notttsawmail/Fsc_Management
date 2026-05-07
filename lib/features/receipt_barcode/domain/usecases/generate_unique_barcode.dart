import '../services/barcode_service.dart';

class GenerateUniqueBarcode {
  const GenerateUniqueBarcode(this._service);

  final BarcodeService _service;

  Future<String> call({int? itemId}) => _service.generateUnique(itemId: itemId);
}
