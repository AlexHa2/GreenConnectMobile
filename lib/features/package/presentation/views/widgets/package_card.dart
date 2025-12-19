import 'package:GreenConnectMobile/core/helper/currency_helper.dart';
import 'package:GreenConnectMobile/features/package/domain/entities/package_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class PackageCard extends StatelessWidget {
  final PackageEntity package;
  final VoidCallback? onTap;

  const PackageCard({super.key, required this.package, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      margin: EdgeInsets.symmetric(horizontal: space, vertical: space * 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(space),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(space),
        child: Padding(
          padding: EdgeInsets.all(space * 1.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Package name and type badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      package.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: space * 0.5),
                  _buildTypeBadge(package.packageType, theme, space, s),
                ],
              ),

              SizedBox(height: space * 0.8),

              // Description
              Text(
                package.description,
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: space),

              // Divider
              Divider(
                color: theme.dividerColor.withValues(alpha: 0.5),
                height: 1,
              ),

              SizedBox(height: space),

              // Footer: Price and Connection Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.package_price,
                          style: textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: space * 0.3),
                        package.price == 0
                            ? Text(
                                s.free,
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )
                            : Text(
                                formatVND(package.price),
                                style: textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                      ],
                    ),
                  ),

                  // Connection Amount (if available)
                  if (package.connectionAmount != null) ...[
                    SizedBox(width: space),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: space,
                        vertical: space * 0.6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(space * 0.6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 18,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          SizedBox(width: space * 0.4),
                          Text(
                            '${package.connectionAmount}',
                            style: textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type, ThemeData theme, double space, S s) {
    final isFreemium =
        type == s.freemium_packages || type.toLowerCase() == 'freemium';
    final badgeColor = isFreemium ? Colors.green : theme.colorScheme.primary;
    final badgeText = isFreemium ? s.freemium_packages : s.paid_packages;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: space * 0.8,
        vertical: space * 0.4,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(space * 0.5),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        badgeText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
