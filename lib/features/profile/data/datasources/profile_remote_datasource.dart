import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/profile/data/models/profile_model.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/profile_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/user_update_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/verification_entity.dart';

class ProfileRemoteDatasource {
  final ApiClient _apiClient = sl<ApiClient>();
  final String verifyUrl = '/v1/profile/verification';
  final String getMeUrl = '/v1/profile/me';
  final String updateMeUrl = '/v1/profile/me';
  final String updateAvatarUrl = '/v1/profile/avatar';
  final String updateVerificationUrl = '/v1/admin/verifications/update-verification';
  Future<String> verifyUser({required VerificationEntity verify}) async {
    try {
      final response = await _apiClient.post(
        verifyUrl,
        data: {
          'buyerType': verify.buyerType,
          'documentFrontUrl': verify.documentFrontUrl,
          'documentBackUrl': verify.documentBackUrl,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('User verification failed: $e');
    }
  }

  Future<ProfileEntity> getMe() async {
    try {
      final response = await _apiClient.get(getMeUrl);
      final responeJson = ProfileModel.fromJson(response.data);
      return responeJson.toEntity();
    } catch (e) {
      throw Exception('Get user info failed: $e');
    }
  }

  Future<ProfileEntity> updateMe({required UserUpdateEntity update}) async {
    try {
      final resUpdateProfile = await _apiClient.put(
        updateMeUrl,
        data: {
          'fullName': update.fullName,
          'address': update.address,
          'gender': update.gender,
          'dateOfBirth': update.dateOfBirth,
          'bankCode': update.bankCode,
          'bankAccountNumber': update.bankAccountNumber,
          'bankAccountName': update.bankAccountName
        },
      );
      final updatedProfile = ProfileModel.fromJson(resUpdateProfile.data);
      return updatedProfile.toEntity();
    } catch (e) {
      throw Exception('Update user info failed: $e');
    }
  }

  Future<bool> updateAvatar({required String avatarUrl}) async {
    final resUpdateProfile = await _apiClient.post(
      updateAvatarUrl,
      data: {"fileName": avatarUrl},
    );
    if (resUpdateProfile.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<String> updateVerification({required VerificationEntity verify}) async {
    try {
      final queryParams = Uri(queryParameters: {
        'documentFrontUrl': verify.documentFrontUrl,
        'documentBackUrl': verify.documentBackUrl,
        'buyerType': verify.buyerType,
      }).query;
      
      final response = await _apiClient.patch(
        '$updateVerificationUrl?$queryParams',
      );
      return response.data;
    } catch (e) {
      throw Exception('Update verification failed: $e');
    }
  }
}
