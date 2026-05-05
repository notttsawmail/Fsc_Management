import '../../../inventory/domain/entities/inventory_item.dart';

class CartItem {
  const CartItem({required this.item, required this.quantity});

  final InventoryItem item;
  final int quantity;

  double get lineTotal => item.price * quantity;

  CartItem copyWith({InventoryItem? item, int? quantity}) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }
}
