import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/reward_item/data/datasources/reward_item_remote_datasource.dart';
import 'package:GreenConnectMobile/features/reward_item/data/models/reward_item_list_response_model.dart';
import 'package:GreenConnectMobile/features/reward_item/data/models/reward_item_model.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/create_reward_item_request.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/update_reward_item_request.dart';

class RewardItemRemoteDatasourceImpl implements RewardItemRemoteDatasource {
  final ApiClient _apiClient = sl<ApiClient>();
  static const String _rewardItemsBaseUrl = '/v1/reward-items';

  @override
  Future<RewardItemListResponseModel> getAllRewardItems({
    int? pageIndex,
    int? pageSize,
    String? name,
    bool? sortByPoint,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (pageIndex != null) {
      queryParams['pageIndex'] = pageIndex;
    }
    if (pageSize != null) {
      queryParams['pageSize'] = pageSize;
    }
    if (name != null) {
      queryParams['name'] = name;
    }
    if (sortByPoint != null) {
      queryParams['sortByPoint'] = sortByPoint;
    }

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    final url = queryString.isEmpty
        ? _rewardItemsBaseUrl
        : '$_rewardItemsBaseUrl?$queryString';

    final res = await _apiClient.get(url);
    return RewardItemListResponseModel.fromJson(res.data);
  }

  @override
  Future<RewardItemModel> getRewardItemDetail(int rewardItemId) async {
    final res = await _apiClient.get('$_rewardItemsBaseUrl/$rewardItemId');
    return RewardItemModel.fromJson(res.data);
  }

  @override
  Future<bool> createRewardItem(CreateRewardItemRequest request) async {
    final res = await _apiClient.post(
      _rewardItemsBaseUrl,
      data: request.toJson(),
    );
    return res.statusCode == 201;
  }

  @override
  Future<RewardItemModel> updateRewardItem({
    required int rewardItemId,
    required UpdateRewardItemRequest request,
  }) async {
    final res = await _apiClient.patch(
      '$_rewardItemsBaseUrl/$rewardItemId',
      data: request.toJson(),
    );
    return RewardItemModel.fromJson(res.data);
  }

  @override
  Future<bool> deleteRewardItem(int rewardItemId) async {
    final res = await _apiClient.delete('$_rewardItemsBaseUrl/$rewardItemId');
    return res.statusCode == 200;
  }
}
