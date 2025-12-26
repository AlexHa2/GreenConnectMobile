import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/paginated_offer_entity.dart';

abstract class OfferRepository {
  /// POST /api/v1/posts/{postId}/offers?slotTimeId={slotTimeId}
  Future<bool> createOffer({
    required String postId,
    required CreateOfferRequestEntity request,
    required String slotTimeId,
  });

  /// GET /api/v1/posts/{postId}/offers
  Future<PaginatedOfferEntity> getOffersByPost({
    required String postId,
    String? status,
    required int pageNumber,
    required int pageSize,
  });

  /// GET /api/v1/offers
  Future<PaginatedOfferEntity> getAllOffers({
    String? status,
    bool? sortByCreateAtDesc,
    required int pageNumber,
    required int pageSize,
  });

  /// GET /api/v1/offers/{offerId}
  Future<CollectionOfferEntity> getOfferDetail(String offerId);

  /// Toggle Cancel offer (Pending <-> Canceled)
  /// PATCH /api/v1/offers/{offerId}/toggle-cancel
  Future<bool> toggleCancelOffer(String offerId);

  /// PATCH /api/v1/offers/{offerId}/process
  Future<bool> processOffer({
    required String offerId,
    required bool isAccepted,
    String? responseMessage,
  });

  /// POST /api/v1/offers/{offerId}/details
  Future<CollectionOfferEntity> addOfferDetail({
    required String offerId,
    required String scrapCategoryId,
    required double pricePerUnit,
    required String unit,
  });

  /// PUT /api/v1/offers/{offerId}/details/{detailId}
  Future<CollectionOfferEntity> updateOfferDetail({
    required String offerId,
    required String detailId,
    required double pricePerUnit,
    required String unit,
  });

  /// DELETE /api/v1/offers/{offerId}/details/{detailId}
  Future<bool> deleteOfferDetail({
    required String offerId,
    required String detailId,
  });

  /// POST /api/v1/offers/supplementary-offers?postId={postId}
  Future<bool> createSupplementaryOffer({
    required String postId,
    required CreateOfferRequestEntity request,
  });
}
