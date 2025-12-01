import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class PostFilterChips extends StatelessWidget {
  final String? selectedStatus;
  final Function(String?) onSelectFilter;
  final String allLabel;
  final bool showAllStatuses;
  final bool showAllChip;

  const PostFilterChips({
    super.key,
    required this.selectedStatus,
    required this.onSelectFilter,
    required this.allLabel,
    this.showAllStatuses = true,
    this.showAllChip = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;

    return SizedBox(
      height: space * 3,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: space),
        children: [
          if (showAllChip) ...[
            ModernFilterChip(
              label: allLabel,
              icon: Icons.list_alt,
              isSelected: selectedStatus == null,
              onTap: () => onSelectFilter(null),
              color: theme.primaryColor,
            ),
            SizedBox(width: space * 0.5),
          ],
          ModernStatusFilterChip(
            status: "Open",
            isSelected: selectedStatus == "Open",
            onTap: () => onSelectFilter("Open"),
          ),
          SizedBox(width: space * 0.5),
          ModernStatusFilterChip(
            status: "Partiallybooked",
            isSelected: selectedStatus == "Partiallybooked",
            onTap: () => onSelectFilter("Partiallybooked"),
          ),
          if (showAllStatuses) ...[
            SizedBox(width: space * 0.5),
            ModernStatusFilterChip(
              status: "Fullybooked",
              isSelected: selectedStatus == "Fullybooked",
              onTap: () => onSelectFilter("Fullybooked"),
            ),
            SizedBox(width: space * 0.5),
            ModernStatusFilterChip(
              status: "Completed",
              isSelected: selectedStatus == "Completed",
              onTap: () => onSelectFilter("Completed"),
            ),
            SizedBox(width: space * 0.5),
            ModernStatusFilterChip(
              status: "Canceled",
              isSelected: selectedStatus == "Canceled",
              onTap: () => onSelectFilter("Canceled"),
            ),
          ],
        ],
      ),
    );
  }
}

class ModernFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const ModernFilterChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final space = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(space.screenPadding/2),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: space.screenPadding,
            vertical: space.screenPadding/2,
          ),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(space.screenPadding/2),
            border: Border.all(
              color: isSelected ? color : color.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? theme.scaffoldBackgroundColor : color,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? theme.scaffoldBackgroundColor : color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModernStatusFilterChip extends StatelessWidget {
  final String status;
  final bool isSelected;
  final VoidCallback onTap;

  const ModernStatusFilterChip({
    super.key,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final postStatus = PostStatus.parseStatus(status);
    final color = PostStatusHelper.getStatusColor(context, postStatus);
    final label = PostStatusHelper.getLocalizedStatus(context, postStatus);

    IconData icon;
    switch (status) {
      case "Open":
        icon = Icons.radio_button_unchecked;
        break;
      case "Partiallybooked":
        icon = Icons.timelapse;
        break;
      case "Fullybooked":
        icon = Icons.event_busy;
        break;
      case "Completed":
        icon = Icons.check_circle_outline;
        break;
      case "Canceled":
        icon = Icons.cancel_outlined;
        break;
      default:
        icon = Icons.circle_outlined;
    }

    return ModernFilterChip(
      label: label,
      icon: icon,
      isSelected: isSelected,
      onTap: onTap,
      color: color,
    );
  }
}
