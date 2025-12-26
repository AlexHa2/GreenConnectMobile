import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompletedTransactionActions extends StatelessWidget {
  final String transactionId;
  final VoidCallback onActionCompleted;
  final Role userRole;

  const CompletedTransactionActions({
    super.key,
    required this.transactionId,
    required this.onActionCompleted,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;
    final theme = Theme.of(context);
    final isHousehold = userRole == Role.household;

    // If not household, only show complaint button
    if (!isHousehold) {
      return OutlinedButton.icon(
        onPressed: () async {
          final result = await context.pushNamed<bool>(
            'create-complaint',
            extra: {'transactionId': transactionId},
          );
          if (result == true) {
            onActionCompleted();
          }
        },
        icon: Icon(Icons.report_problem, size: spacing * 1.5),
        label: Text(s.complain),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.danger,
          side: const BorderSide(color: AppColors.danger, width: 1.5),
          padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing),
          ),
        ),
      );
    }

    // Household: show both review and complaint buttons
    return Row(
      children: [
        // Review button
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await context.pushNamed<bool>(
                'create-feedback',
                extra: {'transactionId': transactionId},
              );
              if (result == true) {
                onActionCompleted();
              }
            },
            icon: Icon(Icons.star, size: spacing * 1.5),
            label: Text(s.write_review),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: theme.scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing),
              ),
            ),
          ),
        ),
        SizedBox(width: spacing * 0.75),
        // Complain button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              final result = await context.pushNamed<bool>(
                'create-complaint',
                extra: {'transactionId': transactionId},
              );
              if (result == true) {
                onActionCompleted();
              }
            },
            icon: Icon(Icons.report_problem, size: spacing * 1.5),
            label: Text(s.complain),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger, width: 1.5),
              padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
