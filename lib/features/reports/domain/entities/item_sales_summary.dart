class ItemSalesSummary {
  const ItemSalesSummary({
    required this.inventoryItemId,
    required this.itemName,
    required this.itemCode,
    required this.quantitySold,
    required this.unitPrice,
    required this.totalRevenue,
  });

  final int inventoryItemId;
  final String itemName;
  final String itemCode;
  final int quantitySold;
  final double unitPrice;
  final double totalRevenue;
}
