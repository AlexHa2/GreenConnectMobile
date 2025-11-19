import 'package:GreenConnectMobile/features/profile/domain/entities/verification_entity.dart';

class VerificationModel extends VerificationEntity {
  VerificationModel({
    required super.buyerType,
    required super.documentFrontUrl,
    required super.documentBackUrl,
  });

  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    return VerificationModel(
      buyerType: json['buyerType'] ?? '',
      documentFrontUrl: json['documentFrontUrl'] ?? '',
      documentBackUrl: json['documentBackUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buyerType': buyerType,
      'documentFrontUrl': documentFrontUrl,
      'documentBackUrl': documentBackUrl,
    };
  }
}
