import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ComplaintReasonInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isRequired;
  final bool enabled;
  final String? helperText;

  const ComplaintReasonInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isRequired = false,
    this.enabled = true,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Container(
      padding: EdgeInsets.all(space * 1.5),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(space * 1.5),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: theme.primaryColor,
                size: 20,
              ),
              SizedBox(width: space * 0.5),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          SizedBox(height: space),
          TextField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: theme.hintColor.withValues(alpha: 0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(space),
                borderSide: BorderSide(
                  color: theme.dividerColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(space),
                borderSide: BorderSide(
                  color: theme.dividerColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(space),
                borderSide: BorderSide(
                  color: theme.primaryColor,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(space),
                borderSide: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
              ),
              filled: true,
              fillColor: enabled
                  ? theme.scaffoldBackgroundColor
                  : theme.disabledColor.withValues(alpha: 0.1),
              contentPadding: EdgeInsets.all(space),
            ),
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.bodyMedium,
          ),
          if (helperText != null) ...[
            SizedBox(height: space * 0.5),
            Text(
              helperText!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
