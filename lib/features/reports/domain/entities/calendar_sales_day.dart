class CalendarSalesDay {
  const CalendarSalesDay({
    required this.date,
    required this.tokenCount,
    required this.orderCount,
    required this.totalIncome,
    this.totalExpenses = 0,
  });

  final DateTime date;
  final int tokenCount;
  final int orderCount;
  final double totalIncome;
  final double totalExpenses;

  double get netProfit => totalIncome - totalExpenses;
}
