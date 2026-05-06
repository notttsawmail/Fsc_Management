import '../entities/backup_result.dart';
import '../repositories/settings_repository.dart';

class RestoreDatabaseBackup {
  const RestoreDatabaseBackup(this._repository);

  final SettingsRepository _repository;

  Future<BackupResult> call(String path) => _repository.restoreBackup(path);
}
