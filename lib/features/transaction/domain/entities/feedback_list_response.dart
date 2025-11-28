import 'package:GreenConnectMobile/features/offer/domain/entities/paginated_offer_entity.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/feedback_entity.dart';

class FeedbackListResponse {
  final List<FeedbackEntity> data;
  final PaginationInfo pagination;

  FeedbackListResponse({
    required this.data,
    required this.pagination,
  });
}
