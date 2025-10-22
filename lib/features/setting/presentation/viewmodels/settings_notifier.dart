import 'package:GreenConnectMobile/features/setting/domain/entities/app_settings.dart';
import 'package:GreenConnectMobile/features/setting/domain/usecases/get_settings_usecase.dart';
import 'package:GreenConnectMobile/features/setting/domain/usecases/update_settings_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class SettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final GetSettingsUseCase _getSettings;
  final UpdateSettingsUseCase _updateSettings;

  SettingsNotifier(this._getSettings, this._updateSettings)
    : super(const AsyncValue.loading()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _getSettings();
      if (settings == null) {
        final defaultSettings = const AppSettings(
          theme: AppTheme.light,
          languageCode: 'vi',
        );
        await _updateSettings(defaultSettings);
        state = AsyncValue.data(defaultSettings);
      }

      state = AsyncValue.data(
        settings ??
            const AppSettings(theme: AppTheme.light, languageCode: 'vi'),
      );
    } catch (e) {
      state = const AsyncValue.data(
        AppSettings(theme: AppTheme.light, languageCode: 'vi'),
      );
    }
  }

  Future<void> toggleTheme() async {
    final current = state.value;
    if (current == null) return;

    final newSettings = current.copyWith(
      theme: current.theme == AppTheme.dark ? AppTheme.light : AppTheme.dark,
    );

    await _updateSettings(newSettings);
    state = AsyncValue.data(newSettings);
  }

  Future<void> changeLanguage(String code) async {
    final current = state.value;
    if (current == null) return;

    final newSettings = current.copyWith(languageCode: code);
    await _updateSettings(newSettings);
    state = AsyncValue.data(newSettings);
  }
}
