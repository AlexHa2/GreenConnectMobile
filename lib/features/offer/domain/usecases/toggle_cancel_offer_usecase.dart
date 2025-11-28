import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class ToggleCancelOfferUsecase {
  final OfferRepository repository;
  ToggleCancelOfferUsecase(this.repository);

  Future<bool> call(String offerId) {
    return repository.toggleCancelOffer(offerId);
  }
}
