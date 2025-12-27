import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class CreatePostHeader extends StatelessWidget {
  const CreatePostHeader({
    super.key,
    required this.currentStep,
    required this.stepCount,
    required this.onStepTap,
  });

  final int currentStep;
  final int stepCount;
  final ValueChanged<int> onStepTap;

  List<_StepMeta> _stepsMeta(BuildContext context) {
    final s = S.of(context)!;
    return [
      _StepMeta(
        title: '${s.post} ${s.information}',
        subtitle: s.information,
        icon: Icons.edit_note,
      ),
      _StepMeta(
        title: s.time_slot_add,
        subtitle: s.time_slot_required,
        icon: Icons.calendar_month,
      ),
      _StepMeta(
        title: s.scrap_item,
        subtitle: s.add_scrap_items,
        icon: Icons.category,
      ),
      _StepMeta(
        title: "${s.post} ${s.information}",
        subtitle: s.information,
        icon: Icons.fact_check,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final steps = _stepsMeta(context);
    final progress = (currentStep + 1) / stepCount;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.screenPadding,
        spacing.screenPadding,
        spacing.screenPadding,
        spacing.screenPadding * 0.67,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Icon(steps[currentStep].icon, size: 20),
              SizedBox(width: spacing.screenPadding * 0.67),
              Expanded(
                child: Text(
                  steps[currentStep].title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${currentStep + 1}/$stepCount',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.screenPadding * 0.83),

          // Progress
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: progress.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              builder: (context, animatedValue, child) {
                return LinearProgressIndicator(
                  value: animatedValue,
                  minHeight: 6,
                  backgroundColor: theme.canvasColor,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                );
              },
            ),
          ),
          SizedBox(height: spacing.screenPadding * 0.83),

          // Step pills
          // Step pills (full width + connecting line)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(stepCount * 2 - 1, (i) {
              // STEP
              if (i.isEven) {
                final index = i ~/ 2;
                final isActive = index == currentStep;
                final isCompleted = index < currentStep;
                final canTap = index <= currentStep;

                return InkWell(
                  onTap: canTap ? () => onStepTap(index) : null,
                  borderRadius: BorderRadius.circular(999),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.screenPadding * 0.75,
                      vertical: spacing.screenPadding * 0.5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isActive || isCompleted
                            ? theme.colorScheme.primary
                            : theme.dividerColor,
                      ),
                      color: isActive
                          ? theme.primaryColor.withValues(alpha: 0.10)
                          : isCompleted
                              ? theme.primaryColor.withValues(alpha: 0.05)
                              : theme.colorScheme.surface,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCompleted ? Icons.check : steps[index].icon,
                          size: 16,
                          color: canTap
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.38),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${index + 1}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: canTap
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.38),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // LINE
              final lineIndex = (i - 1) ~/ 2;
              final isCompleted = lineIndex < currentStep;

              return Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: isCompleted
                        ? LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withValues(alpha: 0.5),
                            ],
                          )
                        : null,
                    color: isCompleted
                        ? null
                        : theme.dividerColor.withValues(alpha: 0.4),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StepMeta {
  final String title;
  final String subtitle;
  final IconData icon;

  const _StepMeta({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
