import '../../../billing/domain/entities/billing_order.dart';
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
}
