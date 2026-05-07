import 'dart:typed_data';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../billing/domain/entities/billing_enums.dart';
import '../../../expenses/domain/entities/expense_enums.dart';
import '../../domain/entities/daily_sales_report.dart';
import '../../domain/services/nepali_report_clock.dart';

class ReportsPdfService {
  ReportsPdfService(this._clock);

  final NepaliReportClock _clock;

  Future<Uint8List> buildDailySalesPdf({
    required DailySalesReport report,
    String shopName = 'FSC Shop',
  }) async {
    final pdf = pw.Document();
    final generatedAt = _clock.now();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.all(28),
          pageFormat: PdfPageFormat.a4,
        ),
        build: (context) => [
          _header(shopName, report, generatedAt),
          pw.SizedBox(height: 18),
          _summary(report),
          pw.SizedBox(height: 18),
          _paymentBreakdown(report),
          pw.SizedBox(height: 18),
          _expenseBreakdown(report),
          pw.SizedBox(height: 18),
          _itemsTable(report),
          if (report.expenses.isNotEmpty) ...[
            pw.SizedBox(height: 18),
            _expensesTable(report),
          ],
          pw.SizedBox(height: 16),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Total revenue: Rs. ${_money(report.totalIncome)}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Net profit: Rs. ${_money(report.netProfit)}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  Future<void> shareDailySalesPdf({
    required DailySalesReport report,
    String shopName = 'FSC Shop',
  }) async {
    final bytes = await buildDailySalesPdf(report: report, shopName: shopName);
    await Printing.sharePdf(bytes: bytes, filename: _fileName(report));
  }

  Future<String> saveDailySalesPdf({
    required DailySalesReport report,
    String shopName = 'FSC Shop',
  }) async {
    final bytes = await buildDailySalesPdf(report: report, shopName: shopName);
    final dir = await getApplicationDocumentsDirectory();
    final reportsDir = Directory(path.join(dir.path, 'reports'));
    if (!await reportsDir.exists()) {
      await reportsDir.create(recursive: true);
    }
    final filePath = path.join(reportsDir.path, _fileName(report));
    await File(filePath).writeAsBytes(bytes, flush: true);
    return filePath;
  }

  pw.Widget _header(
    String shopName,
    DailySalesReport report,
    DateTime generatedAt,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          shopName,
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text('Sales report: ${report.label}'),
        pw.Text(
          'Generated: ${_clock.displayDate(generatedAt)} '
          '${generatedAt.hour.toString().padLeft(2, '0')}:'
          '${generatedAt.minute.toString().padLeft(2, '0')} Nepal Time',
        ),
      ],
    );
  }

  pw.Widget _summary(DailySalesReport report) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        _summaryRow('Total orders/tokens', report.totalOrders.toString()),
        _summaryRow('Total income', 'Rs. ${_money(report.totalIncome)}'),
        _summaryRow('Total expenses', 'Rs. ${_money(report.totalExpenses)}'),
        _summaryRow('Net profit', 'Rs. ${_money(report.netProfit)}'),
        _summaryRow('Total quantity sold', report.totalQuantitySold.toString()),
        _summaryRow('Cancelled orders', report.cancelledOrdersCount.toString()),
      ],
    );
  }

  pw.TableRow _summaryRow(String label, String value) {
    return pw.TableRow(
      children: [_cell(label, bold: true), _cell(value, alignRight: true)],
    );
  }

  pw.Widget _paymentBreakdown(DailySalesReport report) {
    if (report.paymentSummaries.isEmpty) {
      return pw.Text('Payment method breakdown: No paid sales.');
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Payment method breakdown',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _cell('Method', bold: true),
                _cell('Orders', bold: true, alignRight: true),
                _cell('Amount', bold: true, alignRight: true),
              ],
            ),
            for (final summary in report.paymentSummaries)
              pw.TableRow(
                children: [
                  _cell(summary.paymentMethod.label),
                  _cell(summary.orderCount.toString(), alignRight: true),
                  _cell('Rs. ${_money(summary.totalAmount)}', alignRight: true),
                ],
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _itemsTable(DailySalesReport report) {
    if (report.itemSales.isEmpty) {
      return pw.Text('No item sales found for this period.');
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Itemized sales',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: const {
            0: pw.FlexColumnWidth(2.4),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1.2),
            3: pw.FlexColumnWidth(1.4),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _cell('Item', bold: true),
                _cell('Qty', bold: true, alignRight: true),
                _cell('Unit', bold: true, alignRight: true),
                _cell('Revenue', bold: true, alignRight: true),
              ],
            ),
            for (final item in report.itemSales)
              pw.TableRow(
                children: [
                  _cell(item.itemName),
                  _cell(item.quantitySold.toString(), alignRight: true),
                  _cell('Rs. ${_money(item.unitPrice)}', alignRight: true),
                  _cell('Rs. ${_money(item.totalRevenue)}', alignRight: true),
                ],
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _expenseBreakdown(DailySalesReport report) {
    if (report.expenses.isEmpty) {
      return pw.Text('Expenses: No expense entries for this period.');
    }

    final categoryTotals = <String, double>{};
    for (final expense in report.expenses) {
      categoryTotals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    final entries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Expense breakdown',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _cell('Category', bold: true),
                _cell('Entries', bold: true, alignRight: true),
                _cell('Amount', bold: true, alignRight: true),
              ],
            ),
            for (final entry in entries)
              pw.TableRow(
                children: [
                  _cell(entry.key),
                  _cell(
                    report.expenses
                        .where((expense) => expense.category == entry.key)
                        .length
                        .toString(),
                    alignRight: true,
                  ),
                  _cell('Rs. ${_money(entry.value)}', alignRight: true),
                ],
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _expensesTable(DailySalesReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Expense entries',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: const {
            0: pw.FlexColumnWidth(1.1),
            1: pw.FlexColumnWidth(2.1),
            2: pw.FlexColumnWidth(1.4),
            3: pw.FlexColumnWidth(1.3),
            4: pw.FlexColumnWidth(1.2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _cell('Date', bold: true),
                _cell('Title', bold: true),
                _cell('Category', bold: true),
                _cell('Payment', bold: true),
                _cell('Amount', bold: true, alignRight: true),
              ],
            ),
            for (final expense in report.expenses)
              pw.TableRow(
                children: [
                  _cell(_clock.displayDate(expense.expenseDate)),
                  _cell(expense.title),
                  _cell(expense.category),
                  _cell(expense.paymentMethod.label),
                  _cell('Rs. ${_money(expense.amount)}', alignRight: true),
                ],
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _cell(String text, {bool bold = false, bool alignRight = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(7),
      child: pw.Text(
        text,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
      ),
    );
  }

  String _money(double value) => value.toStringAsFixed(0);

  String _fileName(DailySalesReport report) {
    final start = _clock.compactDate(report.startDate);
    final end = _clock.compactDate(report.endDate);
    return start == end
        ? 'sales_report_$start.pdf'
        : 'sales_report_${start}_to_$end.pdf';
  }
}
