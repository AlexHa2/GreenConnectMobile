import 'dart:convert';
import 'package:GreenConnectMobile/features/setting/data/models/settings_model.dart';
import 'package:GreenConnectMobile/features/setting/domain/entities/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();
  Future<void> cacheSettings(AppSettings settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const _key = 'app_settings';

  @override
  Future<SettingsModel> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);

    if (jsonStr == null) {
      return const SettingsModel(theme: AppTheme.light, languageCode: 'vi');
    }

    final Map<String, dynamic> json = jsonDecode(jsonStr);
    return SettingsModel.fromJson(json);
  }

  @override
  Future<void> cacheSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode({
      'theme': settings.theme == AppTheme.dark ? 'dark' : 'light',
      'languageCode': settings.languageCode,
    });
    await prefs.setString(_key, jsonStr);
  }
}
