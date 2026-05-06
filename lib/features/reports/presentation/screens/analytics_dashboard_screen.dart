import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/reports_providers.dart';
import '../widgets/report_formatters.dart';
import '../widgets/report_summary_card.dart';

class AnalyticsDashboardScreen extends ConsumerWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(analyticsDashboardProvider);
    return dashboard.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(error.toString(), textAlign: TextAlign.center),
        ),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () async => ref.refresh(analyticsDashboardProvider.future),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: 240,
                  child: ReportSummaryCard(
                    title: "Today's sales",
                    value: money(data.todaySales),
                    icon: Icons.payments_outlined,
                  ),
                ),
                SizedBox(
                  width: 240,
                  child: ReportSummaryCard(
                    title: "Today's tokens",
                    value: data.todayTokenCount.toString(),
                    icon: Icons.confirmation_number_outlined,
                  ),
                ),
                SizedBox(
                  width: 240,
                  child: ReportSummaryCard(
                    title: 'Low stock',
                    value: data.lowStockItems.length.toString(),
                    icon: Icons.warning_amber_outlined,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(
                  width: 240,
                  child: ReportSummaryCard(
                    title: 'Inventory items',
                    value: data.totalInventoryItems.toString(),
                    icon: Icons.inventory_2_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DashboardListCard(
              title: 'Best selling today',
              emptyText: 'No sales yet today.',
              children: [
                for (final item in data.bestSellingItems)
                  ListTile(
                    leading: const Icon(Icons.trending_up_outlined),
                    title: Text(item.itemName),
                    subtitle: Text('${item.quantitySold} sold'),
                    trailing: Text(money(item.totalRevenue)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _DashboardListCard(
              title: 'Out of stock',
              emptyText: 'No out-of-stock items.',
              children: [
                for (final item in data.outOfStockItems)
                  ListTile(
                    leading: Icon(
                      Icons.remove_shopping_cart_outlined,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(item.name),
                    subtitle: Text(item.itemCode),
                    trailing: Text(item.quantity.toString()),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _DashboardListCard(
              title: 'Below low stock limit',
              emptyText: 'No low stock items.',
              children: [
                for (final item in data.lowStockItems)
                  ListTile(
                    leading: const Icon(Icons.warning_amber_outlined),
                    title: Text(item.name),
                    subtitle: Text('Limit ${item.lowStockLimit}'),
                    trailing: Text(item.quantity.toString()),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardListCard extends StatelessWidget {
  const _DashboardListCard({
    required this.title,
    required this.emptyText,
    required this.children,
  });

  final String title;
  final String emptyText;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (children.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(emptyText),
              )
            else
              ...children,
          ],
        ),
      ),
    );
  }
}
