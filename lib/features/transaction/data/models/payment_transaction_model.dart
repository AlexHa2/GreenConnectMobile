import 'package:GreenConnectMobile/features/profile/data/models/user_model.dart';
import 'package:GreenConnectMobile/features/transaction/data/models/payment_package_model.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/payment_transaction_entity.dart';

class PaymentTransactionModel {
  final String paymentId;
  final String userId;
  final UserModel user;
  final String packageId;
  final PaymentPackageModel packageModel;
  final double amount;
  final String paymentGateway;
  final String status;
  final String transactionRef;
  final String vnpTransactionNo;
  final String bankCode;
  final String responseCode;
  final String orderInfo;
  final String clientIpAddress;
  final DateTime createdAt;

  PaymentTransactionModel({
    required this.paymentId,
    required this.userId,
    required this.user,
    required this.packageId,
    required this.packageModel,
    required this.amount,
    required this.paymentGateway,
    required this.status,
    required this.transactionRef,
    required this.vnpTransactionNo,
    required this.bankCode,
    required this.responseCode,
    required this.orderInfo,
    required this.clientIpAddress,
    required this.createdAt,
  });

  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) {
    return PaymentTransactionModel(
      paymentId: json['paymentId'] ?? '',
      userId: json['userId'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      packageId: json['packageId'] ?? '',
      packageModel: PaymentPackageModel.fromJson(json['package'] ?? {}),
      amount: json['amount'] ?? 0,
      paymentGateway: json['paymentGateway'] ?? '',
      status: json['status'] ?? '',
      transactionRef: json['transactionRef'] ?? '',
      vnpTransactionNo: json['vnpTransactionNo'] ?? '',
      bankCode: json['bankCode'] ?? '',
      responseCode: json['responseCode'] ?? '',
      orderInfo: json['orderInfo'] ?? '',
      clientIpAddress: json['clientIpAddress'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  PaymentTransactionEntity toEntity() {
    return PaymentTransactionEntity(
      paymentId: paymentId,
      userId: userId,
      user: user.toEntity(),
      packageId: packageId,
      packageModel: packageModel.toEntity(),
      amount: amount,
      paymentGateway: paymentGateway,
      status: status,
      transactionRef: transactionRef,
      vnpTransactionNo: vnpTransactionNo,
      bankCode: bankCode,
      responseCode: responseCode,
      orderInfo: orderInfo,
      clientIpAddress: clientIpAddress,
      createdAt: createdAt,
    );
  }
}
