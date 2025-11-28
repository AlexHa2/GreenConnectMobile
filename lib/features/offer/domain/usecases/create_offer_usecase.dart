import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class CreateOfferUsecase {
  final OfferRepository repository;
  CreateOfferUsecase(this.repository);

  Future<CollectionOfferEntity> call({
    required String postId,
    required CreateOfferRequestEntity request,
  }) {
    return repository.createOffer(postId: postId, request: request);
  }
}
