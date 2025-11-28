import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/core/helper/time_ago_helper.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final String title;
  final String desc;
  final String time;
  final String rawStatus;
  final String timeCreated;
  final String localizedStatus;
  final VoidCallback onTapDetails;
  final VoidCallback? onGoToTransaction;

  const PostItem({
    super.key,
    required this.title,
    required this.desc,
    required this.time,
    required this.rawStatus,
    required this.localizedStatus,
    required this.onTapDetails,
    this.onGoToTransaction,
    required this.timeCreated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAccepted = PostStatusHelper.showTransactionAction(rawStatus);
    final statusColor = PostStatusHelper.getStatusColor(context, PostStatus.parseStatus(rawStatus));
    final createdAgo = TimeAgoHelper.format(
      context,
      DateTime.parse(timeCreated),
    );
    final spacing = theme.extension<AppSpacing>();
    final space = spacing?.screenPadding ?? 12;

    return Card(
      elevation: space / 6, // ~2
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(space)),
      margin: EdgeInsets.only(bottom: space * 4 / 3), // 16
      child: InkWell(
        borderRadius: BorderRadius.circular(space),
        onTap: onTapDetails,
        child: Padding(
          padding: EdgeInsets.all(space * 4 / 3), // 16
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: space * 2 / 3, // 8
                      vertical: space / 3, // 4
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(space * 2 / 3), // 8
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      localizedStatus,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 14, color: theme.hintColor),
                  SizedBox(width: space / 3), // 4
                  Flexible(
                    child: Text(
                      time,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: space), // 12

              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: space * 2 / 3), // 8

              Text(
                desc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.8,
                  ),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: space),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.history,
                    size: 14,
                    color: theme.hintColor.withValues(alpha: 0.6),
                  ),
                  SizedBox(width: space / 3), // 4
                  Text(
                    '${S.of(context)!.posted}: $createdAgo',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),

              SizedBox(height: space * 4 / 3),
              Divider(height: space / 12),
              SizedBox(height: space),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onTapDetails,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: space * 2 / 3,
                        ),
                        side: BorderSide(
                          color: theme.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        S.of(context)!.view_details,
                        style: const TextStyle(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  if (isAccepted) ...[
                    SizedBox(width: space),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onGoToTransaction,
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: space * 2 / 3, // 8
                          ),
                          backgroundColor: theme.primaryColor,
                        ),
                        icon: const Icon(Icons.handshake_outlined, size: 16),
                        label: Text(
                          S.of(context)!.go_to_transaction,
                          style: const TextStyle(fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
}
