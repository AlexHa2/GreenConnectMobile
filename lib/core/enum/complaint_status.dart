enum ComplaintStatus {
  submitted,
  inReview,
  resolved,
  dismissed;

  String toJson() => name;

  String get label {
    switch (this) {
      case ComplaintStatus.submitted:
        return 'Submitted';
      case ComplaintStatus.inReview:
        return 'InReview';
      case ComplaintStatus.resolved:
        return 'Resolved';
      case ComplaintStatus.dismissed:
        return 'Dismissed';
    }
  }

  static ComplaintStatus fromString(String status) {
    final normalized = status
        .toLowerCase()
        .replaceAll('_', '')
        .replaceAll(' ', '');
    switch (normalized) {
      case 'submitted':
        return ComplaintStatus.submitted;
      case 'inreview':
        return ComplaintStatus.inReview;
      case 'resolved':
        return ComplaintStatus.resolved;
      case 'dismissed':
        return ComplaintStatus.dismissed;
      default:
        return ComplaintStatus.submitted;
    }
  }


  static ComplaintStatus parseStatus(String status) {
    return fromString(status);
  }
}
