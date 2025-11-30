import 'package:GreenConnectMobile/core/enum/complaint_status.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_entity.dart';
import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/transaction_model.dart';

class ComplaintModel {
  final String complaintId;
  final String transactionId;
  final TransactionModel? transaction;
  final String complainantId;
  final UserModel? complainant;
  final String accusedId;
  final UserModel? accused;
  final String reason;
  final String? evidenceUrl;
  final String status;
  final String createdAt;

  ComplaintModel({
    required this.complaintId,
    required this.transactionId,
    this.transaction,
    required this.complainantId,
    this.complainant,
    required this.accusedId,
    this.accused,
    required this.reason,
    this.evidenceUrl,
    required this.status,
    required this.createdAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      complaintId: json['complaintId'] ?? '',
      transactionId: json['transactionId'] ?? '',
      transaction: json['transaction'] != null
          ? TransactionModel.fromJson(json['transaction'])
          : null,
      complainantId: json['complainantId'] ?? '',
      complainant: json['complainant'] != null
          ? UserModel.fromJson(json['complainant'])
          : null,
      accusedId: json['accusedId'] ?? '',
      accused: json['accused'] != null
          ? UserModel.fromJson(json['accused'])
          : null,
      reason: json['reason'] ?? '',
      evidenceUrl: json['evidenceUrl'],
      status: json['status'] ?? 'Submitted',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complaintId': complaintId,
      'transactionId': transactionId,
      'transaction': transaction?.toJson(),
      'complainantId': complainantId,
      'complainant': complainant?.toJson(),
      'accusedId': accusedId,
      'accused': accused?.toJson(),
      'reason': reason,
      'evidenceUrl': evidenceUrl,
      'status': status,
      'createdAt': createdAt,
    };
  }

  ComplaintEntity toEntity() {
    return ComplaintEntity(
      complaintId: complaintId,
      transactionId: transactionId,
      transaction: transaction?.toEntity(),
      complainantId: complainantId,
      complainant: complainant?.toEntity(),
      accusedId: accusedId,
      accused: accused?.toEntity(),
      reason: reason,
      evidenceUrl: evidenceUrl,
      status: ComplaintStatus.fromString(status),
      createdAt: DateTime.parse(createdAt),
    );
  }
}
