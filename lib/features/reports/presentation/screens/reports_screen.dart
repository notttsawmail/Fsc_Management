import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../billing/domain/entities/billing_enums.dart';
import '../../../expenses/domain/entities/expense_enums.dart';
import '../../../receipt_barcode/presentation/screens/reprint_receipts_screen.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/daily_sales_report.dart';
import '../providers/reports_providers.dart';
import '../widgets/date_filter_bar.dart';
import '../widgets/report_formatters.dart';
import '../widgets/report_summary_card.dart';
import 'analytics_dashboard_screen.dart';
import 'calendar_sales_screen.dart';
import 'pdf_preview_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _ReportsAppBar(),
        body: TabBarView(
          children: [
            _ReportsTab(),
            AnalyticsDashboardScreen(),
            CalendarSalesScreen(),
          ],
        ),
      ),
    );
  }
}

class _ReportsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ReportsAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(104);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Reports'),
      actions: [
        IconButton(
          tooltip: 'Reprint receipts',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ReprintReceiptsScreen()),
          ),
          icon: const Icon(Icons.print_outlined),
        ),
      ],
      bottom: const TabBar(
        isScrollable: true,
        tabs: [
          Tab(icon: Icon(Icons.receipt_long_outlined), text: 'Reports'),
          Tab(icon: Icon(Icons.analytics_outlined), text: 'Analytics'),
          Tab(icon: Icon(Icons.calendar_month_outlined), text: 'Calendar'),
        ],
      ),
    );
  }
}

class _ReportsTab extends ConsumerWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(salesReportProvider);
    final pdfState = ref.watch(reportsPdfControllerProvider);
    final shopName = ref
        .watch(appSettingsProvider)
        .maybeWhen(
          data: (settings) => settings.shopName,
          orElse: () => 'FSC Shop',
        );

    ref.listen<AsyncValue<String?>>(reportsPdfControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (path) {
          if (path == null) {
            return;
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Saved PDF to $path')));
        },
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    return Column(
      children: [
        const DateFilterBar(),
        const Divider(height: 1),
        Expanded(
          child: report.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(error.toString(), textAlign: TextAlign.center),
              ),
            ),
            data: (data) => RefreshIndicator(
              onRefresh: () async => ref.refresh(salesReportProvider.future),
              child: _ReportContent(
                report: data,
                isPdfBusy: pdfState.isLoading,
                shopName: shopName,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReportContent extends ConsumerWidget {
  const _ReportContent({
    required this.report,
    required this.isPdfBusy,
    required this.shopName,
  });

  final DailySalesReport report;
  final bool isPdfBusy;
  final String shopName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = _responsiveCardWidth(
              constraints.maxWidth,
              minWidth: 220,
              maxWidth: 280,
            );
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: ReportSummaryCard(
                    title: 'Total orders/tokens',
                    value: report.totalOrders.toString(),
                    icon: Icons.confirmation_number_outlined,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: ReportSummaryCard(
                    title: 'Total income',
                    value: money(report.totalIncome),
                    icon: Icons.payments_outlined,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: ReportSummaryCard(
                    title: 'Total expenses',
                    value: money(report.totalExpenses),
                    icon: Icons.receipt_long_outlined,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: ReportSummaryCard(
                    title: 'Net profit',
                    value: money(report.netProfit),
                    icon: Icons.account_balance_outlined,
                    color: report.netProfit >= 0
                        ? Colors.green.shade700
                        : Theme.of(context).colorScheme.error,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: ReportSummaryCard(
                    title: 'Quantity sold',
                    value: report.totalQuantitySold.toString(),
                    icon: Icons.shopping_bag_outlined,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: ReportSummaryCard(
                    title: 'Cancelled',
                    value: report.cancelledOrdersCount.toString(),
                    icon: Icons.cancel_outlined,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _PaymentSummary(report: report),
        const SizedBox(height: 16),
        _ExpenseSummary(report: report),
        const SizedBox(height: 16),
        _BestSellingItems(report: report),
        const SizedBox(height: 16),
        _SalesTable(report: report),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: isPdfBusy
                  ? null
                  : () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PdfPreviewScreen(
                          report: report,
                          shopName: shopName,
                        ),
                      ),
                    ),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('Preview PDF'),
            ),
            OutlinedButton.icon(
              onPressed: isPdfBusy
                  ? null
                  : () => ref
                        .read(reportsPdfControllerProvider.notifier)
                        .share(report),
              icon: const Icon(Icons.share_outlined),
              label: const Text('Share PDF'),
            ),
            OutlinedButton.icon(
              onPressed: isPdfBusy
                  ? null
                  : () => ref
                        .read(reportsPdfControllerProvider.notifier)
                        .save(report),
              icon: const Icon(Icons.download_outlined),
              label: const Text('Save locally'),
            ),
          ],
        ),
      ],
    );
  }
}

double _responsiveCardWidth(
  double availableWidth, {
  required double minWidth,
  required double maxWidth,
}) {
  if (availableWidth < 420) {
    return availableWidth;
  }

  final twoColumnWidth = (availableWidth - 10) / 2;
  if (twoColumnWidth >= minWidth) {
    return twoColumnWidth.clamp(minWidth, maxWidth);
  }

  return availableWidth;
}

class _ExpenseSummary extends StatelessWidget {
  const _ExpenseSummary({required this.report});

  final DailySalesReport report;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expenses in this period',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (report.expenses.isEmpty)
              const Text('No expense entries for this period.')
            else ...[
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.summarize_outlined),
                title: const Text('Total expenses'),
                subtitle: Text('${report.expenses.length} entries'),
                trailing: Text(money(report.totalExpenses)),
              ),
              const Divider(),
              for (final expense in report.expenses.take(5))
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text(expense.title),
                  subtitle: Text(
                    '${expense.category} • ${expense.paymentMethod.label}',
                  ),
                  trailing: Text(money(expense.amount)),
                ),
              if (report.expenses.length > 5)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Showing 5 of ${report.expenses.length} expense entries. Full list is included in the PDF.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary({required this.report});

  final DailySalesReport report;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment methods',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (report.paymentSummaries.isEmpty)
              const Text('No paid sales for this period.')
            else
              for (final payment in report.paymentSummaries)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.account_balance_wallet_outlined),
                  title: Text(payment.paymentMethod.label),
                  subtitle: Text('${payment.orderCount} orders'),
                  trailing: Text(money(payment.totalAmount)),
                ),
          ],
        ),
      ),
    );
  }
}

class _BestSellingItems extends StatelessWidget {
  const _BestSellingItems({required this.report});

  final DailySalesReport report;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Best selling items',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (report.bestSellingItems.isEmpty)
              const Text('No item sales for this period.')
            else
              for (final item in report.bestSellingItems)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.trending_up_outlined),
                  title: Text(item.itemName),
                  subtitle: Text('${item.quantitySold} sold'),
                  trailing: Text(money(item.totalRevenue)),
                ),
          ],
        ),
      ),
    );
  }
}

class _SalesTable extends StatelessWidget {
  const _SalesTable({required this.report});

  final DailySalesReport report;

  @override
  Widget build(BuildContext context) {
    if (report.itemSales.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text('No itemized sales found for this period.'),
        ),
      );
    }

    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Item')),
            DataColumn(label: Text('Qty'), numeric: true),
            DataColumn(label: Text('Unit price'), numeric: true),
            DataColumn(label: Text('Revenue'), numeric: true),
          ],
          rows: [
            for (final item in report.itemSales)
              DataRow(
                cells: [
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: Text(
                        item.itemName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(Text(item.quantitySold.toString())),
                  DataCell(Text(money(item.unitPrice))),
                  DataCell(Text(money(item.totalRevenue))),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
