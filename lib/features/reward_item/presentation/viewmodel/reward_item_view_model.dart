import 'package:GreenConnectMobile/features/reward_item/domain/entities/create_reward_item_request.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/entities/update_reward_item_request.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/usecases/create_reward_item_usecase.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/usecases/delete_reward_item_usecase.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/usecases/get_all_reward_items_usecase.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/usecases/get_reward_item_detail_usecase.dart';
import 'package:GreenConnectMobile/features/reward_item/domain/usecases/update_reward_item_usecase.dart';
import 'package:GreenConnectMobile/features/reward_item/presentation/providers/reward_item_providers.dart';
import 'package:GreenConnectMobile/features/reward_item/presentation/state/reward_item_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardItemViewModel extends Notifier<RewardItemState> {
  late GetAllRewardItemsUsecase _getAllRewardItems;
  late GetRewardItemDetailUsecase _getRewardItemDetail;
  late CreateRewardItemUsecase _createRewardItem;
  late UpdateRewardItemUsecase _updateRewardItem;
  late DeleteRewardItemUsecase _deleteRewardItem;

  @override
  RewardItemState build() {
    _getAllRewardItems = ref.read(getAllRewardItemsUsecaseProvider);
    _getRewardItemDetail = ref.read(getRewardItemDetailUsecaseProvider);
    _createRewardItem = ref.read(createRewardItemUsecaseProvider);
    _updateRewardItem = ref.read(updateRewardItemUsecaseProvider);
    _deleteRewardItem = ref.read(deleteRewardItemUsecaseProvider);
    return RewardItemState();
  }

  /// Fetch all reward items with optional filters
  Future<void> fetchAllRewardItems({
    int? pageIndex,
    int? pageSize,
    String? name,
    bool? sortByPoint,
  }) async {
    state = state.copyWith(isLoadingList: true, errorMessage: null);
    try {
      final result = await _getAllRewardItems(
        pageIndex: pageIndex,
        pageSize: pageSize,
        name: name,
        sortByPoint: sortByPoint,
      );
      state = state.copyWith(
        isLoadingList: false,
        listData: result,
      );
    } catch (e, stack) {
      debugPrint('❌ ERROR in fetchAllRewardItems: $e');
      debugPrint('Stack trace: $stack');
      state = state.copyWith(
        isLoadingList: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Fetch reward item detail by ID
  Future<void> fetchRewardItemDetail(int rewardItemId) async {
    state = state.copyWith(isLoadingDetail: true, errorMessage: null);
    try {
      final result = await _getRewardItemDetail(rewardItemId);
      state = state.copyWith(
        isLoadingDetail: false,
        detailData: result,
      );
    } catch (e, stack) {
      debugPrint('❌ ERROR in fetchRewardItemDetail: $e');
      debugPrint('Stack trace: $stack');
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Create a new reward item
  Future<bool> createRewardItem({
    required String itemName,
    required String description,
    required int pointsCost,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);
    try {
      final request = CreateRewardItemRequest(
        itemName: itemName,
        description: description,
        pointsCost: pointsCost,
      );
      final success = await _createRewardItem(request);
      state = state.copyWith(isProcessing: false);
      return success;
    } catch (e, stack) {
      debugPrint('❌ ERROR in createRewardItem: $e');
      debugPrint('Stack trace: $stack');
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Update an existing reward item
  Future<bool> updateRewardItem({
    required int rewardItemId,
    String? itemName,
    String? description,
    int? pointsCost,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);
    try {
      final request = UpdateRewardItemRequest(
        itemName: itemName,
        description: description,
        pointsCost: pointsCost,
      );
      final result = await _updateRewardItem(
        rewardItemId: rewardItemId,
        request: request,
      );
      state = state.copyWith(
        isProcessing: false,
        detailData: result,
      );
      return true;
    } catch (e, stack) {
      debugPrint('❌ ERROR in updateRewardItem: $e');
      debugPrint('Stack trace: $stack');
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Delete a reward item
  Future<bool> deleteRewardItem(int rewardItemId) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);
    try {
      final success = await _deleteRewardItem(rewardItemId);
      state = state.copyWith(isProcessing: false);
      return success;
    } catch (e, stack) {
      debugPrint('❌ ERROR in deleteRewardItem: $e');
      debugPrint('Stack trace: $stack');
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}