import 'dart:typed_data';

import 'package:GreenConnectMobile/features/profile/domain/entities/verification_entity.dart';

class VerificationModel extends VerificationEntity {
  VerificationModel({
    required super.buyerType,
    super.documentFrontUrl,
    super.documentBackUrl,
    super.frontImageBytes,
    super.backImageBytes,
    super.frontImageName,
    super.backImageName,
  });

  // Factory for URL-based (legacy/update mode)
  factory VerificationModel.fromUrls({
    required String buyerType,
    required String documentFrontUrl,
    required String documentBackUrl,
  }) {
    return VerificationModel(
      buyerType: buyerType,
      documentFrontUrl: documentFrontUrl,
      documentBackUrl: documentBackUrl,
    );
  }

  // Factory for file-based (new create mode)
  factory VerificationModel.fromFiles({
    required String buyerType,
    required Uint8List frontImageBytes,
    required Uint8List backImageBytes,
    String frontImageName = 'front.jpg',
    String backImageName = 'back.jpg',
  }) {
    return VerificationModel(
      buyerType: buyerType,
      frontImageBytes: frontImageBytes,
      backImageBytes: backImageBytes,
      frontImageName: frontImageName,
      backImageName: backImageName,
    );
  }

  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    return VerificationModel(
      buyerType: json['buyerType'] ?? '',
      documentFrontUrl: json['documentFrontUrl'],
      documentBackUrl: json['documentBackUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buyerType': buyerType,
      if (documentFrontUrl != null) 'documentFrontUrl': documentFrontUrl,
      if (documentBackUrl != null) 'documentBackUrl': documentBackUrl,
    };
  }
}
