import 'package:GreenConnectMobile/features/post/domain/entities/time_slot.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class TimeSlotList extends StatelessWidget {
  const TimeSlotList({
    super.key,
    required this.timeSlots,
    required this.onAdd,
    required this.onDelete,
    this.isSubmitting = false,
  });

  final List<TimeSlotEntity> timeSlots;
  final VoidCallback onAdd;
  final ValueChanged<int> onDelete;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.time_slot_add,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: spacing.screenPadding / 4),
                  Text(
                    s.time_slot_required,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: isSubmitting ? null : onAdd,
              icon: const Icon(Icons.add, size: 20),
              label: Text(s.add),
            ),
          ],
        ),
        SizedBox(height: spacing.screenPadding),
        if (timeSlots.isEmpty)
          Container(
            padding: EdgeInsets.all(spacing.screenPadding * 1.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(spacing.screenPadding),
              border: Border.all(
                color: theme.dividerColor,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: spacing.screenPadding / 2),
                Expanded(
                  child: Text(
                    s.no_data,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: timeSlots.asMap().entries.map((entry) {
              final idx = entry.key;
              final slot = entry.value;
              return Container(
                margin: EdgeInsets.only(
                  bottom: idx == timeSlots.length - 1
                      ? 0
                      : spacing.screenPadding / 2,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(spacing.screenPadding),
                  border: Border.all(
                    color: theme.dividerColor,
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: spacing.screenPadding,
                    vertical: spacing.screenPadding / 2,
                  ),
                  leading: Container(
                    padding: EdgeInsets.all(spacing.screenPadding / 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius:
                          BorderRadius.circular(spacing.screenPadding / 2),
                    ),
                    child: Icon(
                      Icons.schedule,
                      size: 20,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    '${slot.date.day}/${slot.date.month}/${slot.date.year}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${slot.startTime.format(context)} - ${slot.endTime.format(context)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                    ),
                    onPressed: isSubmitting ? null : () => onDelete(idx),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

