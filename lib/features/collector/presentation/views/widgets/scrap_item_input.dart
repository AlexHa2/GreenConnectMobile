import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class ScrapItemInput extends StatelessWidget {
  final String itemName;
  final String initialValue;
  final bool editable;
  final TextEditingController? controller;

  const ScrapItemInput({
    super.key,
    required this.itemName,
    required this.initialValue,
    this.editable = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.screenPadding / 3),
      child: Row(
        children: [
          // Checkbox
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: initialValue.isNotEmpty
                  ? AppColors.primary
                  : Colors.transparent,
              border: Border.all(
                color: initialValue.isNotEmpty
                    ? AppColors.primary
                    : theme.dividerColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: initialValue.isNotEmpty
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  )
                : null,
          ),

          SizedBox(width: spacing.screenPadding * 1.2),

          // Item name
          Expanded(
            flex: 3,
            child: Text(
              itemName,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 14,
              ),
            ),
          ),

          SizedBox(width: spacing.screenPadding),

          // Value/Input
          Expanded(
            flex: 2,
            child: editable
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.screenPadding,
                      vertical: spacing.screenPadding * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      border: Border.all(
                        color: theme.dividerColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(
                        spacing.screenPadding / 2,
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Nhập số tiền',
                        hintStyle: textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                          fontSize: 12,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                    ),
                  )
                : Text(
                    initialValue,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                  ),
          ),
        ],
      ),
    );
  }
}

