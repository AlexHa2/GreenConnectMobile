import 'package:GreenConnectMobile/features/package/presentation/views/widgets/package_action_grid.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/widgets/package_credit_card.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/widgets/package_info_banner.dart';
import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackageDashboardPage extends ConsumerWidget {
  const PackageDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    final profileState = ref.watch(profileViewModelProvider);
    final user = profileState.user;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(s.package_dashboard),
        titleTextStyle: TextStyle(
          color: theme.scaffoldBackgroundColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.scaffoldBackgroundColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Full screen gradient background
          Container(
            decoration: const BoxDecoration(gradient: AppColors.linearPrimary),
          ),
          // Content with SafeArea
          SafeArea(
            child: profileState.isLoading && profileState.user == null
                ? const Center(child: CircularProgressIndicator())
                : profileState.errorMessage != null && profileState.user == null
                    ? Center(child: Text(profileState.errorMessage!))
                    : RefreshIndicator(
                        onRefresh: () async {
                          await ref.read(profileViewModelProvider.notifier).getMe();
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(space),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(space * 2),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const InfoBanner(),
                                const SizedBox(height: 20),
                                CreditCard(user: user),
                                const SizedBox(height: 28),
                                const ActionGrid(),
                                const SizedBox(height: 28),
                                _buildTipsSection(context, theme, space, s),
                              ],
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection(BuildContext context, ThemeData theme, double space, S s) {
    return Container(
      padding: EdgeInsets.all(space * 1.2),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(space * 1.5),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: theme.primaryColor,
                size: 20,
              ),
              SizedBox(width: space * 0.5),
              Text(
                s.useful_tips,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: space),
          _buildTipItem(
            theme,
            Icons.stars_rounded,
            s.tip_earn_points_regularly,
          ),
          SizedBox(height: space * 0.75),
          _buildTipItem(
            theme,
            Icons.card_giftcard,
            s.tip_use_points_for_packages,
          ),
          SizedBox(height: space * 0.75),
          _buildTipItem(
            theme,
            Icons.history,
            s.tip_view_history,
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(ThemeData theme, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.primaryColor.withValues(alpha: 0.7),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
