import 'package:flutter/material.dart';

/// Hero image section for reward item detail
class RewardDetailHeroImage extends StatelessWidget {
  final String imageUrl;
  final String defaultImage;
  final String type;

  const RewardDetailHeroImage({
    super.key,
    required this.imageUrl,
    required this.defaultImage,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = imageUrl.isNotEmpty;

    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.05),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          _buildImage(theme, hasImage),
          _buildGradientOverlay(theme),
          _buildTypeBadge(theme),
        ],
      ),
    );
  }

  Widget _buildImage(ThemeData theme, bool hasImage) {
    return SizedBox.expand(
      child: hasImage
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: theme.primaryColor.withValues(alpha: 0.05),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      valueColor: AlwaysStoppedAnimation(theme.primaryColor),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(defaultImage, fit: BoxFit.cover);
              },
            )
          : Image.asset(defaultImage, fit: BoxFit.cover),
    );
  }

  Widget _buildGradientOverlay(ThemeData theme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(ThemeData theme) {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: type == 'Credit'
              ? Colors.blue
              : theme.primaryColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          type,
          style: theme.textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
