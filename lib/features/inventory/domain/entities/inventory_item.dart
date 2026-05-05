class InventoryItem {
  const InventoryItem({
    required this.id,
    required this.name,
    required this.itemCode,
    required this.category,
    required this.price,
    required this.quantity,
    required this.lowStockLimit,
    this.imagePath,
    required this.isTrackableInventory,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String itemCode;
  final String category;
  final double price;
  final int quantity;
  final int lowStockLimit;
  final String? imagePath;
  final bool isTrackableInventory;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isLowStock =>
      isTrackableInventory && quantity <= lowStockLimit && lowStockLimit > 0;

  InventoryItem copyWith({
    int? id,
    String? name,
    String? itemCode,
    String? category,
    double? price,
    int? quantity,
    int? lowStockLimit,
    String? imagePath,
    bool? clearImagePath,
    bool? isTrackableInventory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      itemCode: itemCode ?? this.itemCode,
      category: category ?? this.category,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      lowStockLimit: lowStockLimit ?? this.lowStockLimit,
      imagePath: clearImagePath == true ? null : imagePath ?? this.imagePath,
      isTrackableInventory: isTrackableInventory ?? this.isTrackableInventory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
