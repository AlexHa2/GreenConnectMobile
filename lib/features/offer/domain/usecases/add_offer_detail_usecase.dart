import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class AddOfferDetailUsecase {
  final OfferRepository repository;
  AddOfferDetailUsecase(this.repository);

  Future<CollectionOfferEntity> call({
    required String offerId,
    required String scrapCategoryId,
    required double pricePerUnit,
    required String unit,
  }) {
    return repository.addOfferDetail(
      offerId: offerId,
      scrapCategoryId: scrapCategoryId,
      pricePerUnit: pricePerUnit,
      unit: unit,
    );
  }
}
