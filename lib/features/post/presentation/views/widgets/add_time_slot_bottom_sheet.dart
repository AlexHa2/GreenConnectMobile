import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';

class AddTimeSlotBottomSheet extends StatefulWidget {
  const AddTimeSlotBottomSheet({
    super.key,
    required this.onAdd,
    required this.isInvalidTimeRange,
    this.maxDaysAhead = 30,
  });

  final void Function(DateTime date, TimeOfDay startTime, TimeOfDay endTime)
      onAdd;
  final bool Function(TimeOfDay start, TimeOfDay end) isInvalidTimeRange;
  final int maxDaysAhead;

  @override
  State<AddTimeSlotBottomSheet> createState() => _AddTimeSlotBottomSheetState();
}

class _AddTimeSlotBottomSheetState extends State<AddTimeSlotBottomSheet> {
  DateTime? pickedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;

    String dateText = pickedDate == null
        ? s.no_data
        : '${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}';

    String startText =
        startTime == null ? s.no_data : startTime!.format(context);

    String endText = endTime == null ? s.no_data : endTime!.format(context);

    final canSave = pickedDate != null && startTime != null && endTime != null;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: spacing.screenPadding,
          right: spacing.screenPadding,
          top: spacing.screenPadding * 0.67,
          bottom:
              MediaQuery.of(context).viewInsets.bottom + spacing.screenPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.time_slot_add,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: spacing.screenPadding / 3),
            Text(
              s.time_slot_required,
              style: theme.textTheme.bodySmall,
            ),
            SizedBox(height: spacing.screenPadding),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: Text(s.date),
                    subtitle: Text(dateText),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now()
                            .add(Duration(days: widget.maxDaysAhead)),
                      );
                      if (d != null) {
                        setState(() {
                          pickedDate = d;
                        });
                      }
                    },
                  ),
                  Divider(height: 1, color: theme.dividerColor),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(s.time_slot_start_time),
                    subtitle: Text(startText),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (t != null) {
                        setState(() {
                          startTime = t;
                          // If endTime exists but becomes invalid, clear it
                          if (endTime != null &&
                              widget.isInvalidTimeRange(t, endTime!)) {
                            endTime = null;
                          }
                        });
                      }
                    },
                  ),
                  Divider(height: 1, color: theme.dividerColor),
                  ListTile(
                    leading: const Icon(Icons.access_time_filled),
                    title: Text(s.time_slot_end_time),
                    subtitle: Text(endText),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: startTime == null
                        ? null
                        : () async {
                            final suggested = startTime!
                                .replacing(hour: (startTime!.hour + 1) % 24);
                            final t = await showTimePicker(
                              context: context,
                              initialTime: suggested,
                            );
                            if (t != null) {
                              setState(() {
                                endTime = t;
                              });
                            }
                          },
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.screenPadding),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(s.cancel),
                  ),
                ),
                SizedBox(width: spacing.screenPadding),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: spacing.screenPadding * 1.15,
                      ),
                      backgroundColor: theme.primaryColor,
                      foregroundColor: theme.scaffoldBackgroundColor,
                    ),
                    onPressed: !canSave
                        ? null
                        : () {
                            widget.onAdd(pickedDate!, startTime!, endTime!);
                            Navigator.pop(context);
                          },
                    child: Text(s.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
