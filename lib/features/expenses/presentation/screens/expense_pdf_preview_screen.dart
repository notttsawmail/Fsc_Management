import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../data/services/expense_pdf_service.dart';
import '../../domain/entities/expense_report.dart';
import '../../../reports/domain/services/nepali_report_clock.dart';

class ExpensePdfPreviewScreen extends StatelessWidget {
  const ExpensePdfPreviewScreen({
    super.key,
    required this.report,
    required this.shopName,
  });

  final ExpenseReport report;
  final String shopName;

  @override
  Widget build(BuildContext context) {
    final service = ExpensePdfService(NepaliReportClock());
    return Scaffold(
      appBar: AppBar(title: const Text('Expense PDF Preview')),
      body: PdfPreview(
        canChangeOrientation: false,
        canChangePageFormat: true,
        canDebug: false,
        pdfFileName: 'expense_report.pdf',
        build: (_) =>
            service.buildExpenseReportPdf(report: report, shopName: shopName),
      ),
    );
  }
}
