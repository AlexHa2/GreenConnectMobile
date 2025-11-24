import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class TakeAllSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChange;

  const TakeAllSwitch({super.key, required this.value, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.screenPadding),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.screenPadding * 1.5,
          vertical: spacing.screenPadding,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.all_inclusive,
                  color: value ? theme.primaryColor : theme.disabledColor,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context)!.take_all,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      S.of(context)!.take_all_description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall!.color!.withValues(
                          alpha: 0.7,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Switch(
              value: value,
              activeThumbColor: theme.primaryColor,
              onChanged: onChange,
            ),
          ],
        ),
      ),
    );
  }
}
