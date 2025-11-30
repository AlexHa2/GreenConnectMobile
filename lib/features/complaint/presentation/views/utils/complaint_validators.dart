import 'package:GreenConnectMobile/generated/l10n.dart';

class ComplaintValidators {
  static const int minReasonLength = 10;

  static String? validateReason(String? value, S s) {
    if (value == null || value.trim().isEmpty) {
      return s.please_enter_reason;
    }

    if (value.trim().length < minReasonLength) {
      return s.reason_too_short;
    }

    return null;
  }

  static String? validateEvidence(String? imagePath, S s) {
    if (imagePath == null || imagePath.isEmpty) {
      return s.please_select_evidence_image;
    }
    return null;
  }

  static bool validateAllFields({
    required String reason,
    required bool hasImage,
    required S s,
    required Function(String) onError,
  }) {
    final reasonError = validateReason(reason, s);
    if (reasonError != null) {
      onError(reasonError);
      return false;
    }

    if (!hasImage) {
      onError(s.please_select_evidence_image);
      return false;
    }

    return true;
  }
}
