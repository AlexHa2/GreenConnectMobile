import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Top app bar for transaction detail page
class TransactionDetailAppBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  const TransactionDetailAppBar({
    super.key,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing,
        vertical: spacing / 2,
      ),
      child: Row(
        children: [
          _GlassIconButton(
            icon: Icons.arrow_back_ios_new,
            onPressed: onBack,
          ),
          Expanded(
            child: Text(
              s.transaction_details,
              textAlign: TextAlign.center,
              style:  TextStyle(
                color: theme.scaffoldBackgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _GlassIconButton(
            icon: Icons.refresh,
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}

/// Glass morphism style icon button
class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _GlassIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: theme.scaffoldBackgroundColor,
          size: 20,
        ),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
