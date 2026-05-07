import '../../../billing/domain/entities/billing_order.dart';
import '../entities/printer_settings.dart';

abstract class ReceiptBarcodeRepository {
  Stream<List<BillingOrder>> watchReceiptOrders();

  Future<BillingOrder?> getReceiptOrder(int id);

  Future<PrinterSettings> getPrinterSettings();

  Future<void> savePrinterSettings(PrinterSettings settings);
}
