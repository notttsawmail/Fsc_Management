import 'package:flutter/material.dart';

class InventoryLoadingState extends StatelessWidget {
  const InventoryLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading inventory...'),
        ],
      ),
    );
  }
}
