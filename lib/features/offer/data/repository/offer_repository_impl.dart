import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/offer/data/datasources/offer_remote_datasource.dart';
import 'package:GreenConnectMobile/features/offer/data/models/create_offer_request_model.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/create_offer_request_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/paginated_offer_entity.dart';
import 'package:GreenConnectMobile/features/offer/domain/repository/offer_repository.dart';

class OfferRepositoryImpl implements OfferRepository {
  final OfferRemoteDataSource remote;

  OfferRepositoryImpl(this.remote);

  @override
  Future<CollectionOfferEntity> createOffer({
    required String postId,
    required CreateOfferRequestEntity request,
  }) {
    return guard(() async {
      final model = CreateOfferRequestModel.fromEntity(request);
      final result = await remote.createOffer(postId: postId, request: model);
      return result.toEntity();
    });
  }

  @override
  Future<PaginatedOfferEntity> getOffersByPost({
    required String postId,
    String? status,
    required int pageNumber,
    required int pageSize,
  }) {
    return guard(() async {
      final result = await remote.getOffersByPost(
        postId: postId,
        status: status,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return result.toEntity();
    });
  }

  @override
  Future<PaginatedOfferEntity> getAllOffers({
    String? status,
    bool? sortByCreateAtDesc,
    required int pageNumber,
    required int pageSize,
  }) {
    return guard(() async {
      final result = await remote.getAllOffers(
        status: status,
        sortByCreateAtDesc: sortByCreateAtDesc,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return result.toEntity();
    });
  }

  @override
  Future<CollectionOfferEntity> getOfferDetail(String offerId) {
    return guard(() async {
      final result = await remote.getOfferDetail(offerId);
      return result.toEntity();
    });
  }

  @override
  Future<bool> toggleCancelOffer(String offerId) {
    return guard(() async {
      return await remote.toggleCancelOffer(offerId);
    });
  }

  @override
  Future<bool> processOffer({
    required String offerId,
    required bool isAccepted,
  }) {
    return guard(() async {
      return await remote.processOffer(
        offerId: offerId,
        isAccepted: isAccepted,
      );
    });
  }

  @override
  Future<CollectionOfferEntity> addOfferDetail({
    required String offerId,
    required int scrapCategoryId,
    required double pricePerUnit,
    required String unit,
  }) {
    return guard(() async {
      final result = await remote.addOfferDetail(
        offerId: offerId,
        scrapCategoryId: scrapCategoryId,
        pricePerUnit: pricePerUnit,
        unit: unit,
      );
      return result.toEntity();
    });
  }

  @override
  Future<CollectionOfferEntity> updateOfferDetail({
    required String offerId,
    required String detailId,
    required double pricePerUnit,
    required String unit,
  }) {
    return guard(() async {
      final result = await remote.updateOfferDetail(
        offerId: offerId,
        detailId: detailId,
        pricePerUnit: pricePerUnit,
        unit: unit,
      );
      return result.toEntity();
    });
  }

  @override
  Future<bool> deleteOfferDetail({
    required String offerId,
    required String detailId,
  }) {
    return guard(() async {
      return await remote.deleteOfferDetail(
        offerId: offerId,
        detailId: detailId,
      );
    });
  }
}
