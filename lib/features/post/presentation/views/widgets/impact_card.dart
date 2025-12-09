import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ImpactCard extends StatelessWidget {
  final bool isLoading;
  final int pointBalance;
  final int earnPointFromPosts;
  final int totalMyPosts;

  const ImpactCard({
    super.key,
    this.isLoading = false,
    required this.pointBalance,
    required this.earnPointFromPosts,
    required this.totalMyPosts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final s = S.of(context)!;

    return Container(
      margin: EdgeInsets.all(spacing.screenPadding),
      decoration: BoxDecoration(
        gradient: AppColors.linearPrimary,
        borderRadius: BorderRadius.circular(spacing.screenPadding * 2),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(spacing.screenPadding * 2),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _PatternPainter(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(spacing.screenPadding * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.your_impact,
                              style: textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              s.keep_your_tree,
                              style: textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(spacing.screenPadding),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.eco_rounded,
                          color: theme.colorScheme.onPrimary,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.screenPadding * 2),
                  Container(
                    padding: EdgeInsets.all(spacing.screenPadding),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius: BorderRadius.circular(
                        spacing.screenPadding,
                      ),
                    ),
                    child: isLoading
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(spacing.screenPadding),
                              child: CircularProgressIndicator(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pointBalance.toString(),
                                        style: textTheme.headlineMedium
                                            ?.copyWith(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        s.points,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onPrimary
                                              .withValues(alpha: 0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(
                                      spacing.screenPadding,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.onPrimary
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(
                                        spacing.screenPadding,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '+$earnPointFromPosts',
                                          style: textTheme.titleLarge?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          s.from_posts,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onPrimary
                                                .withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: spacing.screenPadding * 1.5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.article_outlined,
                                    color: theme.colorScheme.onPrimary,
                                    size: 20,
                                  ),
                                  SizedBox(width: spacing.screenPadding / 2),
                                  Text(
                                    '${s.total_posts}: $totalMyPosts',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onPrimary
                                          .withValues(alpha: 0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const spacing = 30.0;

    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
