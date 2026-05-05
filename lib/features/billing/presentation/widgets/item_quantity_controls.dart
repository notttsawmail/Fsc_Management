import 'package:flutter/material.dart';

class ItemQuantityControls extends StatelessWidget {
  const ItemQuantityControls({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
    this.canIncrease = true,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final bool canIncrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          tooltip: 'Decrease',
          onPressed: quantity <= 1 ? null : onDecrease,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 40,
          child: Text(
            quantity.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Increase',
          onPressed: canIncrease ? onIncrease : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
