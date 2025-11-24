import 'package:GreenConnectMobile/core/enum/post_status.dart';
import 'package:GreenConnectMobile/core/helper/post_status_helper.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class StatusFilterButton extends StatelessWidget {
  final String status;
  final bool isSelected;
  final VoidCallback onTap;

  const StatusFilterButton({
    super.key,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = Theme.of(context).extension<AppSpacing>()!;
    final color = PostStatusHelper.getStatusColor(
      context,
      status as PostStatus,
    );
    final label = PostStatusHelper.getLocalizedStatus(
      context,
      status as PostStatus,
    );

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? color.withValues(alpha: 0.1)
            : Colors.transparent,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(space.screenPadding),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: isSelected ? color : theme.textTheme.bodyMedium!.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
