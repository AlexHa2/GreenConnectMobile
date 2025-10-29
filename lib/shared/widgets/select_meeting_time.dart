import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:table_calendar/table_calendar.dart';

Future<void> showSelectMeetingDialog({
  required String title,
  required BuildContext context,
  required DateTime initialDate,
  required ValueChanged<DateTime> onDateSelected,
  required VoidCallback onAccept,
  required VoidCallback onDecline,
}) async {
  DateTime selectedDay = initialDate;

  final theme = Theme.of(context);
  final spacing = theme.extension<AppSpacing>()!;
  final space = spacing.screenPadding;
  final s = S.of(context)!;
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(space * 2),
        ),
        insetPadding: EdgeInsets.all(space * 1.5),
        backgroundColor: theme.cardColor,
        child: Padding(
          padding: EdgeInsets.all(space * 2),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: space * 3),
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.close, size: 24),
                      ),
                    ],
                  ),
                  SizedBox(height: space),

                  // Calendar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(space),
                      color: theme.scaffoldBackgroundColor,
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: TableCalendar(
                      locale: Localizations.localeOf(context).languageCode,
                      focusedDay: selectedDay,
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      currentDay: DateTime.now(),
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: TextStyle(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      selectedDayPredicate: (day) =>
                          isSameDay(day, selectedDay),
                      onDaySelected: (selected, focused) {
                        setState(() {
                          selectedDay = selected;
                        });
                        onDateSelected(selected);
                      },
                      headerStyle: HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                        titleTextStyle: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: theme.primaryColor,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: space * 2),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onDecline,
                          child: Text(s.decline),
                        ),
                      ),
                      SizedBox(width: space),
                      Expanded(
                        child: GradientButton(
                          onPressed: onAccept,
                          text: s.accept,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
