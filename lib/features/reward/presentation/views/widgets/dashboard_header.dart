import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;
    final space = spacing.screenPadding;

    return SliverAppBar(
      expandedHeight: 240,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.primaryColor,
      foregroundColor: theme.scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.only(
          left: space * 2,
          right: space * 2,
          bottom: space * 1.5,
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            final isCollapsed = constraints.maxHeight <= kToolbarHeight + 50;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${s.reward} ${s.dashboard}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.scaffoldBackgroundColor,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4.0,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(height: 6),
                  Text(
                    s.keep_making_difference,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: theme.dividerColor,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            );
          },
        ),
        background: _buildBackground(context, space),
      ),
    );
  }

  Widget _buildBackground(BuildContext context, double space) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(gradient: AppColors.linearPrimary),
        ),
        Positioned(
          right: -50,
          top: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.1),
            ),
          ),
        ),
        Positioned(
          left: -30,
          bottom: -30,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.05),
            ),
          ),
        ),
        Positioned(
          right: space * 2,
          top: space * 8,
          child: Icon(
            Icons.card_giftcard_rounded,
            size: 60,
            color: theme.scaffoldBackgroundColor.withValues(alpha: 0.15),
          ),
        ),
      ],
    );
  }
}
