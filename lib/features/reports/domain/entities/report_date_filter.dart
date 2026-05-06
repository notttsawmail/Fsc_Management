enum ReportDateFilterType { today, yesterday, customDate, dateRange }

class ReportDateFilter {
  const ReportDateFilter._({
    required this.type,
    this.date,
    this.startDate,
    this.endDate,
  });

  factory ReportDateFilter.today() {
    return const ReportDateFilter._(type: ReportDateFilterType.today);
  }

  factory ReportDateFilter.yesterday() {
    return const ReportDateFilter._(type: ReportDateFilterType.yesterday);
  }

  factory ReportDateFilter.customDate(DateTime date) {
    return ReportDateFilter._(
      type: ReportDateFilterType.customDate,
      date: date,
    );
  }

  factory ReportDateFilter.dateRange(DateTime startDate, DateTime endDate) {
    return ReportDateFilter._(
      type: ReportDateFilterType.dateRange,
      startDate: startDate,
      endDate: endDate,
    );
  }

  final ReportDateFilterType type;
  final DateTime? date;
  final DateTime? startDate;
  final DateTime? endDate;
}

class ReportDateRange {
  const ReportDateRange({
    required this.startInclusive,
    required this.endInclusive,
    required this.label,
  });

  final DateTime startInclusive;
  final DateTime endInclusive;
  final String label;
}
