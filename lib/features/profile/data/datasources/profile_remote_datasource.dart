import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/profile/data/models/profile_model.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/profile_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/user_update_entity.dart';
import 'package:GreenConnectMobile/features/profile/domain/entities/verification_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ProfileRemoteDatasource {
  final ApiClient _apiClient = sl<ApiClient>();
  final String verifyUrl = '/v1/profile/verification';
  final String getMeUrl = '/v1/profile/me';
  final String updateMeUrl = '/v1/profile/me';
  final String updateAvatarUrl = '/v1/profile/avatar';
  final String updateVerificationUrl =
      '/v1/admin/verifications/update-verification';

  /// Verify user with multipart/form-data
  /// Sends FrontImage file and BuyerType directly to the API
  Future<String> verifyUser({required VerificationEntity verify}) async {
    if (verify.hasFiles) {
      final formData = FormData.fromMap({
        'BuyerType': verify.buyerType,
        'FrontImage': MultipartFile.fromBytes(
          verify.frontImageBytes!,
          filename: verify.frontImageName ?? 'front.jpg',
        ),
      });

      final response = await _apiClient.postMultipart(verifyUrl, formData);

      // Handle response based on API structure
      if (response.data is String) {
        return response.data;
      } else if (response.data is Map) {
        return response.data['message'] ??
            'Verification submitted successfully';
      }
      return 'Verification submitted successfully';
    } else {
      // Fallback to old URL-based flow (if still needed)
      final response = await _apiClient.post(
        verifyUrl,
        data: {
          'buyerType': verify.buyerType,
          'documentFrontUrl': verify.documentFrontUrl,
          'documentBackUrl': verify.documentBackUrl,
        },
      );
      return response.data;
    }
  }

  Future<ProfileEntity> getMe() async {
    final response = await _apiClient.get(getMeUrl);
    final responeJson = ProfileModel.fromJson(response.data);
    return responeJson.toEntity();
  }

  Future<ProfileEntity> updateMe({required UserUpdateEntity update}) async {
    final body = {
      'fullName': update.fullName,
      'address': update.address,
      'gender': update.gender,
      'dateOfBirth': update.dateOfBirth,
      'location': update.location,
      'bankCode': update.bankCode,
      'bankAccountNumber': update.bankAccountNumber,
      'bankAccountName': update.bankAccountName,
    };
    final resUpdateProfile = await _apiClient.put(
      updateMeUrl,
      data: body,
    );
    final updatedProfile = ProfileModel.fromJson(resUpdateProfile.data);
    return updatedProfile.toEntity();
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

  Future<String> updateVerification({
    required VerificationEntity verify,
  }) async {
    debugPrint(
      'ProfileRemoteDatasource: updateVerification with buyerType: ${verify.buyerType}',
    );

    // Check if we have file bytes (new flow with multipart)
    if (verify.hasFiles) {
      final formData = FormData.fromMap({
        'BuyerType': verify.buyerType,
        'FrontImage': MultipartFile.fromBytes(
          verify.frontImageBytes!,
          filename: verify.frontImageName ?? 'front.jpg',
        ),
      });

      final response = await _apiClient.patchMultipart(updateVerificationUrl, formData);

      // Handle response based on API structure
      if (response.data is String) {
        return response.data;
      } else if (response.data is Map) {
        return response.data['message'] ??
            'Verification updated successfully';
      }
      return 'Verification updated successfully';
    } else {
      // Fallback to old URL-based flow (if still needed)
      final queryParams = Uri(
        queryParameters: {
          'documentFrontUrl': verify.documentFrontUrl,
          'documentBackUrl': verify.documentBackUrl,
          'buyerType': verify.buyerType,
        },
      ).query;

      final response = await _apiClient.patch(
        '$updateVerificationUrl?$queryParams',
      );
      return response.data;
    }
  }
}
