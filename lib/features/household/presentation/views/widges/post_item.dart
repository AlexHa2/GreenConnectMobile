import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostItem extends StatefulWidget {
  final String title;
  final String desc;
  final String time;
  final String status;
  final Color color;

  const PostItem({
    super.key,
    required this.title,
    required this.desc,
    required this.time,
    required this.status,
    required this.color,
  });

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = false;
  }

  bool get _isAccepted => widget.status == "Accepted";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Card(
      elevation: _isExpanded ? 5 : 2,
      margin: EdgeInsets.only(bottom: spacing.screenPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing.screenPadding),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(spacing.screenPadding * 2),
        // onTap: _isAccepted
        //     ? () => setState(() => _isExpanded = !_isExpanded)
        //     : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.screenPadding * 2,
            vertical: spacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: textTheme.titleLarge?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.desc,
                          style: textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: theme.dividerColor,
                            ),
                            const SizedBox(width: 4),
                            Text(widget.time, style: textTheme.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right status chip
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.screenPadding,
                      vertical: spacing.screenPadding / 2,
                    ),
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(
                        spacing.screenPadding * 3,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.status == "Accepted"
                              ? Icons.check_circle
                              : widget.status == "Pending"
                              ? Icons.hourglass_empty
                              : Icons.cancel,
                          size: 14,
                          color: theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.status,
                          style: textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (_isAccepted)
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          "Transaction ID: #TRX482913",
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Location: 123 Green Street, EcoCity",
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              context.push('/confirm-transaction');
                            },
                            icon: const Icon(
                              Icons.receipt_long_outlined,
                              size: 18,
                            ),
                            label: Text(S.of(context)!.transaction_detail),
                            style: OutlinedButton.styleFrom(
                              textStyle: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (_isAccepted)
                Center(
                  child: IconButton(
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                    icon: AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: _isExpanded ? 0.5 : 0,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: theme.iconTheme.color,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
