import '../../../inventory/domain/entities/inventory_item.dart';
import '../entities/app_settings.dart';

class LowStockPolicy {
  bool isLowStock(InventoryItem item, AppSettings settings) {
    if (!item.isTrackableInventory) {
      return false;
    }
    final effectiveLimit = settings.lowStockAlertThreshold > 0
        ? settings.lowStockAlertThreshold
        : item.lowStockLimit;
    return effectiveLimit > 0 && item.quantity < effectiveLimit;
  }

  bool isOutOfStock(InventoryItem item) {
    return item.isTrackableInventory && item.quantity <= 0;
  }
}
