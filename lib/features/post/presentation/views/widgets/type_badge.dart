import 'package:GreenConnectMobile/core/enum/scrap_post_detail_type.dart';
import 'package:GreenConnectMobile/core/helper/scrap_post_detail_type_helper.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';

class TypeBadge extends StatelessWidget {
  final String type;
  const TypeBadge({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parsedType = ScrapPostDetailType.fromJson(type);
    final localizedType = ScrapPostDetailTypeHelper.getLocalizedType(
      context,
      parsedType,
    );

    // Define colors and icons for each type
    Color typeColor;
    IconData typeIcon;

    switch (parsedType) {
      case ScrapPostDetailType.sale:
        typeColor = theme.primaryColor; // Green for sale
        typeIcon = Icons.shopping_cart_rounded;
        break;
      case ScrapPostDetailType.donation:
        typeColor = AppColors.info; // Blue for donation
        typeIcon = Icons.favorite_rounded;
        break;
      case ScrapPostDetailType.service:
        typeColor = AppColors.warningUpdate; // Amber for service
        typeIcon = Icons.handshake_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            typeColor.withValues(alpha: 0.15),
            typeColor.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: typeColor.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: typeColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            typeIcon,
            size: 14,
            color: typeColor,
          ),
          const SizedBox(width: 5),
          Text(
            localizedType,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: typeColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
