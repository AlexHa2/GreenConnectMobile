import 'package:GreenConnectMobile/features/offer/data/models/collection_offer_model.dart';
import 'package:GreenConnectMobile/features/offer/data/models/create_offer_request_model.dart';
import 'package:GreenConnectMobile/features/offer/data/models/paginated_offer_model.dart';

abstract class OfferRemoteDataSource {
  Future<bool> createOffer({
    required String postId,
    required CreateOfferRequestModel request,
    required String slotTimeId,
  });

  Future<PaginatedOfferModel> getOffersByPost({
    required String postId,
    String? status,
    required int pageNumber,
    required int pageSize,
  });

  Future<PaginatedOfferModel> getAllOffers({
    String? status,
    bool? sortByCreateAtDesc,
    required int pageNumber,
    required int pageSize,
  });

  Future<CollectionOfferModel> getOfferDetail(String offerId);

  Future<bool> toggleCancelOffer(String offerId);

  Future<bool> processOffer({
    required String offerId,
    required bool isAccepted,
    String? responseMessage,
  });

  Future<CollectionOfferModel> addOfferDetail({
    required String offerId,
    required String scrapCategoryId,
    required double pricePerUnit,
    required String unit,
  });

  Future<CollectionOfferModel> updateOfferDetail({
    required String offerId,
    required String detailId,
    required double pricePerUnit,
    required String unit,
  });

  Future<bool> deleteOfferDetail({
    required String offerId,
    required String detailId,
  });

  Future<bool> createSupplementaryOffer({
    required String postId,
    required CreateOfferRequestModel request,
  });
}
