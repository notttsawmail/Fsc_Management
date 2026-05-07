import '../../../billing/domain/entities/billing_order.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../../domain/entities/printer_settings.dart';
import '../../domain/repositories/receipt_barcode_repository.dart';
import '../datasources/printer_settings_local_data_source.dart';
import '../datasources/receipt_barcode_local_data_source.dart';

class ReceiptBarcodeRepositoryImpl implements ReceiptBarcodeRepository {
  ReceiptBarcodeRepositoryImpl({
    required ReceiptBarcodeLocalDataSource localDataSource,
    required PrinterSettingsLocalDataSource printerSettingsDataSource,
  }) : _localDataSource = localDataSource,
       _printerSettingsDataSource = printerSettingsDataSource;

  final ReceiptBarcodeLocalDataSource _localDataSource;
  final PrinterSettingsLocalDataSource _printerSettingsDataSource;

  @override
  Stream<List<BillingOrder>> watchReceiptOrders() {
    return _localDataSource.watchReceiptOrders().map(
      (orders) => orders.map((order) => order.toEntity()).toList(),
    );
  }

  @override
  Future<BillingOrder?> getReceiptOrder(int id) async {
    final order = await _localDataSource.getReceiptOrder(id);
    return order?.toEntity();
  }

  @override
  Future<PrinterSettings> getPrinterSettings() {
    return _printerSettingsDataSource.read();
  }

  @override
  Future<void> savePrinterSettings(PrinterSettings settings) {
    return _printerSettingsDataSource.write(settings);
  }

  @override
  Future<InventoryItem?> findItemByBarcode(String barcode) async {
    final item = await _localDataSource.findItemByBarcode(barcode);
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
  Future<String> generateUniqueBarcode({int? itemId}) async {
    for (var attempt = 0; attempt < 20; attempt++) {
      final now = DateTime.now().microsecondsSinceEpoch;
      final suffix = itemId == null ? attempt : itemId + attempt;
      final candidate = 'FSC$now$suffix';
      if (await isBarcodeUnique(barcode: candidate, excludingItemId: itemId)) {
        return candidate;
      }
    }
    throw StateError('Unable to generate a unique barcode.');
  }
}
