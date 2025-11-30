import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Dialog for updating feedback rating and comment
class UpdateFeedbackDialog extends StatefulWidget {
  final int currentRating;
  final String currentComment;

  const UpdateFeedbackDialog({
    super.key,
    required this.currentRating,
    required this.currentComment,
  });

  @override
  State<UpdateFeedbackDialog> createState() => _UpdateFeedbackDialogState();

  /// Show the dialog and return the result
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required int currentRating,
    required String currentComment,
  }) {
    return showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) => UpdateFeedbackDialog(
        currentRating: currentRating,
        currentComment: currentComment,
      ),
    );
  }
}

class _UpdateFeedbackDialogState extends State<UpdateFeedbackDialog> {
  late int _selectedRating;
  late TextEditingController _commentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.currentRating;
    _commentController = TextEditingController(text: widget.currentComment);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()?.screenPadding ?? 12.0;
    final s = S.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: spacing * 2,
        vertical: spacing * 3,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(spacing * 1.2),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme, spacing, s),
                SizedBox(height: spacing),
                Divider(height: 1, color: theme.dividerColor),
                SizedBox(height: spacing),
                _buildRatingSection(theme, spacing, s),
                SizedBox(height: spacing * 1.2),
                _buildCommentSection(theme, spacing, s),
                SizedBox(height: spacing * 1.5),
                _buildActionButtons(theme, spacing, s),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, double spacing, S s) {
    return Row(
      children: [
        Icon(Icons.edit, color: theme.primaryColor, size: 24),
        SizedBox(width: spacing * 0.8),
        Expanded(
          child: Text(
            s.edit_your_feedback,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 22),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildRatingSection(ThemeData theme, double spacing, S s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.update_rating,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing * 0.8),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: spacing * 0.8,
            horizontal: spacing,
          ),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(spacing),
            border: Border.all(
              color: theme.primaryColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = starValue;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing * 0.3),
                  child: Icon(
                    starValue <= _selectedRating
                        ? Icons.star
                        : Icons.star_border,
                    color: starValue <= _selectedRating
                        ? AppColors.warning
                        : theme.iconTheme.color?.withValues(alpha: 0.3),
                    size: 32,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentSection(ThemeData theme, double spacing, S s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.update_comment,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing * 0.8),
        TextFormField(
          controller: _commentController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: s.enter_your_comment,
            filled: true,
            fillColor: theme.scaffoldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(spacing),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(spacing),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(spacing),
              borderSide: BorderSide(color: theme.primaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.all(spacing),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return s.enter_your_comment;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme, double spacing, S s) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: spacing * 0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing),
              ),
            ),
            child: Text(s.cancel),
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context, {
                  'rating': _selectedRating,
                  'comment': _commentController.text.trim(),
                });
              }
            },
            icon: const Icon(Icons.save, size: 20),
            label: Text(s.save_changes),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningUpdate,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: spacing * 0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
