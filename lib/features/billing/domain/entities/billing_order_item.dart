class BillingOrderItem {
  const BillingOrderItem({
    required this.inventoryItemId,
    required this.itemName,
    required this.itemCode,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
  });

  final int inventoryItemId;
  final String itemName;
  final String itemCode;
  final double unitPrice;
  final int quantity;
  final double lineTotal;
}
