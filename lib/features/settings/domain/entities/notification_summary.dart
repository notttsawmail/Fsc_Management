import '../../../inventory/domain/entities/inventory_item.dart';

class NotificationSummary {
  const NotificationSummary({
    required this.lowStockItems,
    required this.outOfStockItems,
    required this.notifiedItemCount,
    required this.lastNotificationAt,
  });

  final List<InventoryItem> lowStockItems;
  final List<InventoryItem> outOfStockItems;
  final int notifiedItemCount;
  final DateTime? lastNotificationAt;
}
