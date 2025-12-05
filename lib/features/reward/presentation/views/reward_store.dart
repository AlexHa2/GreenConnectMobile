import 'package:GreenConnectMobile/features/reward/presentation/providers/reward_providers.dart';
import 'package:GreenConnectMobile/features/reward/presentation/widgets/reward_empty_state.dart';
import 'package:GreenConnectMobile/features/reward/presentation/widgets/reward_error_state.dart';
import 'package:GreenConnectMobile/features/reward/presentation/widgets/reward_item_card.dart';
import 'package:GreenConnectMobile/features/reward/presentation/widgets/reward_loading_state.dart';
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
      await ref
          .read(rewardViewModelProvider.notifier)
          .redeemReward(rewardItemId);

      final state = ref.read(rewardViewModelProvider);
      if (state.successMessage != null && mounted) {
        CustomToast.show(
          context,
          s.reward_redeemed_successfully,
          type: ToastType.success,
        );
        // Clear message after showing
        ref.read(rewardViewModelProvider.notifier).clearMessages();
      } else if (state.errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        CustomToast.show(
          context,
          state.errorMessage ?? s.error_occurred,
          type: ToastType.error,
        );
        // Clear message after showing
        ref.read(rewardViewModelProvider.notifier).clearMessages();
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
