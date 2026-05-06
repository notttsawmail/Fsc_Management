import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../inventory/domain/entities/inventory_item.dart';
import '../../data/datasources/settings_local_data_source.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/services/local_notification_service.dart';
import '../../data/services/low_stock_notification_coordinator.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/backup_result.dart';
import '../../domain/entities/notification_summary.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/services/low_stock_policy.dart';
import '../../domain/usecases/clear_all_data.dart';
import '../../domain/usecases/export_database_backup.dart';
import '../../domain/usecases/restore_database_backup.dart';
import '../../domain/usecases/save_app_settings.dart';
import '../../domain/usecases/watch_app_settings.dart';

final lowStockPolicyProvider = Provider<LowStockPolicy>((ref) {
  return LowStockPolicy();
});

final settingsLocalDataSourceProvider = FutureProvider<SettingsLocalDataSource>(
  (ref) {
    return SettingsLocalDataSource.open();
  },
);

final settingsRepositoryProvider = FutureProvider<SettingsRepository>((
  ref,
) async {
  final dataSource = await ref.watch(settingsLocalDataSourceProvider.future);
  return SettingsRepositoryImpl(
    localDataSource: dataSource,
    lowStockPolicy: ref.watch(lowStockPolicyProvider),
  );
});

final appSettingsProvider = StreamProvider<AppSettings>((ref) async* {
  final repository = await ref.watch(settingsRepositoryProvider.future);
  yield* WatchAppSettings(repository)();
});

final notificationSummaryProvider =
    FutureProvider.autoDispose<NotificationSummary>((ref) async {
      final repository = await ref.watch(settingsRepositoryProvider.future);
      return repository.getNotificationSummary();
    });

final settingsInventoryProvider = StreamProvider<List<InventoryItem>>((
  ref,
) async* {
  final repository = await ref.watch(settingsRepositoryProvider.future);
  yield* repository.watchInventoryItems();
});

final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  return const LocalNotificationService();
});

final lowStockNotificationCoordinatorProvider =
    FutureProvider<LowStockNotificationCoordinator>((ref) async {
      final dataSource = await ref.watch(
        settingsLocalDataSourceProvider.future,
      );
      return LowStockNotificationCoordinator(
        localDataSource: dataSource,
        notificationService: ref.watch(localNotificationServiceProvider),
        lowStockPolicy: ref.watch(lowStockPolicyProvider),
      );
    });

final lowStockMonitorProvider = Provider<void>((ref) {
  Timer? debounce;
  ref.listen(settingsInventoryProvider, (previous, next) {
    next.whenData((_) {
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 700), () async {
        final coordinator = await ref.read(
          lowStockNotificationCoordinatorProvider.future,
        );
        await coordinator.evaluate();
        ref.invalidate(notificationSummaryProvider);
      });
    });
  });
  ref.onDispose(() => debounce?.cancel());
});

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AsyncValue<BackupResult?>>((ref) {
      return SettingsController(ref);
    });

class SettingsController extends StateNotifier<AsyncValue<BackupResult?>> {
  SettingsController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<SettingsRepository> get _repository =>
      _ref.read(settingsRepositoryProvider.future);

  Future<void> saveSettings(AppSettings settings) async {
    await _run(() async {
      final repository = await _repository;
      await SaveAppSettings(repository)(settings);
      return null;
    });
  }

  Future<BackupResult> exportBackup() async {
    final result = await _run(() async {
      final repository = await _repository;
      return ExportDatabaseBackup(repository)();
    });
    _invalidateDashboards();
    return result!;
  }

  Future<BackupResult?> pickAndRestoreBackup() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      allowMultiple: false,
    );
    final filePath = picked?.files.single.path;
    if (filePath == null) {
      return null;
    }
    final result = await _run(() async {
      final repository = await _repository;
      return RestoreDatabaseBackup(repository)(filePath);
    });
    _invalidateDashboards();
    return result;
  }

  Future<void> clearAllData() async {
    await _run(() async {
      final repository = await _repository;
      await ClearAllData(repository)();
      return null;
    });
    _invalidateDashboards();
  }

  Future<BackupResult?> _run(Future<BackupResult?> Function() action) async {
    state = const AsyncLoading();
    try {
      final result = await action();
      state = AsyncData(result);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  void _invalidateDashboards() {
    _ref.invalidate(appSettingsProvider);
    _ref.invalidate(notificationSummaryProvider);
    _ref.invalidate(settingsInventoryProvider);
  }
}
