import 'dart:typed_data';

class VerificationEntity {
  final String buyerType;
  final String? documentFrontUrl; // For update mode (URL from server)
  final String? documentBackUrl; // For update mode (URL from server)
  final Uint8List? frontImageBytes; // For create mode (direct upload)
  final Uint8List? backImageBytes; // For create mode (direct upload)
  final String? frontImageName; // Filename for multipart
  final String? backImageName; // Filename for multipart

  VerificationEntity({
    required this.buyerType,
    this.documentFrontUrl,
    this.documentBackUrl,
    this.frontImageBytes,
    this.backImageBytes,
    this.frontImageName,
    this.backImageName,
  });

  // Factory for URL-based verification (update mode)
  factory VerificationEntity.fromUrls({
    required String buyerType,
    required String documentFrontUrl,
    required String documentBackUrl,
  }) {
    return VerificationEntity(
      buyerType: buyerType,
      documentFrontUrl: documentFrontUrl,
      documentBackUrl: documentBackUrl,
    );
  }

  // Factory for file-based verification (create mode)
  factory VerificationEntity.fromFiles({
    required String buyerType,
    required Uint8List frontImageBytes,
    required Uint8List backImageBytes,
    String frontImageName = 'front.jpg',
    String backImageName = 'back.jpg',
  }) {
    return VerificationEntity(
      buyerType: buyerType,
      frontImageBytes: frontImageBytes,
      backImageBytes: backImageBytes,
      frontImageName: frontImageName,
      backImageName: backImageName,
    );
  }

  bool get hasFiles => frontImageBytes != null && backImageBytes != null;
  bool get hasUrls => documentFrontUrl != null && documentBackUrl != null;
}
