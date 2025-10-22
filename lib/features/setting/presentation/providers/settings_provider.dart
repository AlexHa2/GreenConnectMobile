import 'package:GreenConnectMobile/features/setting/data/datasources/settings_local_datasource.dart';
import 'package:GreenConnectMobile/features/setting/data/repository/settings_repository_impl.dart';
import 'package:GreenConnectMobile/features/setting/domain/entities/app_settings.dart';
import 'package:GreenConnectMobile/features/setting/domain/usecases/get_settings_usecase.dart';
import 'package:GreenConnectMobile/features/setting/domain/usecases/update_settings_usecase.dart';
import 'package:GreenConnectMobile/features/setting/presentation/viewmodels/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Data layer
final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((
  ref,
) {
  return SettingsLocalDataSourceImpl();
});

final settingsRepositoryProvider = Provider<SettingsRepositoryImpl>((ref) {
  final local = ref.read(settingsLocalDataSourceProvider);
  return SettingsRepositoryImpl(local);
});

// Use cases
final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((ref) {
  final repo = ref.read(settingsRepositoryProvider);
  return GetSettingsUseCase(repo);
});

final updateSettingsUseCaseProvider = Provider<UpdateSettingsUseCase>((ref) {
  final repo = ref.read(settingsRepositoryProvider);
  return UpdateSettingsUseCase(repo);
});

// State Notifier
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<AppSettings>>((ref) {
      final getUseCase = ref.read(getSettingsUseCaseProvider);
      final updateUseCase = ref.read(updateSettingsUseCaseProvider);
      return SettingsNotifier(getUseCase, updateUseCase);
    });
