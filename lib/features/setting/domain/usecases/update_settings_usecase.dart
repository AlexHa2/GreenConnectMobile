
import 'package:GreenConnectMobile/features/setting/domain/entities/app_settings.dart';
import 'package:GreenConnectMobile/features/setting/domain/repository/settings_repository.dart';

class UpdateSettingsUseCase {
  final SettingsRepository repo;

  UpdateSettingsUseCase(this.repo);

  Future<void> call(AppSettings settings) => repo.updateSettings(settings);
}
