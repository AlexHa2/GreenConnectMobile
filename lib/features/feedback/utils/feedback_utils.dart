import 'package:GreenConnectMobile/generated/l10n.dart';

/// Utility functions for feedback feature
class FeedbackUtils {
  FeedbackUtils._();

  /// Get rating text with emoji based on rating value
  static String getRatingText(int rating, S s) {
    switch (rating) {
      case 1:
        return '😞 ${s.poor}';
      case 2:
        return '😐 ${s.fair}';
      case 3:
        return '🙂 ${s.good}';
      case 4:
        return '😊 ${s.veryGood}';
      case 5:
        return '🤩 ${s.excellent}';
      default:
        return '';
    }
  }

  /// Get emoji only based on rating value
  static String getRatingEmoji(int rating) {
    switch (rating) {
      case 1:
        return '😞';
      case 2:
        return '😐';
      case 3:
        return '🙂';
      case 4:
        return '😊';
      case 5:
        return '🤩';
      default:
        return '⭐';
    }
  }

  /// Validate rating value
  static bool isValidRating(int rating) {
    return rating >= 1 && rating <= 5;
  }

  /// Validate comment
  static String? validateComment(String? comment, S s) {
    if (comment == null || comment.trim().isEmpty) {
      return s.comment_required;
    }
    return null;
  }
}
