import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/get_reward_history_usecase.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/get_reward_items_usecase.dart';
import 'package:GreenConnectMobile/features/reward/domain/usecases/redeem_reward_usecase.dart';
import 'package:GreenConnectMobile/features/reward/presentation/providers/reward_providers.dart';
import 'package:GreenConnectMobile/features/reward/presentation/viewmodels/states/reward_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardViewModel extends Notifier<RewardState> {
  late GetRewardItemsUseCase _getRewardItemsUseCase;
  late GetRewardHistoryUseCase _getRewardHistoryUseCase;
  late RedeemRewardUseCase _redeemRewardUseCase;

  @override
  RewardState build() {
    _getRewardItemsUseCase = ref.read(getRewardItemsUsecaseProvider);
    _getRewardHistoryUseCase = ref.read(getRewardHistoryUsecaseProvider);
    _redeemRewardUseCase = ref.read(redeemRewardUsecaseProvider);
    return RewardState();
  }

  Future<void> fetchRewardItems() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      errorCode: null,
    );

    try {
      final items = await _getRewardItemsUseCase();

      state = state.copyWith(
        isLoading: false,
        rewardItems: items,
        errorMessage: null,
        errorCode: null,
      );
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH REWARD ITEMS: ${e.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          errorCode: e.statusCode,
        );
      } else {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
      debugPrint('📌 STACK TRACE: $stack');
    }
  }

  Future<void> fetchRewardHistory() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      errorCode: null,
    );

    try {
      final history = await _getRewardHistoryUseCase();

      state = state.copyWith(
        isLoading: false,
        rewardHistory: history,
        errorMessage: null,
        errorCode: null,
      );
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR FETCH REWARD HISTORY: ${e.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          errorCode: e.statusCode,
        );
      } else {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
      debugPrint('📌 STACK TRACE: $stack');
    }
  }

  Future<void> redeemReward(int rewardItemId) async {
    state = state.copyWith(
      isRedeeming: true,
      errorMessage: null,
      errorCode: null,
      successMessage: null,
    );

    try {
      final success = await _redeemRewardUseCase(rewardItemId);

      if (success) {
        // Refresh reward items first
        await fetchRewardItems();

        state = state.copyWith(
          isRedeeming: false,
          successMessage: 'reward_redeemed_successfully',
          errorMessage: null,
          errorCode: null,
        );
      } else {
        state = state.copyWith(
          isRedeeming: false,
          errorMessage: 'failed_to_redeem_reward',
        );
      }
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR REDEEM REWARD: ${e.message}');
        state = state.copyWith(
          isRedeeming: false,
          errorMessage: e.message,
          errorCode: e.statusCode,
        );
      } else {
        state = state.copyWith(isRedeeming: false, errorMessage: e.toString());
      }
      debugPrint('📌 STACK TRACE: $stack');
    }
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}
