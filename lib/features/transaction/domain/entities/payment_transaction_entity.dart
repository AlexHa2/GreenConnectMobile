import 'package:GreenConnectMobile/features/profile/domain/entities/user_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/payment_package_entity.dart';

class PaymentTransactionEntity {
  final String paymentId;
  final String userId;
  final UserEntity user;
  final String packageId;
  final PaymentPackageEntity packageModel;
  final int amount;
  final String paymentGateway;
  final String status;
  final String transactionRef;
  final String vnpTransactionNo;
  final String bankCode;
  final String responseCode;
  final String orderInfo;
  final String clientIpAddress;
  final DateTime createdAt;

  PaymentTransactionEntity({
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
}
