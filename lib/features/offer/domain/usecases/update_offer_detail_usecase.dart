import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class UpdateOfferDetailUsecase {
  final OfferRepository repository;
  UpdateOfferDetailUsecase(this.repository);

  Future<CollectionOfferEntity> call({
    required String offerId,
    required String detailId,
    required double pricePerUnit,
    required String unit,
  }) {
    return repository.updateOfferDetail(
      offerId: offerId,
      detailId: detailId,
      pricePerUnit: pricePerUnit,
      unit: unit,
    );
  }
}
