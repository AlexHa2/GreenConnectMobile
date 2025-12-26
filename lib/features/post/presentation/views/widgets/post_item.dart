import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/core/helper/time_ago_helper.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final String title;
  final String desc;
  final String rawStatus;
  final String timeCreated;
  final String localizedStatus;
  final VoidCallback onTapDetails;
  final VoidCallback? onGoToTransaction;
  final VoidCallback? onGoToOffers;
  final bool isCollectorView;

  const PostItem({
    super.key,
    required this.title,
    required this.desc,
    required this.rawStatus,
    required this.localizedStatus,
    required this.onTapDetails,
    this.onGoToTransaction,
    this.onGoToOffers,
    required this.timeCreated,
    this.isCollectorView = false,
  });

  IconData _statusIcon(PostStatus status) {
    switch (status) {
      case PostStatus.open:
        return Icons.hourglass_top_rounded;
      case PostStatus.partiallyBooked:
        return Icons.check_circle_rounded;
      case PostStatus.fullyBooked:
        return Icons.event_busy_rounded;
      case PostStatus.completed:
        return Icons.check_circle_rounded;
      case PostStatus.canceled:
        return Icons.cancel_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>();
    final space = spacing?.screenPadding ?? 12;

    final status = PostStatus.parseStatus(rawStatus);
    final statusColor = PostStatusHelper.getStatusColor(context, status);

    final isAccepted = PostStatusHelper.showTransactionAction(rawStatus);
    final showOffersButton = PostStatusHelper.showOffersButton(status);

    DateTime? createdAt;
    try {
      createdAt = DateTime.parse(timeCreated);
    } catch (_) {
      createdAt = null;
    }
    final createdAgo =
        createdAt == null ? '' : TimeAgoHelper.format(context, createdAt);

    final hasActions = !isCollectorView && (true);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(space),
        side: BorderSide(
          color: theme.dividerColor,
        ),
      ),
      margin: EdgeInsets.only(bottom: space * 4 / 3),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTapDetails,
        child: Padding(
          padding: EdgeInsets.all(space * 4 / 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Header: Status + time =====
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: space * 2 / 3,
                        vertical: space / 3,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _statusIcon(status),
                            size: 14,
                            color: statusColor,
                          ),
                          SizedBox(width: space / 3),
                          Text(
                            localizedStatus,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (createdAgo.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: theme.hintColor.withValues(alpha: 0.75),
                        ),
                        SizedBox(width: space / 3),
                        Text(
                          '${S.of(context)!.posted}: ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor.withValues(alpha: 0.65),
                            fontSize: 11.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(width: space / 3),
                        Text(
                          createdAgo,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.hintColor.withValues(alpha: 0.85),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              SizedBox(height: space),

              // ===== Title + chevron hint =====
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: space / 2),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.hintColor.withValues(alpha: 0.7),
                    size: 22,
                  ),
                ],
              ),

              SizedBox(height: space * 2 / 3),

              // ===== Description =====
              Text(
                desc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.82,
                  ),
                  height: 1.25,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // ===== Footer actions =====
              if (hasActions) ...[
                SizedBox(height: space),
                Divider(height: space, thickness: 0.8),
                Wrap(
                  spacing: space * 2 / 3,
                  runSpacing: space * 2 / 3,
                  alignment: WrapAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: onTapDetails,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: space * 2 / 3,
                          vertical: space / 2,
                        ),
                        side: BorderSide(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.35),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(space),
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(Icons.info_outline_rounded, size: 16),
                      label: Text(
                        S.of(context)!.view_details,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    if (showOffersButton && onGoToOffers != null)
                      FilledButton.tonalIcon(
                        onPressed: onGoToOffers,
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: space * 2 / 3,
                            vertical: space / 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(space),
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(Icons.receipt_long_rounded, size: 16),
                        label: Text(
                          S.of(context)!.view_offers,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    if (isAccepted)
                      FilledButton.icon(
                        onPressed: onGoToTransaction,
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: space * 2 / 3,
                            vertical: space / 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(space),
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(Icons.handshake_outlined, size: 16),
                        label: Text(
                          S.of(context)!.go_to_transaction,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                  ],
                ),
              ],

              // Extra: “posted:”
              // if (createdAgo.isNotEmpty) ...[
              //   SizedBox(height: space * 2 / 3),
              //   Align(
              //     alignment: Alignment.centerRight,
              //     child: Text(
              //       '${S.of(context)!.posted}: $createdAgo',
              //       style: theme.textTheme.bodySmall?.copyWith(
              //         color: theme.hintColor.withValues(alpha: 0.65),
              //         fontSize: 11.5,
              //         fontStyle: FontStyle.italic,
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
