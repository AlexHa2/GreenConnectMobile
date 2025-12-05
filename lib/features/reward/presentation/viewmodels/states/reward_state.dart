import 'package:GreenConnectMobile/features/reward/domain/entities/reward_history_entity.dart';
import 'package:GreenConnectMobile/features/reward/domain/entities/reward_item_entity.dart';

class RewardState {
  final bool isLoading;
  final bool isRedeeming;
  final String? errorMessage;
  final int? errorCode;
  final List<RewardItemEntity>? rewardItems;
  final List<RewardHistoryEntity>? rewardHistory;
  final String? successMessage;

  RewardState({
    this.isLoading = false,
    this.isRedeeming = false,
    this.errorMessage,
    this.errorCode,
    this.rewardItems,
    this.rewardHistory,
    this.successMessage,
  });

  RewardState copyWith({
    bool? isLoading,
    bool? isRedeeming,
    String? errorMessage,
    int? errorCode,
    List<RewardItemEntity>? rewardItems,
    List<RewardHistoryEntity>? rewardHistory,
    String? successMessage,
  }) {
    return RewardState(
      isLoading: isLoading ?? this.isLoading,
      isRedeeming: isRedeeming ?? this.isRedeeming,
      errorMessage: errorMessage,
      errorCode: errorCode,
      rewardItems: rewardItems ?? this.rewardItems,
      rewardHistory: rewardHistory ?? this.rewardHistory,
      successMessage: successMessage,
    );
  }
}
