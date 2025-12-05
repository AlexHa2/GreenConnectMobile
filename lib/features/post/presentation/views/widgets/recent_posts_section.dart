import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/empty_post.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/widgets/post_item.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecentPostsSection extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<ScrapPostEntity> posts;
  final VoidCallback onRefresh;

  const RecentPostsSection({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.posts,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final s = S.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.screenPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.recent_post,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.latest_posts,
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => context.push('/household-list-post'),
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                label: Text(
                  s.view_all,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.screenPadding * 1.5),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.screenPadding),
          child: _buildContent(context, theme, textTheme, s),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
    S s,
  ) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return _ErrorCard(
        errorMessage: errorMessage!,
        onRetry: onRefresh,
        s: s,
        theme: theme,
        textTheme: textTheme,
      );
    }

    if (posts.isEmpty) {
      return const EmptyPost();
    }

    return Column(
      children: posts.map((p) {
        return PostItem(
          title: p.title,
          desc: p.description,
          time: p.availableTimeRange,
          rawStatus: p.status ?? s.unknown,
          localizedStatus: PostStatusHelper.getLocalizedStatus(
            context,
            PostStatus.parseStatus(p.status ?? PostStatus.open.toString()),
          ),
          onTapDetails: () {
            context.push(
              '/detail-post',
              extra: {'postId': p.scrapPostId},
            );
          },
          onGoToOffers: () {
            context.push(
              '/offers-list',
              extra: {
                'postId': p.scrapPostId,
                'isCollectorView': false,
              },
            );
          },
          onGoToTransaction: () {
            context.push(
              '/transaction',
              extra: {'postId': p.scrapPostId},
            );
          },
          timeCreated: p.createdAt?.toString() ?? '',
        );
      }).toList(),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final S s;
  final ThemeData theme;
  final TextTheme textTheme;

  const _ErrorCard({
    required this.errorMessage,
    required this.onRetry,
    required this.s,
    required this.theme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.errorContainer,
            theme.colorScheme.errorContainer.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_off_rounded,
              size: 36,
              color: theme.scaffoldBackgroundColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            s.error_general,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onErrorContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onRetry,
            icon: Icon(
              Icons.refresh_rounded,
              size: 18,
              color: theme.colorScheme.error,
            ),
            label: Text(
              s.retry,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: theme.scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
