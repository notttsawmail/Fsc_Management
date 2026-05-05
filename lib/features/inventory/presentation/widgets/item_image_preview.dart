import 'dart:io';

import 'package:flutter/material.dart';

class ItemImagePreview extends StatelessWidget {
  const ItemImagePreview({super.key, this.imagePath, this.size = 56});

  final String? imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    final radius = BorderRadius.circular(8);

    if (path == null || path.isEmpty || !File(path).existsSync()) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: radius,
        ),
        child: Icon(
          Icons.image_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: Image.file(
        File(path),
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
