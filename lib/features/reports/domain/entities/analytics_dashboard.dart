import '../../../inventory/domain/entities/inventory_item.dart';
import 'item_sales_summary.dart';

class AnalyticsDashboard {
  const AnalyticsDashboard({
    required this.todaySales,
    required this.todayTokenCount,
    required this.lowStockItems,
    required this.outOfStockItems,
    required this.bestSellingItems,
    required this.totalInventoryItems,
  });

  final double todaySales;
  final int todayTokenCount;
  final List<InventoryItem> lowStockItems;
  final List<InventoryItem> outOfStockItems;
  final List<ItemSalesSummary> bestSellingItems;
  final int totalInventoryItems;
}
