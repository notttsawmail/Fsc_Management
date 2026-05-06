import '../entities/report_date_filter.dart';

const nepalUtcOffset = Duration(hours: 5, minutes: 45);

class NepaliReportClock {
  DateTime now() => DateTime.now().toUtc().add(nepalUtcOffset);

  String compactDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  String displayDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }

  DateTime startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  DateTime endOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day, 23, 59, 59, 999);
  }

  ReportDateRange resolve(ReportDateFilter filter) {
    final today = startOfDay(now());
    switch (filter.type) {
      case ReportDateFilterType.today:
        return ReportDateRange(
          startInclusive: today,
          endInclusive: endOfDay(today),
          label: 'Today (${displayDate(today)})',
        );
      case ReportDateFilterType.yesterday:
        final yesterday = today.subtract(const Duration(days: 1));
        return ReportDateRange(
          startInclusive: yesterday,
          endInclusive: endOfDay(yesterday),
          label: 'Yesterday (${displayDate(yesterday)})',
        );
      case ReportDateFilterType.customDate:
        final date = startOfDay(filter.date ?? today);
        return ReportDateRange(
          startInclusive: date,
          endInclusive: endOfDay(date),
          label: displayDate(date),
        );
      case ReportDateFilterType.dateRange:
        final start = startOfDay(filter.startDate ?? today);
        final rawEnd = startOfDay(filter.endDate ?? start);
        final end = rawEnd.isBefore(start) ? start : rawEnd;
        return ReportDateRange(
          startInclusive: start,
          endInclusive: endOfDay(end),
          label: '${displayDate(start)} - ${displayDate(end)}',
        );
    }
  }
}
