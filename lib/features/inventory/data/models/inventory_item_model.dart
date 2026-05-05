import 'package:isar/isar.dart';

import '../../domain/entities/inventory_item.dart';

part 'inventory_item_model.g.dart';

@collection
class InventoryItemModel {
  Id id = Isar.autoIncrement;

  @Index(caseSensitive: false)
  late String name;

  @Index(caseSensitive: false)
  late String itemCode;

  @Index(caseSensitive: false)
  late String category;
  late double price;
  late int quantity;
  late int lowStockLimit;
  String? imagePath;
  late bool isTrackableInventory;
  late DateTime createdAt;
  late DateTime updatedAt;

  InventoryItem toEntity() {
    return InventoryItem(
      id: id,
      name: name,
      itemCode: itemCode,
      category: category,
      price: price,
      quantity: quantity,
      lowStockLimit: lowStockLimit,
      imagePath: imagePath,
      isTrackableInventory: isTrackableInventory,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static InventoryItemModel fromEntity(InventoryItem item) {
    return InventoryItemModel()
      ..id = item.id == 0 ? Isar.autoIncrement : item.id
      ..name = item.name.trim()
      ..itemCode = item.itemCode.trim()
      ..category = item.category.trim()
      ..price = item.price
      ..quantity = item.quantity
      ..lowStockLimit = item.lowStockLimit
      ..imagePath = item.imagePath
      ..isTrackableInventory = item.isTrackableInventory
      ..createdAt = item.createdAt
      ..updatedAt = item.updatedAt;
  }
}
