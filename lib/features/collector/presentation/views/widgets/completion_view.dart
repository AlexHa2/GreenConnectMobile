import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class CompletionView extends StatelessWidget {
  final VoidCallback onBackToBooking;

  const CompletionView({
    super.key,
    required this.onBackToBooking,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Leaf Icon in Circle
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.energy_savings_leaf,
              color: Colors.white,
              size: 60,
            ),
          ),

          SizedBox(height: spacing.screenPadding * 3),

          // ALL SET! Title
          Text(
            'ALL SET!',
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),

          SizedBox(height: spacing.screenPadding * 2),

          // Message
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.screenPadding * 3),
            child: Text(
              'Thank you for contributing to a greener planet. We\'ll send you a reminder before your collection.',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyMedium?.color,
                height: 1.5,
                fontSize: 15,
              ),
            ),
          ),

          const Spacer(),

          // Back to Booking Button
          InkWell(
            onTap: onBackToBooking,
            child: Padding(
              padding: EdgeInsets.all(spacing.screenPadding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: spacing.screenPadding / 2),
                  Text(
                    'BACK TO BOOKING',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: spacing.screenPadding * 4),
        ],
      ),
    );
  }
}

