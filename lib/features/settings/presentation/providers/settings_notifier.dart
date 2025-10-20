// lib/features/settings/application/settings_notifier.dart
import 'package:GreenConnectMobile/features/settings/domain/settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:GreenConnectMobile/core/services/settings_service.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SettingsService _service;

  SettingsNotifier(this._service) : super(SettingsState.initial()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isDark = await _service.loadTheme();
    final lang = await _service.loadLanguage();
    state = SettingsState(isDarkMode: isDark, languageCode: lang);
  }

  Future<void> toggleTheme() async {
    final newValue = !state.isDarkMode;
    await _service.saveTheme(newValue);
    state = state.copyWith(isDarkMode: newValue);
  }

  Future<void> changeLanguage(String code) async {
    await _service.saveLanguage(code);
    state = state.copyWith(languageCode: code);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier(SettingsService());
  },
);
