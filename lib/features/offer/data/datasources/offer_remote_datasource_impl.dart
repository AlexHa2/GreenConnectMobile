import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/offer/data/datasources/offer_remote_datasource.dart';
import 'package:GreenConnectMobile/features/offer/data/models/collection_offer_model.dart';
import 'package:GreenConnectMobile/features/offer/data/models/create_offer_request_model.dart';
import 'package:GreenConnectMobile/features/offer/data/models/paginated_offer_model.dart';

class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  final ApiClient _apiClient = sl<ApiClient>();
  final String _offersBaseUrl = '/v1/offers';
  final String _postsBaseUrl = '/v1/posts';

  @override
  Future<bool> createOffer({
    required String postId,
    required CreateOfferRequestModel request,
    String? slotTimeId,
  }) async {
    var url = '$_postsBaseUrl/$postId/offers';
    if (slotTimeId != null) {
      url += '?slotTimeId=$slotTimeId';
    }

    final res = await _apiClient.post(
      url,
      data: request.toJsonForCreate(),
    );

    return res.statusCode == 201;
  }

  @override
  Future<PaginatedOfferModel> getOffersByPost({
    required String postId,
    String? status,
    required int pageNumber,
    required int pageSize,
  }) async {
    final res = await _apiClient.get(
      '$_postsBaseUrl/$postId/offers',
      queryParameters: {
        if (status != null) 'status': status,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return PaginatedOfferModel.fromJson(res.data);
  }

  @override
  Future<PaginatedOfferModel> getAllOffers({
    String? status,
    bool? sortByCreateAtDesc,
    required int pageNumber,
    required int pageSize,
  }) async {
    final res = await _apiClient.get(
      _offersBaseUrl,
      queryParameters: {
        if (status != null) 'status': status,
        if (sortByCreateAtDesc != null)
          'sortByCreateAtDesc': sortByCreateAtDesc,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return PaginatedOfferModel.fromJson(res.data);
  }

  @override
  Future<CollectionOfferModel> getOfferDetail(String offerId) async {
    final res = await _apiClient.get('$_offersBaseUrl/$offerId');
    return CollectionOfferModel.fromJson(res.data);
  }

  @override
  Future<bool> toggleCancelOffer(String offerId) async {
    final res = await _apiClient.patch(
      '$_offersBaseUrl/$offerId/toggle-cancel',
    );
    return res.statusCode == 200;
  }

  @override
  Future<bool> processOffer({
    required String offerId,
    required bool isAccepted,
    String? responseMessage,
  }) async {
    final queryParams = <String, String>{
      'isAccepted': isAccepted.toString(),
      if (responseMessage != null) 'responseMessage': Uri.encodeComponent(responseMessage),
    };
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    final res = await _apiClient.patch(
      '$_offersBaseUrl/$offerId/process?$queryString',
    );
    return res.statusCode == 200;
  }

  @override
  Future<CollectionOfferModel> addOfferDetail({
    required String offerId,
    required String scrapCategoryId,
    required double pricePerUnit,
    required String unit,
  }) async {
    final res = await _apiClient.post(
      '$_offersBaseUrl/$offerId/details',
      data: {
        'scrapCategoryId': scrapCategoryId,
        'pricePerUnit': pricePerUnit,
        'unit': unit,
      },
    );
    return CollectionOfferModel.fromJson(res.data);
  }

  @override
  Future<CollectionOfferModel> updateOfferDetail({
    required String offerId,
    required String detailId,
    required double pricePerUnit,
    required String unit,
  }) async {
    final res = await _apiClient.put(
      '$_offersBaseUrl/$offerId/details/$detailId',
      data: {'pricePerUnit': pricePerUnit, 'unit': unit},
    );
    return CollectionOfferModel.fromJson(res.data);
  }

  @override
  Future<bool> deleteOfferDetail({
    required String offerId,
    required String detailId,
  }) async {
    final res = await _apiClient.delete(
      '$_offersBaseUrl/$offerId/details/$detailId',
    );
    return res.statusCode == 204 || res.statusCode == 200;
  }
}
