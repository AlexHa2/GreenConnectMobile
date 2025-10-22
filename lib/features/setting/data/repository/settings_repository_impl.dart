

import 'package:GreenConnectMobile/features/setting/data/datasources/settings_local_datasource.dart';
import 'package:GreenConnectMobile/features/setting/domain/entities/app_settings.dart';
import 'package:GreenConnectMobile/features/setting/domain/repository/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<AppSettings> getSettings() => localDataSource.getSettings();

  @override
  Future<void> updateSettings(AppSettings settings) =>
      localDataSource.cacheSettings(settings);
}
