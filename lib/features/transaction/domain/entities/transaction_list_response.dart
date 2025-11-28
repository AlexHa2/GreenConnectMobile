import 'package:GreenConnectMobile/features/offer/domain/entities/paginated_offer_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';

class TransactionListResponse {
  final List<TransactionEntity> data;
  final PaginationInfo pagination;

  TransactionListResponse({
    required this.data,
    required this.pagination,
  });
}
