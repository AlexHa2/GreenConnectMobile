import 'package:GreenConnectMobile/core/enum/complaint_status.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';

class ComplaintStatusHelper {
  /// Get localized status string
  static String getLocalizedStatus(BuildContext context, ComplaintStatus status) {
    final s = S.of(context)!;
    switch (status) {
      case ComplaintStatus.submitted:
        return s.complaint_submitted;
      case ComplaintStatus.inReview:
        return s.complaint_in_review;
      case ComplaintStatus.resolved:
        return s.complaint_resolved;
      case ComplaintStatus.dismissed:
        return s.complaint_dismissed;
    }
  }

  /// Get color for status
  static Color getStatusColor(BuildContext context, ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.submitted:
        return AppColors.warning; // Yellow for new submissions
      case ComplaintStatus.inReview:
        return AppColors.warningUpdate; // Blue for in review
      case ComplaintStatus.resolved:
        return AppColors.primary; // Green for resolved
      case ComplaintStatus.dismissed:
        return AppColors.danger; // Red for dismissed
    }
  }

  /// Get icon for status
  static IconData getStatusIcon(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.submitted:
        return Icons.report_outlined;
      case ComplaintStatus.inReview:
        return Icons.rate_review_outlined;
      case ComplaintStatus.resolved:
        return Icons.check_circle_outline;
      case ComplaintStatus.dismissed:
        return Icons.cancel_outlined;
    }
  }

  /// Check if complaint can be updated
  static bool canUpdate(ComplaintStatus status) {
    return status == ComplaintStatus.submitted || status == ComplaintStatus.inReview;
  }

  /// Check if complaint can be reopened
  static bool canReopen(ComplaintStatus status) {
    return status == ComplaintStatus.dismissed;
  }
}
