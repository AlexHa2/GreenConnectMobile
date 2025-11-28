import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class DeleteOfferDetailUsecase {
  final OfferRepository repository;
  DeleteOfferDetailUsecase(this.repository);

  Future<bool> call({
    required String offerId,
    required String detailId,
  }) {
    return repository.deleteOfferDetail(
      offerId: offerId,
      detailId: detailId,
    );
  }
}
