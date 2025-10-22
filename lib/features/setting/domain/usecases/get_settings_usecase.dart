import 'package:GreenConnectMobile/features/setting/domain/entities/app_settings.dart';
import 'package:GreenConnectMobile/features/setting/domain/repository/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  Future<AppSettings?> call() async {
    final settings = await repository.getSettings();
    return settings ??
        const AppSettings(theme: AppTheme.light, languageCode: 'vi');
  }
}
