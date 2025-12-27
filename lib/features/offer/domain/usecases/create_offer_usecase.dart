import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class CreateOfferUsecase {
  final OfferRepository repository;
  CreateOfferUsecase(this.repository);

  Future<bool> call({
    required String postId,
    required CreateOfferRequestEntity request,
    required String slotTimeId,
  }) {
    return repository.createOffer(
      postId: postId,
      request: request,
      slotTimeId: slotTimeId,
    );
  }
}
