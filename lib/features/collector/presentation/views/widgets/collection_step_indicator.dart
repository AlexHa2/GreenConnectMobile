import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class CollectionStepIndicator extends StatelessWidget {
  final int currentStep;
  final List<Map<String, dynamic>> steps;

  const CollectionStepIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isEven) {
          // Step circle
          final stepIndex = index ~/ 2;
          final step = steps[stepIndex];
          final stepNumber = step['number'] as int;
          final isActive = stepNumber <= currentStep;
          final isCurrent = stepNumber == currentStep;

          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : const Color(0xFFE8E8E8),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      stepNumber.toString(),
                      style: textTheme.titleMedium?.copyWith(
                        color: isActive
                            ? Colors.white
                            : const Color(0xFF9E9E9E),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing.screenPadding * 0.6),
                Text(
                  step['label'],
                  style: textTheme.bodySmall?.copyWith(
                    color: isCurrent
                        ? theme.primaryColorDark
                        : const Color(0xFF9E9E9E),
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        } else {
          // Connector line
          final stepIndex = index ~/ 2;
          final isCompleted = steps[stepIndex]['number'] < currentStep;

          return Expanded(
            child: Container(
              height: 2,
              margin: EdgeInsets.only(
                bottom: spacing.screenPadding * 2.2,
              ),
              color: isCompleted
                  ? AppColors.primary
                  : const Color(0xFFE8E8E8),
            ),
          );
        }
      }),
    );
  }
}

