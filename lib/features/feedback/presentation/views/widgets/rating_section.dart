import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Interactive star rating section with animations
class RatingSection extends StatelessWidget {
  final int selectedRating;
  final ValueChanged<int> onRatingChanged;
  final String? ratingText;

  const RatingSection({
    super.key,
    required this.selectedRating,
    required this.onRatingChanged,
    this.ratingText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Container(
      padding: EdgeInsets.all(spacing * 1.5),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing * 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, spacing, s),
          SizedBox(height: spacing * 1.5),
          _buildStarRating(theme, spacing),
          if (selectedRating > 0 && ratingText != null) ...[
            SizedBox(height: spacing),
            _buildRatingText(theme, ratingText!),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, double spacing, S s) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(spacing * 0.8),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(spacing),
          ),
          child: Icon(
            Icons.star_rounded,
            color: AppColors.warning,
            size: spacing * 2,
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.your_rating,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing * 0.3),
              Text(
                s.rating_description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStarRating(ThemeData theme, double spacing) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: spacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.warning.withValues(alpha: 0.08),
            AppColors.warning.withValues(alpha: 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(spacing),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          final starValue = index + 1;
          final isSelected = starValue <= selectedRating;

          return GestureDetector(
            onTap: () {
              onRatingChanged(starValue);
              HapticFeedback.lightImpact();
            },
            child: AnimatedScale(
              scale: isSelected ? 1.0 : 0.9,
              duration: const Duration(milliseconds: 200),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(spacing * 0.8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.warning.withValues(alpha: 0.2)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isSelected
                      ? AppColors.warning
                      : theme.iconTheme.color?.withValues(alpha: 0.3),
                  size: spacing * 3,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRatingText(ThemeData theme, String text) {
    return Center(
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.warning,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
