import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class CheckInDialog extends StatelessWidget {
  final String transactionId;
  final VoidCallback onSuccess;

  const CheckInDialog({
    super.key,
    required this.transactionId,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;
    final space = spacing.screenPadding;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.location_on, color: theme.primaryColor),
          SizedBox(width: space),
          Expanded(child: Text(s.check_in_confirm)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: space * 6,
            color: Colors.green,
          ),
          SizedBox(height: space * 1.5),
          Text(
            s.check_in_message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.cancel),
        ),
        ElevatedButton(
          onPressed: () async {
            // TODO: Call API to check in
            await Future.delayed(const Duration(milliseconds: 500));
            onSuccess();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text(s.check_in),
        ),
      ],
    );
  }
}
