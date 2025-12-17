import 'package:GreenConnectMobile/features/offer/domain/entities/paginated_offer_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/credit_transaction_entity.dart';

class CreditTransactionListResponse {
  final List<CreditTransactionEntity> data;
  final PaginationInfo pagination;

  CreditTransactionListResponse({required this.data, required this.pagination});
}
