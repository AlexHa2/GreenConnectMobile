import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class CardInforProfileSetting extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onPressed;
  final Widget? iconPress;

  const CardInforProfileSetting({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onPressed,
    this.iconPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final baseSpacing = spacing.screenPadding;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: baseSpacing / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.primaryColor),

          SizedBox(width: baseSpacing),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodyMedium),
                SizedBox(height: baseSpacing / 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          if (onPressed != null)
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: onPressed,
              child: Padding(
                padding: EdgeInsets.all(baseSpacing / 2),
                child:
                    iconPress ??
                    Icon(Icons.edit, size: 20, color: theme.primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
