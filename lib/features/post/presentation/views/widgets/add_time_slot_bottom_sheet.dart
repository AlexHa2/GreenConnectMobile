import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
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

  /// Check if a time is in the past for the selected date
  bool _isTimeInPast(TimeOfDay time, [DateTime? date]) {
    final selectedDate = date ?? pickedDate;
    if (selectedDate == null) return false;
    
    final now = DateTime.now();
    
    // If selected date is today, check if time is in the past
    if (selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day) {
      final currentTime = TimeOfDay.fromDateTime(now);
      return time.hour < currentTime.hour ||
          (time.hour == currentTime.hour && time.minute < currentTime.minute);
    }
    
    return false;
  }

  /// Get the minimum allowed time for the selected date
  TimeOfDay _getMinimumTime() {
    if (pickedDate == null) return TimeOfDay.now();
    
    final now = DateTime.now();
    final selectedDate = pickedDate!;
    
    // If selected date is today, return current time
    if (selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day) {
      return TimeOfDay.fromDateTime(now);
    }
    
    // For future dates, allow any time
    return const TimeOfDay(hour: 0, minute: 0);
  }

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
                          // If date changed to today and current times are in the past, clear them
                          final now = DateTime.now();
                          if (d.year == now.year &&
                              d.month == now.month &&
                              d.day == now.day) {
                            // Date is today, check if times are in the past
                            if (startTime != null && _isTimeInPast(startTime!, d)) {
                              startTime = null;
                            }
                            if (endTime != null && _isTimeInPast(endTime!, d)) {
                              endTime = null;
                            }
                          }
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
                      final minimumTime = _getMinimumTime();
                      final initialTime = startTime ?? minimumTime;
                      
                      final t = await showTimePicker(
                        context: context,
                        initialTime: initialTime,
                      );
                      if (t != null) {
                        // Validate: don't allow past time if date is today
                        if (_isTimeInPast(t)) {
                          if (mounted && context.mounted) {
                            CustomToast.show(
                              context,
                              s.error_time_in_past,
                              
                              type: ToastType.error,
                            );
                          }
                          return;
                        }
                        
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
                            final minimumTime = _getMinimumTime();
                            // Suggested time should be at least startTime or minimumTime, whichever is later
                            final suggestedHour = startTime!.hour < minimumTime.hour
                                ? minimumTime.hour
                                : (startTime!.hour + 1) % 24;
                            final suggested = TimeOfDay(
                              hour: suggestedHour,
                              minute: startTime!.hour < minimumTime.hour
                                  ? minimumTime.minute
                                  : startTime!.minute,
                            );
                            
                            final t = await showTimePicker(
                              context: context,
                              initialTime: endTime ?? suggested,
                            );
                            if (t != null) {
                              // Validate: don't allow past time if date is today
                              if (_isTimeInPast(t)) {
                                if (mounted) {
                                  CustomToast.show(
                                    context,
                                    'Không thể chọn giờ trong quá khứ',
                                    type: ToastType.error,
                                  );
                                }
                                return;
                              }
                              
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
