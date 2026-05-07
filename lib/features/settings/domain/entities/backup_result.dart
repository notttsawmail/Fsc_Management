class BackupResult {
  const BackupResult({
    required this.path,
    required this.createdAt,
    required this.inventoryCount,
    required this.orderCount,
    this.expenseCount = 0,
    required this.settingsCount,
  });

  final String path;
  final DateTime createdAt;
  final int inventoryCount;
  final int orderCount;
  final int expenseCount;
  final int settingsCount;
}
