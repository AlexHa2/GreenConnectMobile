import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/core/helper/time_ago_helper.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  final CollectionOfferEntity offer;
  final VoidCallback onTap;
  final bool isCollectorView;

  const OfferCard({
    super.key,
    required this.offer,
    required this.onTap,
    this.isCollectorView = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(spacing),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status badge
            Container(
              padding: EdgeInsets.all(spacing),
              decoration: BoxDecoration(
                color: _getStatusColor(
                  offer.status,
                  theme,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(spacing),
                  topRight: Radius.circular(spacing),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing,
                      vertical: spacing / 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(offer.status, theme),
                      borderRadius: BorderRadius.circular(spacing),
                    ),
                    child: Text(
                      OfferStatus.labelS(context, offer.status),
                      style: TextStyle(
                        color: theme.scaffoldBackgroundColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    TimeAgoHelper.format(context, offer.createdAt),
                    style: TextStyle(
                      color: _getStatusColor(offer.status, theme),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(spacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post info for collector view OR Collector info for household view
                  if (isCollectorView && offer.scrapPost != null) ...[
                    // Show post information
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(spacing),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(spacing),
                          ),
                          child: Icon(
                            Icons.article_outlined,
                            color: theme.primaryColor,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                offer.scrapPost!.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: spacing / 3),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                  SizedBox(width: spacing / 3),
                                  Expanded(
                                    child: Text(
                                      offer.scrapPost!.address,
                                      style: theme.textTheme.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing),
                    // Household info
                    if (offer.scrapPost!.household != null)
                      Container(
                        padding: EdgeInsets.all(spacing * 0.75),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(spacing * 0.75),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: spacing * 1.5,
                              backgroundColor: theme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              backgroundImage:
                                  offer.scrapPost!.household!.avatarUrl != null
                                      ? NetworkImage(
                                          offer.scrapPost!.household!.avatarUrl!,
                                        )
                                      : null,
                              child: offer.scrapPost!.household!.avatarUrl == null
                                  ? Icon(
                                      Icons.person,
                                      color: theme.primaryColor,
                                      size: 20,
                                    )
                                  : null,
                            ),
                            SizedBox(width: spacing),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    offer.scrapPost!.household!.fullName,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 12,
                                        color: theme.textTheme.bodySmall?.color,
                                      ),
                                      SizedBox(width: spacing / 3),
                                      Text(
                                        offer.scrapPost!.household!.phoneNumber,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: spacing * 0.75,
                                vertical: spacing / 3,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.stars,
                                    size: 12,
                                    color: theme.primaryColor,
                                  ),
                                  SizedBox(width: spacing / 4),
                                  Text(
                                    offer.scrapPost!.household!.rank,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: spacing),
                    Divider(height: 1, color: theme.dividerColor),
                    SizedBox(height: spacing),
                  ] else if (!isCollectorView && offer.scrapCollector != null) ...[
                    Row(
                      children: [
                        CircleAvatar(
                          radius: spacing * 2,
                          backgroundColor: theme.primaryColor.withValues(
                            alpha: 0.1,
                          ),
                          backgroundImage:
                              offer.scrapCollector!.avatarUrl != null
                              ? NetworkImage(offer.scrapCollector!.avatarUrl!)
                              : null,
                          child: offer.scrapCollector!.avatarUrl == null
                              ? Icon(
                                  Icons.person,
                                  color: theme.primaryColor,
                                  size: 24,
                                )
                              : null,
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                offer.scrapCollector!.fullName ?? s.unknown,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: spacing / 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 14,
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                  SizedBox(width: spacing / 3),
                                  Text(
                                    offer.scrapCollector!.phoneNumber ?? 'N/A',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Rank badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing,
                            vertical: spacing / 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.primaryColor,
                                theme.primaryColor.withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.stars,
                                size: 14,
                                color: theme.scaffoldBackgroundColor,
                              ),
                              SizedBox(width: spacing / 3),
                              Text(
                                offer.scrapCollector!.rank,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: theme.scaffoldBackgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing),
                    Divider(height: 1, color: theme.dividerColor),
                    SizedBox(height: spacing),
                  ],

                  // Offer details
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.category_outlined,
                  //       size: 18,
                  //       color: theme.primaryColor,
                  //     ),
                  //     const SizedBox(width: 8),
                  //     Text(
                  //       offer.offerDetails.length == 1
                  //           ? s.items_count(offer.offerDetails.length)
                  //           : s.items_count_plural(offer.offerDetails.length),
                  //       style: theme.textTheme.bodyMedium?.copyWith(
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //     SizedBox(width: spacing),
                  //     const Icon(
                  //       Icons.schedule,
                  //       size: 18,
                  //       color: AppColors.warningUpdate,
                  //     ),
                  //     SizedBox(width: spacing),
                  //     Text(
                  //       offer.scheduleProposals.length == 1
                  //           ? s.schedules_count(offer.scheduleProposals.length)
                  //           : s.schedules_count_plural(
                  //               offer.scheduleProposals.length,
                  //             ),
                  //       style: theme.textTheme.bodyMedium?.copyWith(
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // Offer items preview
                  if (offer.offerDetails.isNotEmpty) ...[
                    SizedBox(height: spacing),
                    Container(
                      padding: EdgeInsets.all(spacing),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(spacing),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.pricing_details,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: spacing / 2),
                          ...offer.offerDetails.take(2).map((detail) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: spacing / 2),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: spacing),
                                  Expanded(
                                    child: Text(
                                      detail.scrapCategory!.categoryName,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                  Text(
                                    '${detail.pricePerUnit} ${detail.unit}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          if (offer.offerDetails.length > 2)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                s.more_items(offer.offerDetails.length - 2),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],

                  // View details button
                  // SizedBox(height: spacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        s.view_details,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(offer.status, theme),
                        ),
                      ),
                      SizedBox(width: spacing / 3),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: _getStatusColor(offer.status, theme),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OfferStatus status, ThemeData theme) {
    switch (status) {
      case OfferStatus.pending:
        return AppColors.warningUpdate;
      case OfferStatus.accepted:
        return theme.primaryColor;
      case OfferStatus.rejected:
        return AppColorsDark.danger;
      case OfferStatus.canceled:
        return theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }
}
