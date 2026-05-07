import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/report_date_filter.dart';
import '../providers/reports_providers.dart';
import 'report_formatters.dart';

class DateFilterBar extends ConsumerWidget {
  const DateFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(reportDateFilterProvider);
    final selected = switch (filter.type) {
      ReportDateFilterType.today => 0,
      ReportDateFilterType.yesterday => 1,
      ReportDateFilterType.customDate => 2,
      ReportDateFilterType.dateRange => 3,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  icon: Icon(Icons.today_outlined),
                  label: Text('Today'),
                ),
                ButtonSegment(
                  value: 1,
                  icon: Icon(Icons.history_outlined),
                  label: Text('Yesterday'),
                ),
                ButtonSegment(
                  value: 2,
                  icon: Icon(Icons.event_outlined),
                  label: Text('Date'),
                ),
                ButtonSegment(
                  value: 3,
                  icon: Icon(Icons.date_range_outlined),
                  label: Text('Range'),
                ),
              ],
              selected: {selected},
              showSelectedIcon: false,
              onSelectionChanged: (selection) async {
                await _setFilter(context, ref, selection.first);
              },
            ),
          ),
          if (filter.type == ReportDateFilterType.customDate &&
              filter.date != null)
            InputChip(
              avatar: const Icon(Icons.event_outlined),
              label: Text(shortDate(filter.date!)),
              onPressed: () => _setFilter(context, ref, 2),
            ),
          if (filter.type == ReportDateFilterType.dateRange &&
              filter.startDate != null &&
              filter.endDate != null)
            InputChip(
              avatar: const Icon(Icons.date_range_outlined),
              label: Text(
                '${shortDate(filter.startDate!)} - ${shortDate(filter.endDate!)}',
              ),
              onPressed: () => _setFilter(context, ref, 3),
            ),
        ],
      ),
    );
  }

  Future<void> _setFilter(
    BuildContext context,
    WidgetRef ref,
    int selected,
  ) async {
    final now = ref.read(nepaliReportClockProvider).now();
    switch (selected) {
      case 0:
        ref.read(reportDateFilterProvider.notifier).state =
            ReportDateFilter.today();
      case 1:
        ref.read(reportDateFilterProvider.notifier).state =
            ReportDateFilter.yesterday();
      case 2:
        final picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(now.year - 5),
          lastDate: DateTime(now.year + 1),
        );
        if (picked != null) {
          ref.read(reportDateFilterProvider.notifier).state =
              ReportDateFilter.customDate(picked);
        }
      case 3:
        final picked = await showDateRangePicker(
          context: context,
          initialDateRange: DateTimeRange(start: now, end: now),
          firstDate: DateTime(now.year - 5),
          lastDate: DateTime(now.year + 1),
        );
        if (picked != null) {
          ref.read(reportDateFilterProvider.notifier).state =
              ReportDateFilter.dateRange(picked.start, picked.end);
        }
    }
  }
}
