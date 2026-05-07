import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../reports/presentation/widgets/report_formatters.dart';
import '../providers/expense_providers.dart';

class ProfitDashboardScreen extends ConsumerWidget {
  const ProfitDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(expenseAnalyticsProvider);
    return analytics.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(error.toString(), textAlign: TextAlign.center),
        ),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () async => ref.refresh(expenseAnalyticsProvider.future),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _MetricCard(
                  title: "Today's expenses",
                  value: money(data.todayExpenses),
                  icon: Icons.receipt_long_outlined,
                ),
                _MetricCard(
                  title: "Today's profit",
                  value: money(data.todayProfit.netProfit),
                  icon: Icons.today_outlined,
                  color: _profitColor(context, data.todayProfit.netProfit),
                ),
                _MetricCard(
                  title: 'Weekly profit',
                  value: money(data.weeklyProfit.netProfit),
                  icon: Icons.date_range_outlined,
                  color: _profitColor(context, data.weeklyProfit.netProfit),
                ),
                _MetricCard(
                  title: 'Monthly profit',
                  value: money(data.monthlyProfit.netProfit),
                  icon: Icons.calendar_month_outlined,
                  color: _profitColor(context, data.monthlyProfit.netProfit),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent expenses',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (data.recentExpenses.isEmpty)
                      const Text('No recent expenses.')
                    else
                      for (final expense in data.recentExpenses)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.receipt_outlined),
                          title: Text(expense.title),
                          subtitle: Text(expense.category),
                          trailing: Text(money(expense.amount)),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _profitColor(BuildContext context, double value) {
    return value >= 0
        ? Colors.green.shade700
        : Theme.of(context).colorScheme.error;
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: 240,
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
