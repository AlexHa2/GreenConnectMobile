import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmScheduleView extends StatelessWidget {
  final DateTime proposedDate;
  final TimeOfDay proposedTime;
  final VoidCallback onConfirm;

  const ConfirmScheduleView({
    super.key,
    required this.proposedDate,
    required this.proposedTime,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    // Format date and time
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy');
    final formattedDate = dateFormat.format(proposedDate);
    final formattedTime = proposedTime.format(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Confirm Collection\nDate & Time',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.3,
              fontSize: 28,
            ),
          ),

          SizedBox(height: spacing.screenPadding * 4),

        // Date & Time Card
        Center(
          child: Container(
            padding: EdgeInsets.all(spacing.screenPadding * 3),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(spacing.screenPadding * 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Calendar Icon
                Container(
                  padding: EdgeInsets.all(spacing.screenPadding * 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event_available,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),

                SizedBox(height: spacing.screenPadding * 2.5),

                // Date
                Text(
                  formattedDate,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                SizedBox(height: spacing.screenPadding),

                // Time
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'at',
                      style: textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    SizedBox(width: spacing.screenPadding / 2),
                    Text(
                      formattedTime,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

          const Spacer(),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: spacing.screenPadding * 1.8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    spacing.screenPadding * 1.5,
                  ),
                ),
                elevation: 0,
              ),
              child: Text(
                'Confirm Schedule',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          SizedBox(height: spacing.screenPadding * 3),
        ],
      ),
    );
  }
}

