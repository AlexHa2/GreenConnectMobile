import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

/// Error state widget for reward store
class RewardErrorState extends StatelessWidget {
  final String errorMessage;
  final String errorTitle;
  final String retryButtonText;
  final VoidCallback onRetry;

  const RewardErrorState({
    super.key,
    required this.errorMessage,
    required this.errorTitle,
    required this.retryButtonText,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(space * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(space * 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(
                    alpha: 0.3,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 80,
                  color: theme.colorScheme.error,
                ),
              ),
              SizedBox(height: space * 1.5),
              Text(
                errorTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
              ),
              SizedBox(height: space),
              Container(
                padding: EdgeInsets.all(space * 1.5),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(space),
                  border: Border.all(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
              SizedBox(height: space * 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(retryButtonText),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: space * 1.2,
                      horizontal: space * 2,
                    ),
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(space),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
