import 'package:GreenConnectMobile/features/offer/domain/entities/paginated_offer_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class GetOffersByPostUsecase {
  final OfferRepository repository;
  GetOffersByPostUsecase(this.repository);

  Future<PaginatedOfferEntity> call({
    required String postId,
    String? status,
    required int pageNumber,
    required int pageSize,
  }) {
    return repository.getOffersByPost(
      postId: postId,
      status: status,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
