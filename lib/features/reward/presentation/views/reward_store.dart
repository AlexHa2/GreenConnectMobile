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
                    final hasImage = item.imageUrl.isNotEmpty;

                    return Container(
                      margin: EdgeInsets.all(space / 2),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(space),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColorDark.withValues(
                              alpha: 0.08,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Image section with loading indicator
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(space),
                              topRight: Radius.circular(space),
                            ),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 120,
                                  width: double.infinity,
                                  child: hasImage
                                      ? Image.network(
                                          item.imageUrl,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Container(
                                              color: theme.primaryColor
                                                  .withValues(alpha: 0.05),
                                              child: Center(
                                                child: SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                    value:
                                                        loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                        : null,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                          theme.primaryColor,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: theme.primaryColor
                                                      .withValues(alpha: 0.05),
                                                  child: Image.asset(
                                                    defaultImage,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          color: theme.primaryColor.withValues(
                                            alpha: 0.05,
                                          ),
                                          child: Image.asset(
                                            defaultImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                // Points badge
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: space * 0.75,
                                      vertical: space * 0.4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.linearSecondary,
                                      borderRadius: BorderRadius.circular(
                                        space * 0.75,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.onSurface.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.stars,
                                          size: 14,
                                          color: AppColors.warningUpdate,
                                        ),
                                        SizedBox(width: space * 0.25),
                                        Text(
                                          '${item.pointsCost}',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: theme.primaryColorDark,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Type badge
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: space * 0.6,
                                      vertical: space * 0.3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item.type == 'Credit'
                                          ? Colors.blue.withValues(alpha: 0.9)
                                          : theme.primaryColor.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(
                                        space * 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      item.type,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme.scaffoldBackgroundColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Content section
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(space * 0.75),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.itemName,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: space * 0.4),
                                  Expanded(
                                    child: Text(
                                      item.description,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme
                                                .textTheme
                                                .bodySmall
                                                ?.color
                                                ?.withValues(alpha: 0.7),
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: space * 0.5),
                                  SizedBox(
                                    width: double.infinity,
                                    child: GradientButton(
                                      text: s.redeem,
                                      onPressed: rewardState.isRedeeming
                                          ? null
                                          : () => _onRedeemItem(
                                              item.rewardItemId,
                                            ),
                                      isEnabled: !rewardState.isRedeeming,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
