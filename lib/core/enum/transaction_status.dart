

enum TransactionStatus {
  scheduled('Scheduled'),
  inProgress('InProgress'),
  completed('Completed'),
  canceledBySystem('CanceledBySystem'),
  canceledByUser('CanceledByUser');

  final String value;
  const TransactionStatus(this.value);

  static TransactionStatus fromJson(String json) {
    return fromString(json);
  }

  /// Parse string to TransactionStatus enum
  static TransactionStatus fromString(String status) {
    final normalizedStatus = status.trim().toUpperCase().replaceAll('_', '');

    switch (normalizedStatus) {
      case 'SCHEDULED':
      case 'PENDING':
        return TransactionStatus.scheduled;
      case 'INPROGRESS':
      case 'IN_PROGRESS':
        return TransactionStatus.inProgress;
      case 'COMPLETED':
        return TransactionStatus.completed;
      case 'CANCELEDBYSYSTEM':
      case 'CANCELED_BY_SYSTEM':
      case 'CANCELLEDBYSYSTEM':
        return TransactionStatus.canceledBySystem;
      case 'CANCELEDBYUSER':
      case 'CANCELED_BY_USER':
      case 'CANCELLEDBYUSER':
      case 'CANCELLED':
      case 'CANCELED':
        return TransactionStatus.canceledByUser;
      default:
        return TransactionStatus.scheduled;
    }
  }

  /// Get display name (localized key)
  String get displayKey {
    switch (this) {
      case TransactionStatus.scheduled:
        return 'pending';
      case TransactionStatus.inProgress:
        return 'in_progress';
      case TransactionStatus.completed:
        return 'completed';
      case TransactionStatus.canceledBySystem:
      case TransactionStatus.canceledByUser:
        return 'cancelled';
    }
  }

  /// Check if transaction is active (not completed or canceled)
  bool get isActive {
    return this == TransactionStatus.scheduled ||
        this == TransactionStatus.inProgress;
  }

  /// Check if transaction is canceled
  bool get isCanceled {
    return this == TransactionStatus.canceledBySystem ||
        this == TransactionStatus.canceledByUser;
  }

  /// Check if transaction is completed
  bool get isCompleted {
    return this == TransactionStatus.completed;
  }

  /// Check if transaction can be canceled by user
  bool get canCancel {
    return this == TransactionStatus.scheduled ||
        this == TransactionStatus.inProgress;
  }

  /// Check if transaction can be checked in (for collector)
  bool get canCheckIn {
    return this == TransactionStatus.scheduled;
  }

  /// Check if transaction can input details (items/prices)
  bool get canInputDetails {
    return this == TransactionStatus.inProgress;
  }

  /// Check if transaction is awaiting confirmation
  bool get isAwaitingConfirmation {
    // This would need to check additional fields in transaction entity
    // For now, return false as it's not a direct status
    return false;
  }
}
