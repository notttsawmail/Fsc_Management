import '../entities/backup_result.dart';
import '../repositories/settings_repository.dart';

class ExportDatabaseBackup {
  const ExportDatabaseBackup(this._repository);

  final SettingsRepository _repository;

  Future<BackupResult> call() => _repository.exportBackup();
}
