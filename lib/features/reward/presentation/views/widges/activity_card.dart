import 'package:GreenConnectMobile/features/reward/domain/entities/reward_history_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityCard extends StatefulWidget {
  final RewardHistoryEntity historyItem;

  const ActivityCard({super.key, required this.historyItem});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool isExpanded = false;

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;

    return Container(
      margin: EdgeInsets.symmetric(vertical: space / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        color: theme.cardColor,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(space),
        onTap: () => setState(() => isExpanded = !isExpanded),
        child: Padding(
          padding: EdgeInsets.all(space * 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with date and points
              Row(
                children: [
                  Icon(
                    Icons.card_giftcard,
                    size: 20,
                    color: theme.primaryColor,
                  ),
                  SizedBox(width: space),
                  Expanded(
                    child: Text(
                      _formatDate(widget.historyItem.redemptionDate),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: space,
                      vertical: space / 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(space / 2),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        SizedBox(width: space / 3),
                        Text(
                          "-${widget.historyItem.pointsSpent}",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.danger,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: space / 2),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.iconTheme.color,
                  ),
                ],
              ),

              SizedBox(height: space),

              // Item image and name
              Row(
                children: [
                  // Item thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(space / 2),
                    child: Image.network(
                      widget.historyItem.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 60,
                          height: 60,
                          color: theme.dividerColor,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: theme.dividerColor,
                          child: Icon(
                            Icons.card_giftcard,
                            color: theme.primaryColor,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: space),

                  // Item name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.historyItem.itemName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: space / 3),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: space / 2,
                            vertical: space / 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(space / 3),
                          ),
                          child: Text(
                            s.buyed,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Expandable description section
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: space),
                    Divider(color: theme.dividerColor),
                    SizedBox(height: space),

                    // Description label
                    Text(
                      s.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    SizedBox(height: space / 2),

                    // Description content
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(space),
                      decoration: BoxDecoration(
                        color: theme.dividerColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(space / 2),
                      ),
                      child: Text(
                        widget.historyItem.description,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
