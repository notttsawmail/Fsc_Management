import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/inventory_item_model.dart';

class InventoryLocalDataSource {
  InventoryLocalDataSource._(this._isar);

  final Isar _isar;

  static Future<InventoryLocalDataSource> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [InventoryItemModelSchema],
      directory: dir.path,
      name: 'fsc_inventory',
    );
    return InventoryLocalDataSource._(isar);
  }

  Stream<List<InventoryItemModel>> watchItems({String searchQuery = ''}) {
    final query = searchQuery.trim();
    if (query.isEmpty) {
      return _isar.inventoryItemModels.where().sortByUpdatedAtDesc().watch(
        fireImmediately: true,
      );
    }

    return _isar.inventoryItemModels
        .filter()
        .nameContains(query, caseSensitive: false)
        .or()
        .itemCodeContains(query, caseSensitive: false)
        .or()
        .categoryContains(query, caseSensitive: false)
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<List<String>> getCategories() async {
    final items = await _isar.inventoryItemModels.where().findAll();
    final categories =
        items
            .map((item) => item.category.trim())
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return categories;
  }

  Future<void> putItem(InventoryItemModel item) {
    return _isar.writeTxn(() => _isar.inventoryItemModels.put(item));
  }

  Future<void> deleteItem(int id) {
    return _isar.writeTxn(() => _isar.inventoryItemModels.delete(id));
  }

  Future<InventoryItemModel?> getItem(int id) {
    return _isar.inventoryItemModels.get(id);
  }

  Future<String> saveImageLocally(String sourcePath) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw ArgumentError('Selected image file does not exist.');
    }

    final documentsDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(
      path.join(documentsDir.path, 'inventory_images'),
    );
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final extension = path.extension(sourcePath);
    final fileName = 'item_${DateTime.now().microsecondsSinceEpoch}$extension';
    final savedFile = await sourceFile.copy(
      path.join(imagesDir.path, fileName),
    );
    return savedFile.path;
  }
}
