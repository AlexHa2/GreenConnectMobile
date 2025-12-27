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
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.danger.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
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
          icon: Icon(Icons.report_problem, size: 20),
          label: Text(
            s.complain,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.danger,
            side: const BorderSide(color: AppColors.danger, width: 2),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: AppColors.danger.withValues(alpha: 0.05),
          ),
        ),
      );
    }

    // Household: show both review and complaint buttons
    return Row(
      children: [
        // Complain button - danger color, left side
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.danger.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
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
              icon: Icon(Icons.report_problem, size: 20),
              label: Text(
                s.complain,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: const BorderSide(color: AppColors.danger, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColors.danger.withValues(alpha: 0.05),
              ),
            ),
          ),
        ),
        SizedBox(width: spacing),
        // Review button - primary color, right side
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  AppColors.warning,
                  AppColors.warning.withValues(alpha: 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.warning.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
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
              icon: const Icon(Icons.star_rounded, size: 20),
              label: Text(
                s.write_review,
                style: TextStyle(
                  color: theme.scaffoldBackgroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
