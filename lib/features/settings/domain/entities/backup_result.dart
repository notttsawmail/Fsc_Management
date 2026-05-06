class BackupResult {
  const BackupResult({
    required this.path,
    required this.createdAt,
    required this.inventoryCount,
    required this.orderCount,
    required this.settingsCount,
  });

  final String path;
  final DateTime createdAt;
  final int inventoryCount;
  final int orderCount;
  final int settingsCount;
}
