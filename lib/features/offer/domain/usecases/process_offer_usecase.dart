import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class ProcessOfferUsecase {
  final OfferRepository repository;
  ProcessOfferUsecase(this.repository);

  Future<bool> call({
    required String offerId,
    required bool isAccepted,
  }) {
    return repository.processOffer(
      offerId: offerId,
      isAccepted: isAccepted,
    );
  }
}
