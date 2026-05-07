class ProfitPeriodSummary {
  const ProfitPeriodSummary({
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.totalSales,
    required this.totalExpenses,
  });

  final String label;
  final DateTime startDate;
  final DateTime endDate;
  final double totalSales;
  final double totalExpenses;

  double get netProfit => totalSales - totalExpenses;
}
