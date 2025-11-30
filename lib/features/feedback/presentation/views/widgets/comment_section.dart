import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Comment input section with validation
class CommentSection extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final int maxLines;

  const CommentSection({
    super.key,
    required this.controller,
    this.maxLength = 500,
    this.maxLines = 6,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Container(
      padding: EdgeInsets.all(spacing * 1.5),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing * 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, spacing, s),
          SizedBox(height: spacing * 1.2),
          _buildTextField(theme, spacing, s),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, double spacing, S s) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(spacing * 0.8),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(spacing),
          ),
          child: Icon(
            Icons.edit_note_rounded,
            color: theme.primaryColor,
            size: spacing * 2,
          ),
        ),
        SizedBox(width: spacing),
        Text(
          s.write_comment,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(ThemeData theme, double spacing, S s) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: s.comment_placeholder,
        hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
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
        contentPadding: EdgeInsets.all(spacing * 1.2),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return s.comment_required;
        }
        return null;
      },
    );
  }
}
