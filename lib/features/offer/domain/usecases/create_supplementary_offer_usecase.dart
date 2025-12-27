import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class CreateSupplementaryOfferUsecase {
  final OfferRepository repository;
  CreateSupplementaryOfferUsecase(this.repository);

  Future<bool> call({
    required String postId,
    required CreateOfferRequestEntity request,
  }) {
    return repository.createSupplementaryOffer(
      postId: postId,
      request: request,
    );
  }
}

