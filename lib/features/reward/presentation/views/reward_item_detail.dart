import 'package:GreenConnectMobile/features/reward/domain/entities/reward_item_entity.dart';
import 'package:GreenConnectMobile/features/reward/presentation/providers/reward_providers.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/reward_description_section.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/reward_detail_hero_image.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/reward_info_section.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/widgets/reward_points_cost_card.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardItemDetail extends ConsumerWidget {
  final RewardItemEntity item;

  const RewardItemDetail({super.key, required this.item});

  void _onRedeemItem(
    BuildContext context,
    WidgetRef ref,
    int rewardItemId,
  ) async {
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

    if (confirmed == true && context.mounted) {
      await ref
          .read(rewardViewModelProvider.notifier)
          .redeemReward(rewardItemId);

      final state = ref.read(rewardViewModelProvider);
      if (state.successMessage != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.reward_redeemed_successfully),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        ref.read(rewardViewModelProvider.notifier).clearMessages();
        // Navigate back after successful redeem
        Navigator.pop(context);
      } else if (state.errorMessage != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        ref.read(rewardViewModelProvider.notifier).clearMessages();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    if (s == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final rewardState = ref.watch(rewardViewModelProvider);
    final defaultImage = 'assets/images/leaf_2.png';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          s.reward_details,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image section
            RewardDetailHeroImage(
              imageUrl: item.imageUrl,
              defaultImage: defaultImage,
              type: item.type,
            ),

            // Content section
            Padding(
              padding: EdgeInsets.all(space * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item name
                  Text(
                    item.itemName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  SizedBox(height: space),

                  // Points cost card
                  RewardPointsCostCard(
                    pointsCost: item.pointsCost,
                    pointsLabel: s.points,
                  ),
                  SizedBox(height: space * 2),

                  // Value section
                  RewardInfoSection(
                    title: s.value,
                    value: item.value,
                    icon: Icons.monetization_on_outlined,
                  ),
                  SizedBox(height: space * 1.5),

                  // Description section
                  RewardDescriptionSection(
                    title: s.description,
                    description: item.description,
                  ),
                  SizedBox(height: space * 3),

                  // Redeem button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: GradientButton(
                      text: rewardState.isRedeeming
                          ? '${s.loading}...'
                          : s.redeem,
                      onPressed: rewardState.isRedeeming
                          ? null
                          : () =>
                                _onRedeemItem(context, ref, item.rewardItemId),
                      isEnabled: !rewardState.isRedeeming,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
