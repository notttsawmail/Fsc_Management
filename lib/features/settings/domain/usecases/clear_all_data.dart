import '../repositories/settings_repository.dart';

class ClearAllData {
  const ClearAllData(this._repository);

  final SettingsRepository _repository;

  Future<void> call() => _repository.clearAllData();
}
