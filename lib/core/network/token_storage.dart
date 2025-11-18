import 'dart:convert';
import 'package:GreenConnectMobile/features/authentication/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  static const String _keyAccessToken = 'ACCESS_TOKEN';
  static const String _keyUserData = 'USER_DATA';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// save data of user and token
  Future<void> saveAuthData({
    required String accessToken,
    required UserModel user,
  }) async {
    // 1. save tokens (type String)
    await _storage.write(key: _keyAccessToken, value: accessToken);

    // 2. parse UserModel to JSON String saving
    final userJsonString = jsonEncode(user.toJson());
    await _storage.write(key: _keyUserData, value: userJsonString);
  }

  // --- read data ---

  Future<String?> getAccessToken() async {
    return _storage.read(key: _keyAccessToken);
  }

  Future<UserModel?> getUserData() async {
    final userJsonString = await _storage.read(key: _keyUserData);

    if (userJsonString != null) {
      try {
        // 1. Parse JSON String to Map
        final userMap = jsonDecode(userJsonString) as Map<String, dynamic>;
        // 2. Parse Map to UserModel object
        return UserModel.fromJson(userMap);
      } catch (e) {
        // If data is corrupted, clear it
        print("Error decoding UserModel (secure_storage): $e");
        await clearAuthData();
        return null;
      }
    }
    return null;
  }

  // --- delete methods ---

  /// Delete all data (used when logout)
  Future<void> clearAuthData() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyUserData);
    // await _storage.deleteAll();
    print("Đã xoá toàn bộ dữ liệu xác thực (secure)!");
  }
}
