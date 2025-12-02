import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class OfferSubmitButton extends StatelessWidget {
  final bool isProcessing;
  final VoidCallback onSubmit;

  const OfferSubmitButton({
    super.key,
    required this.isProcessing,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Container(
      padding: EdgeInsets.all(space),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: isProcessing ? null : onSubmit,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: space),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(space),
              ),
            ),
            icon: isProcessing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.scaffoldBackgroundColor,
                    ),
                  )
                : const Icon(Icons.send_rounded),
            label: Text(
              isProcessing ? s.creating : s.submit_offer,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
