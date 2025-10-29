import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatefulWidget {
  final String date;
  final String title;
  final String weight;
  final String value;
  final String status;
  final String points;
  final String description;

  const ActivityCard({
    super.key,
    required this.date,
    required this.title,
    required this.weight,
    required this.value,
    required this.status,
    required this.points,
    required this.description,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool isExpanded = false;

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
      padding: EdgeInsets.all(space / 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(space),
        onTap: () => setState(() => isExpanded = !isExpanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.all(space * 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: theme.primaryColor),
                  SizedBox(width: space),
                  Text(
                    widget.date,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "+${widget.points}",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: space / 3),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.iconTheme.color,
                  ),
                ],
              ),

              SizedBox(height: space),

              Text(
                widget.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: space / 2),
              Row(
                children: [
                  Icon(Icons.eco, color: theme.primaryColor),
                  SizedBox(width: space / 2),
                  Text(
                    widget.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: space),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: [
                    SizedBox(height: space),
                    Divider(color: theme.dividerColor),
                    SizedBox(height: space),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetail(s.weight, widget.weight, theme),
                        _buildDetail(s.value, widget.value, theme),
                      ],
                    ),
                    SizedBox(height: space),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetail(s.status, widget.status, theme),
                        _buildDetail(
                          s.points,
                          "+${widget.points}",
                          theme,
                          highlight: theme.primaryColor,
                        ),
                      ],
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

  Widget _buildDetail(
    String label,
    String value,
    ThemeData theme, {
    Color? highlight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith()),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: highlight ?? theme.textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
}
