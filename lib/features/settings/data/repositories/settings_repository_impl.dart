import '../../../inventory/domain/entities/inventory_item.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/backup_result.dart';
import '../../domain/entities/notification_summary.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/services/low_stock_policy.dart';
import '../datasources/settings_local_data_source.dart';
import '../models/app_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required SettingsLocalDataSource localDataSource,
    required LowStockPolicy lowStockPolicy,
  }) : _localDataSource = localDataSource,
       _lowStockPolicy = lowStockPolicy;

  final SettingsLocalDataSource _localDataSource;
  final LowStockPolicy _lowStockPolicy;

  @override
  Stream<AppSettings> watchSettings() {
    return _localDataSource.watchSettings().map(
      (settings) => settings.toEntity(),
    );
  }

  @override
  Future<AppSettings> getSettings() async {
    return (await _localDataSource.getSettings()).toEntity();
  }

  @override
  Future<void> saveSettings(AppSettings settings) {
    return _localDataSource.saveSettings(
      AppSettingsModel.fromEntity(settings.copyWith(updatedAt: DateTime.now())),
    );
  }

  @override
  Future<BackupResult> exportBackup() async {
    final backupPath = await _localDataSource.exportBackup();
    final inventory = await _localDataSource.getInventoryItems();
    final orders = await _localDataSource.getOrders();
    final result = BackupResult(
      path: backupPath,
      createdAt: DateTime.now(),
      inventoryCount: inventory.length,
      orderCount: orders.length,
      settingsCount: 1,
    );
    await recordBackup(result);
    return result;
  }

  @override
  Future<BackupResult> restoreBackup(String path) async {
    final counts = await _localDataSource.restoreBackup(path);
    final result = BackupResult(
      path: path,
      createdAt: DateTime.now(),
      inventoryCount: counts.inventoryCount,
      orderCount: counts.orderCount,
      settingsCount: counts.settingsCount,
    );
    await recordBackup(result);
    return result;
  }

  @override
  Future<void> clearAllData() => _localDataSource.clearAllData();

  @override
  Stream<List<InventoryItem>> watchInventoryItems() {
    return _localDataSource.watchInventoryItems().map(
      (items) => items.map((item) => item.toEntity()).toList(),
    );
  }

  @override
  Future<NotificationSummary> getNotificationSummary() async {
    final settings = await getSettings();
    final inventory = (await _localDataSource.getInventoryItems())
        .map((item) => item.toEntity())
        .toList();
    final states = await _localDataSource.getNotificationStates();
    final lowStock = inventory
        .where((item) => _lowStockPolicy.isLowStock(item, settings))
        .toList();
    final outOfStock = inventory.where(_lowStockPolicy.isOutOfStock).toList();
    states.sort((a, b) => b.notifiedAt.compareTo(a.notifiedAt));
    return NotificationSummary(
      lowStockItems: lowStock,
      outOfStockItems: outOfStock,
      notifiedItemCount: states
          .where((state) => state.inventoryItemId > 0)
          .length,
      lastNotificationAt: states.isEmpty ? null : states.first.notifiedAt,
    );
  }

  @override
  Future<void> recordBackup(BackupResult result) async {
    final current = await getSettings();
    await saveSettings(
      current.copyWith(
        latestBackupAt: result.createdAt,
        latestBackupPath: result.path,
      ),
    );
  }
}
