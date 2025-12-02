import 'package:GreenConnectMobile/core/helper/date_time_extension.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class DateTimePickerField extends StatelessWidget {
  final DateTime? selectedDateTime;
  final VoidCallback onTap;

  const DateTimePickerField({
    super.key,
    required this.selectedDateTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(space),
      child: Container(
        padding: EdgeInsets.all(space),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(space),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: theme.primaryColor,
              size: 20,
            ),
            SizedBox(width: space),
            Expanded(
              child: Text(
                selectedDateTime != null
                    ? selectedDateTime!.toCustomFormat(locale: s.localeName)
                    : s.select_date_and_time,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: selectedDateTime != null
                      ? theme.textTheme.bodyMedium?.color
                      : theme.hintColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: theme.hintColor,
            ),
          ],
        ),
      ),
    );
  }
}
