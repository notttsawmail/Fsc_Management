class CalendarSalesDay {
  const CalendarSalesDay({
    required this.date,
    required this.tokenCount,
    required this.orderCount,
    required this.totalIncome,
  });

  final DateTime date;
  final int tokenCount;
  final int orderCount;
  final double totalIncome;
}
