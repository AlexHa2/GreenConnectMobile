import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ImpactCard extends StatelessWidget {
  const ImpactCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final s = S.of(context)!;

    return Container(
      margin: EdgeInsets.all(spacing.screenPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF29C562), Color(0xFF70D194)],
          stops: [0.60, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
                                color: theme.colorScheme.onPrimary
                                    .withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(spacing.screenPadding),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary
                              .withValues(alpha: 0.2),
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
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(spacing.screenPadding),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "150",
                              style: textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "/ 500 ${s.points}",
                              style: textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing.screenPadding),
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(spacing.screenPadding),
                          child: LinearProgressIndicator(
                            value: 150 / 500,
                            backgroundColor: theme.colorScheme.onPrimary
                                .withValues(alpha: 0.2),
                            color: theme.colorScheme.onPrimary,
                            minHeight: 10,
                          ),
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
