import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class GetOfferDetailUsecase {
  final OfferRepository repository;
  GetOfferDetailUsecase(this.repository);

  Future<CollectionOfferEntity> call(String offerId) {
    return repository.getOfferDetail(offerId);
  }
}
