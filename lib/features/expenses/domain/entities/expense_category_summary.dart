class ExpenseCategorySummary {
  const ExpenseCategorySummary({
    required this.category,
    required this.totalAmount,
    required this.expenseCount,
  });

  final String category;
  final double totalAmount;
  final int expenseCount;
}
