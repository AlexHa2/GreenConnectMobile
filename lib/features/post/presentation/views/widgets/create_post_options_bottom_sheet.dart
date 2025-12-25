import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatePostOptionsBottomSheet extends StatelessWidget {
  const CreatePostOptionsBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      showDragHandle: true,
      builder: (context) => const CreatePostOptionsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(spacing.screenPadding),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        spacing.screenPadding,
        spacing.screenPadding * 0.5,
        spacing.screenPadding,
        spacing.screenPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOptionCard(
            context: context,
            theme: theme,
            spacing: spacing,
            icon: Icons.edit_outlined,
            title: s.create,
            subtitle: s.create_post_manually_subtitle,
            description: s.create_post_manually_description,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
            onTap: () {
              context.pop();
              context.push('/create-post');
            },
          ),
          SizedBox(height: spacing.screenPadding * 0.75),
          _buildOptionCard(
            context: context,
            theme: theme,
            spacing: spacing,
            icon: Icons.auto_awesome,
            title: s.create_post_with_ai_title,
            subtitle: s.create_post_with_ai_subtitle,
            description: s.create_post_with_ai_description,
            gradient: LinearGradient(
              colors: [
                AppColors.info,
                AppColors.info.withValues(alpha: 0.8),
              ],
            ),
            onTap: () {
              context.pop();
              context.push('/create-post-with-ai');
            },
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required ThemeData theme,
    required AppSpacing spacing,
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(spacing.screenPadding),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(spacing.screenPadding),
        child: Container(
          padding: EdgeInsets.all(spacing.screenPadding * 1.25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(spacing.screenPadding),
            border: Border.all(
              color: theme.dividerColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing.screenPadding),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius:
                      BorderRadius.circular(spacing.screenPadding * 0.75),
                ),
                child: Icon(
                  icon,
                  color: theme.scaffoldBackgroundColor,
                  size: 28,
                ),
              ),
              SizedBox(width: spacing.screenPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing.screenPadding / 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: spacing.screenPadding / 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.scaffoldBackgroundColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
