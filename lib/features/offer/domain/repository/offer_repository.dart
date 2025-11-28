import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/paginated_offer_entity.dart';

abstract class OfferRepository {
  /// Tạo đề nghị thu gom cho một bài đăng
  /// POST /api/v1/posts/{postId}/offers
  Future<CollectionOfferEntity> createOffer({
    required String postId,
    required CreateOfferRequestEntity request,
  });

  /// Lấy danh sách các đề nghị cho một bài đăng cụ thể
  /// GET /api/v1/posts/{postId}/offers
  Future<PaginatedOfferEntity> getOffersByPost({
    required String postId,
    String? status,
    required int pageNumber,
    required int pageSize,
  });

  /// Lấy danh sách tất cả các đề nghị (của collector)
  /// GET /api/v1/offers
  Future<PaginatedOfferEntity> getAllOffers({
    String? status,
    bool? sortByCreateAtDesc,
    required int pageNumber,
    required int pageSize,
  });

  /// Lấy chi tiết một đề nghị
  /// GET /api/v1/offers/{offerId}
  Future<CollectionOfferEntity> getOfferDetail(String offerId);

  /// Toggle Cancel offer (Pending <-> Canceled)
  /// PATCH /api/v1/offers/{offerId}/toggle-cancel
  Future<bool> toggleCancelOffer(String offerId);

  /// Xử lý đề nghị (Accept/Reject)
  /// PATCH /api/v1/offers/{offerId}/process
  Future<bool> processOffer({
    required String offerId,
    required bool isAccepted,
  });

  /// Thêm chi tiết offer mới
  /// POST /api/v1/offers/{offerId}/details
  Future<CollectionOfferEntity> addOfferDetail({
    required String offerId,
    required int scrapCategoryId,
    required double pricePerUnit,
    required String unit,
  });

  /// Cập nhật chi tiết offer
  /// PUT /api/v1/offers/{offerId}/details/{detailId}
  Future<CollectionOfferEntity> updateOfferDetail({
    required String offerId,
    required String detailId,
    required double pricePerUnit,
    required String unit,
  });

  /// Xóa chi tiết offer
  /// DELETE /api/v1/offers/{offerId}/details/{detailId}
  Future<bool> deleteOfferDetail({
    required String offerId,
    required String detailId,
  });
}
