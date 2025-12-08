import 'package:GreenConnectMobile/features/reward/presentation/providers/reward_providers.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/reward_empty_state.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/reward_error_state.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/reward_item_card.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/reward_loading_state.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardStore extends ConsumerStatefulWidget {
  const RewardStore({super.key});

  @override
  ConsumerState<RewardStore> createState() => _RewardStoreState();
}

class _RewardStoreState extends ConsumerState<RewardStore> {
  @override
  void initState() {
    super.initState();
    // Fetch reward items on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rewardViewModelProvider.notifier).fetchRewardItems();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(rewardViewModelProvider.notifier).fetchRewardItems();
  }

  void _onRedeemItem(int rewardItemId) async {
    final s = S.of(context);
    if (s == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(s.confirm),
        content: Text(s.confirm_redeem_reward),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(s.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Clear previous messages before redeeming
      ref.read(rewardViewModelProvider.notifier).clearMessages();
      
      await ref
          .read(rewardViewModelProvider.notifier)
          .redeemReward(rewardItemId);

      if (!mounted) return;

      final state = ref.read(rewardViewModelProvider);
      
      // Check for success
      if (state.successMessage != null) {
        CustomToast.show(
          context,
          s.reward_redeemed_successfully,
          type: ToastType.success,
        );
        ref.read(rewardViewModelProvider.notifier).clearMessages();
      } 
      // Check for error - show the actual error message from API
      else if (state.errorMessage != null) {
        CustomToast.show(
          context,
          state.errorMessage!,
          type: ToastType.error,
        );
        ref.read(rewardViewModelProvider.notifier).clearMessages();
      }
      // If isRedeeming is false but no success/error message, something went wrong
      else if (!state.isRedeeming) {
        CustomToast.show(
          context,
          s.error_occurred,
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    final rewardState = ref.watch(rewardViewModelProvider);
    final rewardItems = rewardState.rewardItems ?? [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(s.reward_store),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: rewardState.isLoading && rewardItems.isEmpty
            ? const RewardLoadingState()
            : rewardState.errorMessage != null && rewardItems.isEmpty
            ? RewardErrorState(
                errorMessage: rewardState.errorMessage!,
                errorTitle: s.error_occurred,
                retryButtonText: s.try_again,
                onRetry: _onRefresh,
              )
            : rewardItems.isEmpty
            ? RewardEmptyState(
                title: s.no_rewards_available,
                message: s.no_rewards_message,
                refreshButtonText: s.try_again,
                onRefresh: _onRefresh,
              )
            : Padding(
                padding: EdgeInsets.all(space),
                child: GridView.builder(
                  itemCount: rewardItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: space * 22,
                    crossAxisSpacing: space,
                    mainAxisSpacing: space,
                  ),
                  itemBuilder: (context, index) {
                    final item = rewardItems[index];
                    return RewardItemCard(
                      item: item,
                      redeemButtonText: s.redeem,
                      isRedeeming: rewardState.isRedeeming,
                      onRedeem: () => _onRedeemItem(item.rewardItemId),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
