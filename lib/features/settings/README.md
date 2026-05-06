# Notifications, Backup, and Settings

Offline-first module integrated with Inventory, Billing, Reports, and the
existing Isar database.

## Folder structure

```text
lib/features/settings/
  data/
    datasources/settings_local_data_source.dart
    models/app_settings_model.dart
    models/low_stock_notification_model.dart
    repositories/settings_repository_impl.dart
    services/
      local_notification_service.dart
      low_stock_notification_coordinator.dart
  domain/
    entities/
      app_settings.dart
      backup_result.dart
      notification_summary.dart
    repositories/settings_repository.dart
    services/low_stock_policy.dart
    usecases/
      clear_all_data.dart
      export_database_backup.dart
      restore_database_backup.dart
      save_app_settings.dart
      watch_app_settings.dart
  presentation/
    providers/settings_providers.dart
    screens/settings_screen.dart
    widgets/settings_formatters.dart
```

## Setup

1. Run `flutter pub get`.
2. Run `dart run build_runner build --delete-conflicting-outputs`.
3. Start the app with `flutter run`.
4. Open the `Settings` bottom navigation item.

## Notifications

- Low stock monitoring runs locally from Isar inventory changes.
- Notifications are skipped when settings disable them.
- Duplicate spam is prevented by `LowStockNotificationModel`; an item is
  notified again only after stock recovers or drops further.
- Tapping a low-stock notification opens the inventory edit screen for that
  item when the item still exists locally.

## Backups

Backups are JSON files saved under the app documents directory. They include
inventory items, orders, settings, notification state, token history, and a
reports placeholder because reports are currently calculated from orders.

Restore validates the backup format and version before replacing local Isar
data.
