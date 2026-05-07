import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../billing/domain/entities/billing_order.dart';
import '../../../settings/domain/entities/app_settings.dart';
import 'receipt_formatters.dart';

class ReceiptPdfService {
  const ReceiptPdfService();

  Future<Uint8List> buildPdf({
    required BillingOrder order,
    required AppSettings settings,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(18),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Text(
              settings.shopName,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            if (settings.shopAddress.isNotEmpty)
              pw.Text(
                settings.shopAddress,
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 10),
              ),
            pw.SizedBox(height: 8),
            pw.Divider(),
            _row('Token', order.tokenNumber.toString()),
            _row('Order', order.orderId),
            _row('Date', receiptDateTime(order.createdAt)),
            _row('Payment', receiptPaymentLabel(order)),
            pw.Divider(),
            ...order.items.map(
              (item) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 3),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      item.itemName,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    _row(
                      '${item.quantity} x ${receiptMoney(settings, item.unitPrice)}',
                      receiptMoney(settings, item.lineTotal),
                    ),
                  ],
                ),
              ),
            ),
            pw.Divider(),
            _row('Subtotal', receiptMoney(settings, order.subtotal)),
            _row(
              'Total',
              receiptMoney(settings, order.totalAmount),
              strong: true,
            ),
            pw.SizedBox(height: 12),
            pw.Text('Thank you', textAlign: pw.TextAlign.center),
          ],
        ),
      ),
    );
    return doc.save();
  }

  Future<void> printPdf({
    required BillingOrder order,
    required AppSettings settings,
  }) async {
    final bytes = await buildPdf(order: order, settings: settings);
    await Printing.layoutPdf(
      name: receiptFileName(order),
      onLayout: (_) => bytes,
    );
  }

  Future<String> savePdf({
    required BillingOrder order,
    required AppSettings settings,
  }) async {
    final bytes = await buildPdf(order: order, settings: settings);
    final dir = await getApplicationDocumentsDirectory();
    final receiptsDir = Directory(path.join(dir.path, 'receipts'));
    await receiptsDir.create(recursive: true);
    final file = File(path.join(receiptsDir.path, receiptFileName(order)));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<void> sharePdf({
    required BillingOrder order,
    required AppSettings settings,
  }) async {
    final bytes = await buildPdf(order: order, settings: settings);
    await Printing.sharePdf(bytes: bytes, filename: receiptFileName(order));
  }

  pw.Widget _row(String label, String value, {bool strong = false}) {
    final style = strong
        ? pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)
        : const pw.TextStyle(fontSize: 10);
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(child: pw.Text(label, style: style)),
        pw.Text(value, style: style),
      ],
    );
  }
}
