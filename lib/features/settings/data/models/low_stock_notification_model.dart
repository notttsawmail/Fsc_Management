import 'package:isar/isar.dart';

part 'low_stock_notification_model.g.dart';

@collection
class LowStockNotificationModel {
  Id id = Isar.autoIncrement;

  @Index()
  late int inventoryItemId;

  late int lastQuantity;
  late int lowStockLimit;
  late DateTime notifiedAt;

  Map<String, dynamic> toJson() {
    return {
      'inventoryItemId': inventoryItemId,
      'lastQuantity': lastQuantity,
      'lowStockLimit': lowStockLimit,
      'notifiedAt': notifiedAt.toIso8601String(),
    };
  }

  static LowStockNotificationModel fromJson(Map<String, dynamic> json) {
    return LowStockNotificationModel()
      ..inventoryItemId = (json['inventoryItemId'] as num?)?.toInt() ?? 0
      ..lastQuantity = (json['lastQuantity'] as num?)?.toInt() ?? 0
      ..lowStockLimit = (json['lowStockLimit'] as num?)?.toInt() ?? 0
      ..notifiedAt =
          DateTime.tryParse(json['notifiedAt'] as String? ?? '') ??
          DateTime.now();
  }
}
