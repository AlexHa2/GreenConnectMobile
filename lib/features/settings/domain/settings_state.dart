// lib/features/settings/domain/settings_state.dart
class SettingsState {
  final bool isDarkMode;
  final String languageCode;

  SettingsState({required this.isDarkMode, required this.languageCode});

  factory SettingsState.initial() =>
      SettingsState(isDarkMode: false, languageCode: 'vi');

  SettingsState copyWith({bool? isDarkMode, String? languageCode}) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
