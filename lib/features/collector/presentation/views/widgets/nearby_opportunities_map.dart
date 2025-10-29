import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class NearbyOpportunitiesMap extends StatelessWidget {
  final VoidCallback onTapMap;
  final VoidCallback onBrowseAllJobs;

  const NearbyOpportunitiesMap({
    super.key,
    required this.onTapMap,
    required this.onBrowseAllJobs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context)!.nearby_opportunities,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: spacing.screenPadding * 2,
                color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
              ),
            ),
            Icon(
              Icons.map_outlined,
              color: AppColors.primary,
              size: spacing.screenPadding * 3,
            ),
          ],
        ),
        SizedBox(height: spacing.screenPadding * 1.5),

        // Map Container
        GestureDetector(
          onTap: onTapMap,
          child: Container(
            height: 280,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(spacing.screenPadding * 2),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(spacing.screenPadding * 2),
              child: Stack(
                children: [
                  // Map background pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: MapGridPainter(),
                    ),
                  ),

                  // Location markers
                  Positioned(
                    left: 80,
                    top: 60,
                    child: _buildMapMarker(AppColors.primary, 28),
                  ),
                  Positioned(
                    right: 60,
                    top: 50,
                    child: _buildMapMarker(AppColors.primary, 28),
                  ),
                  Positioned(
                    left: 100,
                    bottom: 100,
                    child: _buildMapMarker(AppColors.primary, 28),
                  ),
                  Positioned(
                    right: 90,
                    bottom: 110,
                    child: _buildMapMarker(AppColors.primary, 28),
                  ),

                  // Center overlay with text
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.screenPadding * 2,
                        vertical: spacing.screenPadding * 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(
                          spacing.screenPadding * 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app,
                            color: AppColors.primary,
                            size: spacing.screenPadding * 2,
                          ),
                          SizedBox(width: spacing.screenPadding),
                          Text(
                            S.of(context)!.tap_to_view_opportunities,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: spacing.screenPadding * 2),

        // Quick Actions Section
        Text(
          S.of(context)!.quick_actions,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: spacing.screenPadding),

        // Browse All Jobs Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onBrowseAllJobs,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: spacing.screenPadding * 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.screenPadding * 1.5),
              ),
              elevation: 2,
            ),
            child: Text(
              S.of(context)!.browse_all_jobs,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapMarker(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.location_on,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}

// Custom painter for map grid pattern
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withValues(alpha: 0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    const gridSize = 40.0;
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // Draw some decorative roads/paths
    final roadPaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.15)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Horizontal road
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      roadPaint,
    );

    // Vertical road
    canvas.drawLine(
      Offset(size.width * 0.6, 0),
      Offset(size.width * 0.6, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

