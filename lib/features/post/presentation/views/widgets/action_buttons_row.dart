import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onView;
  final String? editLabel;
  final String? deleteLabel;
  final String? viewLabel;

  const ActionButtonsRow({
    super.key,
    this.onEdit,
    this.onDelete,
    this.onView,
    this.editLabel,
    this.deleteLabel,
    this.viewLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (onView != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onView,
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: Text(viewLabel ?? 'View'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        if (onView != null && (onEdit != null || onDelete != null))
          const SizedBox(width: 8),
        if (onEdit != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(editLabel ?? 'Edit'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        if (onEdit != null && onDelete != null) const SizedBox(width: 8),
        if (onDelete != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: Text(deleteLabel ?? 'Delete'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
      ],
    );
  }
}
