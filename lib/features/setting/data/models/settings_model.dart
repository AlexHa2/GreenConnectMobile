

import 'package:GreenConnectMobile/features/setting/domain/entities/app_settings.dart';

class SettingsModel extends AppSettings {
  const SettingsModel({required super.theme, required super.languageCode});

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      theme: json['theme'] == 'dark' ? AppTheme.dark : AppTheme.light,
      languageCode: json['languageCode'] ?? 'vi',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme == AppTheme.dark ? 'dark' : 'light',
      'languageCode': languageCode,
    };
  }
}
