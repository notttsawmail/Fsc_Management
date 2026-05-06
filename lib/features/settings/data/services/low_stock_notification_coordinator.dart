import 'package:isar/isar.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/services/low_stock_policy.dart';
import '../datasources/settings_local_data_source.dart';
import '../models/app_settings_model.dart';
import '../models/low_stock_notification_model.dart';
import 'local_notification_service.dart';

class LowStockNotificationCoordinator {
  LowStockNotificationCoordinator({
    required SettingsLocalDataSource localDataSource,
    required LocalNotificationService notificationService,
    required LowStockPolicy lowStockPolicy,
  }) : _localDataSource = localDataSource,
       _notificationService = notificationService,
       _lowStockPolicy = lowStockPolicy;

  final SettingsLocalDataSource _localDataSource;
  final LocalNotificationService _notificationService;
  final LowStockPolicy _lowStockPolicy;

  Future<void> evaluate() async {
    final settings = (await _localDataSource.getSettings()).toEntity();
    if (!settings.notificationsEnabled) {
      return;
    }

    final inventory = (await _localDataSource.getInventoryItems())
        .map((item) => item.toEntity())
        .toList();
    final lowStockItems = inventory
        .where((item) => _lowStockPolicy.isLowStock(item, settings))
        .toList();

    for (final item in inventory) {
      if (!_lowStockPolicy.isLowStock(item, settings)) {
        await _localDataSource.deleteNotificationState(item.id);
        continue;
      }

      final threshold = _thresholdFor(item.lowStockLimit, settings);
      final existing = await _localDataSource.getNotificationState(item.id);
      final shouldNotify =
          existing == null || item.quantity < existing.lastQuantity;
      if (!shouldNotify) {
        continue;
      }

      await _notificationService.showLowStock(item, threshold);
      await _localDataSource.putNotificationState(
        LowStockNotificationModel()
          ..id = existing?.id ?? Isar.autoIncrement
          ..inventoryItemId = item.id
          ..lastQuantity = item.quantity
          ..lowStockLimit = threshold
          ..notifiedAt = DateTime.now(),
      );
    }

    if (settings.dailyLowStockSummaryEnabled && lowStockItems.isNotEmpty) {
      await _maybeShowDailySummary(settings, lowStockItems.length);
    }
  }

  Future<void> _maybeShowDailySummary(
    AppSettings settings,
    int lowStockCount,
  ) async {
    final now = DateTime.now();
    final last = settings.lastDailyLowStockSummaryAt;
    final alreadySentToday =
        last != null &&
        last.year == now.year &&
        last.month == now.month &&
        last.day == now.day;
    if (alreadySentToday) {
      return;
    }
    final outOfStock = (await _localDataSource.getInventoryItems())
        .map((item) => item.toEntity())
        .where(_lowStockPolicy.isOutOfStock)
        .length;
    await _notificationService.showDailyLowStockSummary(
      lowStockCount: lowStockCount,
      outOfStockCount: outOfStock,
    );
    await _localDataSource.saveSettings(
      AppSettingsModel.fromEntity(
        settings.copyWith(lastDailyLowStockSummaryAt: now, updatedAt: now),
      ),
    );
  }

  int _thresholdFor(int itemLimit, AppSettings settings) {
    return settings.lowStockAlertThreshold > 0
        ? settings.lowStockAlertThreshold
        : itemLimit;
  }
}
