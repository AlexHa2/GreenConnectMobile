import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class ProcessOfferUsecase {
  final OfferRepository repository;
  ProcessOfferUsecase(this.repository);

  Future<bool> call({
    required String offerId,
    required bool isAccepted,
    String? responseMessage,
  }) {
    return repository.processOffer(
      offerId: offerId,
      isAccepted: isAccepted,
      responseMessage: responseMessage,
    );
  }
}
