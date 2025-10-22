enum AppTheme { light, dark }

class AppSettings {
  final AppTheme theme;
  final String languageCode; // e.g. 'en', 'vi'

  const AppSettings({required this.theme, required this.languageCode});

  AppSettings copyWith({AppTheme? theme, String? languageCode}) {
    return AppSettings(
      theme: theme ?? this.theme,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
