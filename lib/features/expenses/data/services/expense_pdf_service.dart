import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../reports/domain/services/nepali_report_clock.dart';
import '../../domain/entities/expense_enums.dart';
import '../../domain/entities/expense_report.dart';

class ExpensePdfService {
  ExpensePdfService(this._clock);

  final NepaliReportClock _clock;

  Future<Uint8List> buildExpenseReportPdf({
    required ExpenseReport report,
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
          _categoryBreakdown(report),
          pw.SizedBox(height: 18),
          _expenseTable(report),
        ],
      ),
    );

    return pdf.save();
  }

  Future<void> shareExpenseReportPdf({
    required ExpenseReport report,
    String shopName = 'FSC Shop',
  }) async {
    final bytes = await buildExpenseReportPdf(
      report: report,
      shopName: shopName,
    );
    await Printing.sharePdf(bytes: bytes, filename: _fileName(report));
  }

  Future<String> saveExpenseReportPdf({
    required ExpenseReport report,
    String shopName = 'FSC Shop',
  }) async {
    final bytes = await buildExpenseReportPdf(
      report: report,
      shopName: shopName,
    );
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
    ExpenseReport report,
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
        pw.Text('Expense and profit report: ${report.label}'),
        pw.Text(
          'Generated: ${_clock.displayDate(generatedAt)} '
          '${generatedAt.hour.toString().padLeft(2, '0')}:'
          '${generatedAt.minute.toString().padLeft(2, '0')} Nepal Time',
        ),
      ],
    );
  }

  pw.Widget _summary(ExpenseReport report) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        _summaryRow('Total sales', 'Rs. ${_money(report.totalSales)}'),
        _summaryRow('Total expenses', 'Rs. ${_money(report.totalExpenses)}'),
        _summaryRow('Net profit', 'Rs. ${_money(report.netProfit)}'),
        _summaryRow('Expense entries', report.expenses.length.toString()),
      ],
    );
  }

  pw.Widget _categoryBreakdown(ExpenseReport report) {
    final categories = report.analytics.categorySummaries;
    if (categories.isEmpty) {
      return pw.Text('No expenses found for this period.');
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Expense categories',
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
                _cell('Count', bold: true, alignRight: true),
                _cell('Amount', bold: true, alignRight: true),
              ],
            ),
            for (final category in categories)
              pw.TableRow(
                children: [
                  _cell(category.category),
                  _cell(category.expenseCount.toString(), alignRight: true),
                  _cell(
                    'Rs. ${_money(category.totalAmount)}',
                    alignRight: true,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _expenseTable(ExpenseReport report) {
    if (report.expenses.isEmpty) {
      return pw.Text('No expense entries found.');
    }
    return pw.Table(
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
    );
  }

  pw.TableRow _summaryRow(String label, String value) {
    return pw.TableRow(
      children: [_cell(label, bold: true), _cell(value, alignRight: true)],
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

  String _fileName(ExpenseReport report) {
    final start = _clock.compactDate(report.startDate);
    final end = _clock.compactDate(report.endDate);
    return start == end
        ? 'expense_profit_report_$start.pdf'
        : 'expense_profit_report_${start}_to_$end.pdf';
  }
}
