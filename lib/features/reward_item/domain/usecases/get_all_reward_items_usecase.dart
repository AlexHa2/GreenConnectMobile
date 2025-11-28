import 'package:GreenConnectMobile/features/reward_item/domain/entities/reward_item_list_response.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/repositories/reward_item_repository.dart';

class GetAllRewardItemsUsecase {
  final RewardItemRepository _repository;

  GetAllRewardItemsUsecase(this._repository);

  Future<RewardItemListResponse> call({
    int? pageIndex,
    int? pageSize,
    String? name,
    bool? sortByPoint,
  }) async {
    return await _repository.getAllRewardItems(
      pageIndex: pageIndex,
      pageSize: pageSize,
      name: name,
      sortByPoint: sortByPoint,
    );
  }
}
