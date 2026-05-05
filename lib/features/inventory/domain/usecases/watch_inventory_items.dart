import '../entities/inventory_item.dart';
import '../repositories/inventory_repository.dart';

class WatchInventoryItems {
  const WatchInventoryItems(this._repository);

  final InventoryRepository _repository;

  Stream<List<InventoryItem>> call({String searchQuery = ''}) {
    return _repository.watchItems(searchQuery: searchQuery);
  }
}
