import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/calendar_sales_day.dart';
import '../providers/reports_providers.dart';
import '../widgets/report_formatters.dart';

class CalendarSalesScreen extends ConsumerWidget {
  const CalendarSalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedCalendarMonthProvider);
    final days = ref.watch(calendarSalesProvider);
    final dayReport = ref.watch(selectedCalendarDayReportProvider);

    return Column(
      children: [
        _CalendarHeader(month: month),
        const Divider(height: 1),
        Expanded(
          child: days.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(error.toString(), textAlign: TextAlign.center),
              ),
            ),
            data: (calendarDays) => RefreshIndicator(
              onRefresh: () async => ref.refresh(calendarSalesProvider.future),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
                children: [
                  _CalendarGrid(days: calendarDays, month: month),
                  const SizedBox(height: 12),
                  dayReport.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (error, _) => Text(error.toString()),
                    data: (report) {
                      if (report == null) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Select a date to view sales details.'),
                          ),
                        );
                      }
                      CalendarSalesDay? selectedDay;
                      for (final day in calendarDays) {
                        final selected = report.startDate;
                        if (day.date.year == selected.year &&
                            day.date.month == selected.month &&
                            day.date.day == selected.day) {
                          selectedDay = day;
                          break;
                        }
                      }
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.label,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text('Tokens: ${report.totalOrders}'),
                              Text('Sales: ${money(report.totalIncome)}'),
                              Text(
                                'Expenses: ${money(selectedDay?.totalExpenses ?? 0)}',
                              ),
                              Text(
                                'Profit: ${money(selectedDay?.netProfit ?? report.totalIncome)}',
                              ),
                              Text('Quantity: ${report.totalQuantitySold}'),
                              Text('Cancelled: ${report.cancelledOrdersCount}'),
                              const Divider(height: 24),
                              if (report.bestSellingItems.isEmpty)
                                const Text('No item sales for this date.')
                              else
                                for (final item in report.bestSellingItems)
                                  ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(item.itemName),
                                    subtitle: Text('${item.quantitySold} sold'),
                                    trailing: Text(money(item.totalRevenue)),
                                  ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CalendarHeader extends ConsumerWidget {
  const _CalendarHeader({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthName = _monthName(month.month);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Previous month',
            onPressed: () {
              ref.read(selectedCalendarMonthProvider.notifier).state = DateTime(
                month.year,
                month.month - 1,
              );
              ref.read(selectedCalendarDateProvider.notifier).state = null;
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Text(
              '$monthName ${month.year}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            tooltip: 'Next month',
            onPressed: () {
              ref.read(selectedCalendarMonthProvider.notifier).state = DateTime(
                month.year,
                month.month + 1,
              );
              ref.read(selectedCalendarDateProvider.notifier).state = null;
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends ConsumerWidget {
  const _CalendarGrid({required this.days, required this.month});

  final List<CalendarSalesDay> days;
  final DateTime month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCalendarDateProvider);
    final firstWeekday = DateTime(month.year, month.month).weekday;
    final leadingBlanks = firstWeekday % 7;
    final cells = <CalendarSalesDay?>[
      ...List<CalendarSalesDay?>.filled(leadingBlanks, null),
      ...days,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Row(
              children: [
                _WeekdayLabel('Sun'),
                _WeekdayLabel('Mon'),
                _WeekdayLabel('Tue'),
                _WeekdayLabel('Wed'),
                _WeekdayLabel('Thu'),
                _WeekdayLabel('Fri'),
                _WeekdayLabel('Sat'),
              ],
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 560;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: compact ? .92 : .82,
                  ),
                  itemCount: cells.length,
                  itemBuilder: (context, index) {
                    final day = cells[index];
                    if (day == null) {
                      return const SizedBox.shrink();
                    }
                    final isSelected =
                        selected != null &&
                        selected.year == day.date.year &&
                        selected.month == day.date.month &&
                        selected.day == day.date.day;
                    return _CalendarDayTile(
                      day: day,
                      isSelected: isSelected,
                      compact: compact,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}

class _CalendarDayTile extends ConsumerWidget {
  const _CalendarDayTile({
    required this.day,
    required this.isSelected,
    required this.compact,
  });

  final CalendarSalesDay day;
  final bool isSelected;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final hasSales = day.orderCount > 0;
    final hasExpenses = day.totalExpenses > 0;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          ref.read(selectedCalendarDateProvider.notifier).state = day.date;
        },
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? scheme.primaryContainer
                : hasSales || hasExpenses
                ? scheme.secondaryContainer.withValues(alpha: .55)
                : scheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? scheme.primary : scheme.outlineVariant,
            ),
          ),
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day.date.day.toString(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              if (compact)
                Wrap(
                  spacing: 3,
                  children: [
                    if (hasSales) const _DayDot(color: Colors.green),
                    if (hasExpenses) const _DayDot(color: Colors.orange),
                    if (day.netProfit < 0) const _DayDot(color: Colors.red),
                  ],
                )
              else ...[
                Text(
                  'S: ${money(day.totalIncome)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  'E: ${money(day.totalExpenses)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  'P: ${money(day.netProfit)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 6,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

String _monthName(int month) {
  const names = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return names[month - 1];
}
