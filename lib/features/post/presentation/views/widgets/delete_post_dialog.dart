import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';

class DeletePostDialog extends StatefulWidget {
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const DeletePostDialog({
    super.key,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  State<DeletePostDialog> createState() => _DeletePostDialogState();
}

class _DeletePostDialogState extends State<DeletePostDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing.screenPadding),
      ),
      backgroundColor: theme.cardColor,
      child: Padding(
        padding: EdgeInsets.all(spacing.screenPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${S.of(context)!.delete} ${S.of(context)!.post}",
                  style: theme.textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onCancel,
                  splashRadius: 20,
                ),
              ],
            ),
            SizedBox(height: spacing.screenPadding),
            Text(
              S.of(context)!.are_you_sure,
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: spacing.screenPadding * 2),

            // Reason for deletion
            Text(
              S.of(context)!.reason_delete,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: spacing.screenPadding),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(hintText: S.of(context)!.delete_hint),
              maxLines: 3,
            ),
            SizedBox(height: spacing.screenPadding * 2),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomOutlinedButton(
                  text: S.of(context)!.cancel,
                  onPressed: () {
                    widget.onCancel();
                  },
                ),
                SizedBox(width: spacing.screenPadding),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.onDelete();
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: Text(S.of(context)!.delete),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    foregroundColor: theme.scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
