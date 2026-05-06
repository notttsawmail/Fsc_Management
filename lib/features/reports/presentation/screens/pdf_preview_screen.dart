import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../domain/entities/daily_sales_report.dart';
import '../../data/services/reports_pdf_service.dart';
import '../../domain/services/nepali_report_clock.dart';

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({
    super.key,
    required this.report,
    required this.shopName,
  });

  final DailySalesReport report;
  final String shopName;

  @override
  Widget build(BuildContext context) {
    final service = ReportsPdfService(NepaliReportClock());
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Preview')),
      body: PdfPreview(
        canChangeOrientation: false,
        canChangePageFormat: true,
        canDebug: false,
        pdfFileName: 'sales_report.pdf',
        build: (_) =>
            service.buildDailySalesPdf(report: report, shopName: shopName),
      ),
    );
  }
}
