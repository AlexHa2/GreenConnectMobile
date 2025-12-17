import 'package:GreenConnectMobile/features/offer/domain/entities/paginated_offer_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/payment_transaction_entity.dart';

class PaymentTransactionListResponse {
  final List<PaymentTransactionEntity> data;
  final PaginationInfo pagination;

  PaymentTransactionListResponse({
    required this.data,
    required this.pagination,
  });
}
