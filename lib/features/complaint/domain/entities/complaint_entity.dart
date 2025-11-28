import 'package:GreenConnectMobile/features/profile/domain/entities/user_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';

enum ComplaintStatus {
  submitted('Submitted'),
  pending('Pending'),
  accepted('Accepted'),
  rejected('Rejected'),
  reopened('Reopened');

  final String value;
  const ComplaintStatus(this.value);

  static ComplaintStatus fromString(String status) {
    return ComplaintStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == status.toLowerCase(),
      orElse: () => ComplaintStatus.submitted,
    );
  }
}

class ComplaintEntity {
  final String complaintId;
  final String transactionId;
  final TransactionEntity? transaction;
  final String complainantId;
  final UserEntity complainant;
  final String accusedId;
  final UserEntity accused;
  final String reason;
  final String evidenceUrl;
  final ComplaintStatus status;
  final DateTime createdAt;

  ComplaintEntity({
    required this.complaintId,
    required this.transactionId,
    this.transaction,
    required this.complainantId,
    required this.complainant,
    required this.accusedId,
    required this.accused,
    required this.reason,
    required this.evidenceUrl,
    required this.status,
    required this.createdAt,
  });
}
