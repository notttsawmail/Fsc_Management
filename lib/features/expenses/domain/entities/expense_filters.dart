class ExpenseFilters {
  const ExpenseFilters({
    this.searchQuery = '',
    this.category,
    this.startDate,
    this.endDate,
  });

  final String searchQuery;
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;

  ExpenseFilters copyWith({
    String? searchQuery,
    String? category,
    bool clearCategory = false,
    DateTime? startDate,
    DateTime? endDate,
    bool clearDates = false,
  }) {
    return ExpenseFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      category: clearCategory ? null : category ?? this.category,
      startDate: clearDates ? null : startDate ?? this.startDate,
      endDate: clearDates ? null : endDate ?? this.endDate,
    );
  }
}
