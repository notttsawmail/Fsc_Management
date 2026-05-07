import '../../../billing/domain/entities/billing_order.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../entities/printer_settings.dart';

abstract class ReceiptBarcodeRepository {
  Stream<List<BillingOrder>> watchReceiptOrders();

  Future<BillingOrder?> getReceiptOrder(int id);

  Future<PrinterSettings> getPrinterSettings();

  Future<void> savePrinterSettings(PrinterSettings settings);

  Future<InventoryItem?> findItemByBarcode(String barcode);

  Future<bool> isBarcodeUnique({required String barcode, int? excludingItemId});

  Future<String> generateUniqueBarcode({int? itemId});
}
