import '../../../inventory/domain/entities/inventory_item.dart';
import '../entities/app_settings.dart';
import '../entities/backup_result.dart';
import '../entities/notification_summary.dart';

abstract class SettingsRepository {
  Stream<AppSettings> watchSettings();

  Future<AppSettings> getSettings();

  Future<void> saveSettings(AppSettings settings);

  Future<BackupResult> exportBackup();

  Future<BackupResult> restoreBackup(String path);

  Future<void> clearAllData();

  Stream<List<InventoryItem>> watchInventoryItems();

  Future<NotificationSummary> getNotificationSummary();

  Future<void> recordBackup(BackupResult result);
}
