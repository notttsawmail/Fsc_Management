class ExpenseTrendPoint {
  const ExpenseTrendPoint({
    required this.date,
    required this.totalExpenses,
    required this.totalSales,
    required this.netProfit,
  });

  final DateTime date;
  final double totalExpenses;
  final double totalSales;
  final double netProfit;
}
