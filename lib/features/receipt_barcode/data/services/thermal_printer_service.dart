import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

import '../../../billing/domain/entities/billing_order.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../domain/entities/printer_settings.dart';
import 'receipt_formatters.dart';

class ThermalPrinterService {
  const ThermalPrinterService();

  Future<String> printReceipt({
    required BillingOrder order,
    required AppSettings appSettings,
    required PrinterSettings printerSettings,
  }) async {
    switch (printerSettings.connectionType) {
      case PrinterConnectionType.network:
        return _printNetwork(
          order: order,
          appSettings: appSettings,
          printerSettings: printerSettings,
        );
      case PrinterConnectionType.bluetooth:
        throw UnsupportedError(
          'Bluetooth printer settings are saved, but this build needs a Bluetooth ESC/POS adapter package to send bytes.',
        );
      case PrinterConnectionType.usb:
        throw UnsupportedError(
          'USB printer settings are saved for future support; USB transport is not enabled in this build.',
        );
    }
  }

  Future<String> _printNetwork({
    required BillingOrder order,
    required AppSettings appSettings,
    required PrinterSettings printerSettings,
  }) async {
    final profile = await CapabilityProfile.load();
    final paper = printerSettings.paperSize == ReceiptPaperSize.mm80
        ? PaperSize.mm80
        : PaperSize.mm58;
    final printer = NetworkPrinter(paper, profile);
    final result = await printer.connect(
      printerSettings.networkHost,
      port: printerSettings.networkPort,
    );
    if (result != PosPrintResult.success) {
      return result.msg;
    }

    printer.text(
      appSettings.shopName,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    if (appSettings.shopAddress.isNotEmpty) {
      printer.text(
        appSettings.shopAddress,
        styles: const PosStyles(align: PosAlign.center),
      );
    }
    printer.hr();
    printer.row([
      PosColumn(text: 'Token', width: 6),
      PosColumn(
        text: order.tokenNumber.toString(),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    printer.text('Order: ${order.orderId}');
    printer.text('Date: ${receiptDateTime(order.createdAt)}');
    printer.text('Payment: ${receiptPaymentLabel(order)}');
    printer.hr();
    for (final item in order.items) {
      printer.text(item.itemName, styles: const PosStyles(bold: true));
      printer.row([
        PosColumn(
          text:
              '${item.quantity} x ${receiptMoney(appSettings, item.unitPrice)}',
          width: 7,
        ),
        PosColumn(
          text: receiptMoney(appSettings, item.lineTotal),
          width: 5,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    printer.hr();
    printer.row([
      PosColumn(text: 'Total', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(
        text: receiptMoney(appSettings, order.totalAmount),
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    printer.feed(1);
    printer.text('Thank you', styles: const PosStyles(align: PosAlign.center));
    printer.feed(2);
    printer.cut();
    printer.disconnect();
    return result.msg;
  }
}
