import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class CardProfileSetting extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;
  final VoidCallback? onEdit;
  const CardProfileSetting({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final baseSpacing = spacing.screenPadding;
    final s = S.of(context)!;
    return Container(
      padding: EdgeInsets.all(baseSpacing * 2),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(baseSpacing),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColorDark.withValues(alpha: 0.1),
            blurRadius: baseSpacing / 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: theme.primaryColor),
              SizedBox(width: baseSpacing / 1.5),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (onEdit != null)
                TextButton.icon(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit, size: 18, color: theme.primaryColor),
                  label: Text(
                    s.update,
                    style: TextStyle(color: theme.primaryColor),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: baseSpacing / 1.5,
                      vertical: baseSpacing / 3,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          SizedBox(height: baseSpacing),
          const Divider(height: 1, thickness: 1),
          SizedBox(height: baseSpacing),
          ...children,
        ],
      ),
    );
  }
}
