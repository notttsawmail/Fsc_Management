import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../reports/presentation/widgets/report_formatters.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../providers/expense_providers.dart';
import 'expense_pdf_preview_screen.dart';

class ExpenseAnalyticsScreen extends ConsumerWidget {
  const ExpenseAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(expenseAnalyticsProvider);
    final report = ref.watch(expenseReportProvider);
    final pdfState = ref.watch(expensePdfControllerProvider);
    final shopName = ref
        .watch(appSettingsProvider)
        .maybeWhen(
          data: (settings) => settings.shopName,
          orElse: () => 'FSC Shop',
        );

    ref.listen<AsyncValue<String?>>(expensePdfControllerProvider, (
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

    return analytics.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(error.toString(), textAlign: TextAlign.center),
        ),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(expenseReportProvider);
          ref.invalidate(expenseAnalyticsProvider);
          await ref.read(expenseAnalyticsProvider.future);
          await ref.read(expenseReportProvider.future);
        },
        child: ListView(
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
                    _SummaryCard(
                      width: cardWidth,
                      title: 'Total expenses',
                      value: money(data.totalExpenses),
                      icon: Icons.receipt_long_outlined,
                    ),
                    _SummaryCard(
                      width: cardWidth,
                      title: 'Total sales',
                      value: money(data.totalSales),
                      icon: Icons.point_of_sale_outlined,
                    ),
                    _SummaryCard(
                      width: cardWidth,
                      title: 'Net profit',
                      value: money(data.netProfit),
                      icon: Icons.account_balance_outlined,
                      color: data.netProfit >= 0
                          ? Colors.green.shade700
                          : Theme.of(context).colorScheme.error,
                    ),
                    _SummaryCard(
                      width: cardWidth,
                      title: 'Highest category',
                      value: data.highestExpenseCategory?.category ?? 'None',
                      icon: Icons.trending_up_outlined,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expense categories',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (data.categorySummaries.isEmpty)
                      const Text('No category spending yet.')
                    else
                      for (final category in data.categorySummaries)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.category_outlined),
                          title: Text(category.category),
                          subtitle: Text('${category.expenseCount} entries'),
                          trailing: Text(money(category.totalAmount)),
                        ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expense trends',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (data.trends.every((trend) => trend.totalExpenses == 0))
                      const Text('No trend data for this month.')
                    else
                      for (final trend in data.trends.where(
                        (trend) =>
                            trend.totalExpenses > 0 || trend.totalSales > 0,
                      ))
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(_date(trend.date)),
                          subtitle: Text(
                            'Sales ${money(trend.totalSales)} • '
                            'Expenses ${money(trend.totalExpenses)}',
                          ),
                          trailing: Text(money(trend.netProfit)),
                        ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            report.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text(error.toString()),
              data: (data) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: pdfState.isLoading
                        ? null
                        : () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ExpensePdfPreviewScreen(
                                report: data,
                                shopName: shopName,
                              ),
                            ),
                          ),
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Preview PDF'),
                  ),
                  OutlinedButton.icon(
                    onPressed: pdfState.isLoading
                        ? null
                        : () => ref
                              .read(expensePdfControllerProvider.notifier)
                              .share(data),
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Share PDF'),
                  ),
                  OutlinedButton.icon(
                    onPressed: pdfState.isLoading
                        ? null
                        : () => ref
                              .read(expensePdfControllerProvider.notifier)
                              .save(data),
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Save locally'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _date(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/'
        '${value.month.toString().padLeft(2, '0')}/${value.year}';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  final double width;
  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: effectiveColor.withValues(alpha: .12),
                foregroundColor: effectiveColor,
                child: Icon(icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: effectiveColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
