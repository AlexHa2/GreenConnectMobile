import 'package:GreenConnectMobile/features/reward/domain/entities/reward_item_entity.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/reward_item_detail.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';

/// Individual reward card widget
class RewardItemCard extends StatelessWidget {
  final RewardItemEntity item;
  final String redeemButtonText;
  final bool isRedeeming;
  final VoidCallback onRedeem;

  const RewardItemCard({
    super.key,
    required this.item,
    required this.redeemButtonText,
    required this.isRedeeming,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final defaultImage = 'assets/images/leaf_2.png';
    final hasImage = item.imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RewardItemDetail(item: item),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(space / 2),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(space),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColorDark.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image section with badges
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(space),
                topRight: Radius.circular(space),
              ),
              child: Stack(
                children: [
                  _buildImage(theme, hasImage, defaultImage),
                  _buildPointsBadge(theme, space),
                  _buildTypeBadge(theme, space),
                ],
              ),
            ),
            // Content section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(space * 0.75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: space * 0.4),
                    Expanded(
                      child: Text(
                        item.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: space * 0.5),
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        text: redeemButtonText,
                        onPressed: isRedeeming ? null : onRedeem,
                        isEnabled: !isRedeeming,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme, bool hasImage, String defaultImage) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: hasImage
          ? Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: theme.primaryColor.withValues(alpha: 0.05),
                  child: Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: AlwaysStoppedAnimation(
                          theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: theme.primaryColor.withValues(alpha: 0.05),
                  child: Image.asset(
                    defaultImage,
                    fit: BoxFit.cover,
                  ),
                );
              },
            )
          : Container(
              color: theme.primaryColor.withValues(alpha: 0.05),
              child: Image.asset(
                defaultImage,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Widget _buildPointsBadge(ThemeData theme, double space) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: space * 0.75,
          vertical: space * 0.4,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.linearSecondary,
          borderRadius: BorderRadius.circular(space * 0.75),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.stars,
              size: 14,
              color: AppColors.warningUpdate,
            ),
            SizedBox(width: space * 0.25),
            Text(
              '${item.pointsCost}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.primaryColorDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(ThemeData theme, double space) {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: space * 0.6,
          vertical: space * 0.3,
        ),
        decoration: BoxDecoration(
          color: item.type == 'Credit'
              ? AppColors.info
              : theme.primaryColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(space * 0.5),
        ),
        child: Text(
          item.type,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.scaffoldBackgroundColor,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
