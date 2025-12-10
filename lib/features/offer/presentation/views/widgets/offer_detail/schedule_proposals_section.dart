import 'package:GreenConnectMobile/core/enum/offer_status.dart';
import 'package:GreenConnectMobile/core/helper/time_ago_helper.dart';
import 'package:GreenConnectMobile/features/offer/domain/entities/schedule_proposal_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleProposalsSection extends StatelessWidget {
  final List<ScheduleProposalEntity> schedules;
  final ThemeData theme;
  final double spacing;
  final S s;
  final bool isHouseholdView;
  final Function(String scheduleId)? onRejectSchedule;
  final Function(DateTime proposedTime, String responseMessage)? onReschedule;
  final Function(
    String scheduleId,
    DateTime proposedTime,
    String responseMessage,
  )?
  onUpdateSchedule;
  final String? offerStatus;

  const ScheduleProposalsSection({
    super.key,
    required this.schedules,
    required this.theme,
    required this.spacing,
    required this.s,
    this.isHouseholdView = false,
    this.onRejectSchedule,
    this.onReschedule,
    this.onUpdateSchedule,
    this.offerStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(spacing),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(spacing),
            child: Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  color: theme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: spacing / 2),
                Text(
                  s.schedule_proposals,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing * 0.75,
                    vertical: spacing / 3,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(spacing),
                  ),
                  child: Text(
                    '${schedules.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),

          // Add new schedule button for collector
          if (!isHouseholdView &&
              offerStatus == 'Pending' &&
              onReschedule != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showRescheduleDialog(context, null),
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    size: 20,
                    color: theme.primaryColor,
                  ),
                  label: Text(
                    s.scheduleRescheduleButton,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.primaryColor, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing / 2),
                    ),
                    padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
                  ),
                ),
              ),
            ),
            Divider(height: 1, color: theme.dividerColor),
          ],

          // Content
          Padding(
            padding: EdgeInsets.all(spacing),
            child: schedules.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(spacing),
                      child: Text(
                        s.no_schedules,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: schedules.map((schedule) {
                      return Container(
                        margin: EdgeInsets.only(bottom: spacing * 0.75),
                        padding: EdgeInsets.all(spacing * 0.75),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(spacing / 2),
                          border: Border.all(
                            color: _getScheduleStatusColor(schedule.status),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status and date
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: spacing * 0.6,
                                    vertical: spacing / 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getScheduleStatusColor(
                                      schedule.status,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      spacing / 2,
                                    ),
                                  ),
                                  child: Text(
                                    ScheduleProposalStatus.labelS(
                                      context,
                                      schedule.status,
                                    ),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: theme.scaffoldBackgroundColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: theme.textTheme.bodySmall?.color,
                                ),
                                SizedBox(width: spacing / 3),
                                Text(
                                  TimeAgoHelper.format(
                                    context,
                                    schedule.createdAt,
                                  ),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),

                            SizedBox(height: spacing * 0.75),
                            Divider(height: 1, color: theme.dividerColor),
                            SizedBox(height: spacing * 0.75),

                            // Proposed time
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 18,
                                  color: theme.primaryColor,
                                ),
                                SizedBox(width: spacing / 2),
                                Text(
                                  s.proposed_time,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: spacing / 3),
                            Padding(
                              padding: EdgeInsets.only(left: spacing * 1.5),
                              child: Text(
                                DateFormat(
                                  'EEEE, dd MMMM yyyy - HH:mm',
                                  Localizations.localeOf(context).languageCode,
                                ).format(schedule.proposedTime.toLocal()),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            // Response message
                            if (schedule.responseMessage.isNotEmpty) ...[
                              SizedBox(height: spacing * 0.75),
                              Row(
                                children: [
                                  Icon(
                                    Icons.message_outlined,
                                    size: 18,
                                    color: theme.primaryColor,
                                  ),
                                  SizedBox(width: spacing / 2),
                                  Text(
                                    s.response_message,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: spacing / 3),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(spacing * 0.75),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withValues(
                                    alpha: 0.05,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    spacing / 2,
                                  ),
                                  border: Border.all(
                                    color: theme.primaryColor.withValues(
                                      alpha: 0.2,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  schedule.responseMessage,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],

                            // Edit button for collector view when schedule is pending
                            if (!isHouseholdView &&
                                schedule.status ==
                                    ScheduleProposalStatus.pending &&
                                offerStatus == 'Pending' &&
                                onUpdateSchedule != null) ...[
                              SizedBox(height: spacing * 0.75),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () => _showUpdateScheduleDialog(
                                    context,
                                    schedule,
                                  ),
                                  icon: Icon(
                                    Icons.edit_rounded,
                                    size: 18,
                                    color: theme.primaryColor,
                                  ),
                                  label: Text(
                                    s.scheduleEditButton,
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: theme.primaryColor,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        spacing / 2,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: spacing * 0.75,
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            // Swipe to reject indicator for household view
                            if (isHouseholdView &&
                                schedule.status ==
                                    ScheduleProposalStatus.pending) ...[
                              SizedBox(height: spacing * 0.75),
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: theme.primaryColor,
                                  ),
                                  SizedBox(width: spacing / 2),
                                  Expanded(
                                    child: Text(
                                      s.schedule_hint_swipe_to_reject,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.primaryColor,
                                            fontStyle: FontStyle.italic,
                                          ),
                                    ),
                                  ),
                                  // Reject action - tap to reject
                                  if (onRejectSchedule != null)
                                    InkWell(
                                      onTap: () => onRejectSchedule!(schedule.scheduleProposalId),
                                      borderRadius: BorderRadius.circular(
                                        spacing,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: spacing * 0.75,
                                          vertical: spacing * 0.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColorsDark.danger
                                              .withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            spacing,
                                          ),
                                          border: Border.all(
                                            color: AppColorsDark.danger
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.close,
                                              size: 14,
                                              color: AppColorsDark.danger,
                                            ),
                                            SizedBox(width: spacing / 3),
                                            Text(
                                              s.rejected,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: AppColorsDark.danger,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Color _getScheduleStatusColor(ScheduleProposalStatus status) {
    switch (status) {
      case ScheduleProposalStatus.pending:
        return AppColors.warningUpdate;
      case ScheduleProposalStatus.accepted:
        return theme.primaryColor;
      case ScheduleProposalStatus.rejected:
        return AppColorsDark.danger;
    }
  }

  void _showUpdateScheduleDialog(
    BuildContext context,
    ScheduleProposalEntity schedule,
  ) {
    final localTime = schedule.proposedTime.toLocal();
    DateTime selectedDate = localTime;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(localTime);
    final messageController = TextEditingController(
      text: schedule.responseMessage,
    );

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing),
          ),
          title: Text(
            s.scheduleEditButton,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.proposed_time,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: spacing / 2),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: theme.primaryColor,
                                    onPrimary: theme.colorScheme.onPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(width: spacing / 2),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: theme.primaryColor,
                                    onPrimary: theme.colorScheme.onPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedTime = pickedTime;
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time, size: 18),
                        label: Text(
                          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                Text(
                  s.response_message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: spacing / 2),
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: s.response_message,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(spacing / 2),
                    ),
                    filled: true,
                    fillColor: theme.scaffoldBackgroundColor,
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                s.cancel,
                style: TextStyle(color: theme.textTheme.bodySmall?.color),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final proposedDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                Navigator.pop(dialogContext);
                onUpdateSchedule?.call(
                  schedule.scheduleProposalId,
                  proposedDateTime,
                  messageController.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing / 2),
                ),
              ),
              child: Text(s.update),
            ),
          ],
        ),
      ),
    );
  }

  void _showRescheduleDialog(
    BuildContext context,
    ScheduleProposalEntity? schedule,
  ) {
    DateTime selectedDate = schedule != null
        ? schedule.proposedTime.toLocal()
        : DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = schedule != null 
        ? TimeOfDay.fromDateTime(schedule.proposedTime.toLocal())
        : const TimeOfDay(hour: 9, minute: 0);
    final messageController = TextEditingController(
      text: schedule?.responseMessage ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing),
          ),
          title: Text(
            schedule == null
                ? (s.scheduleAddNew)
                : (s.scheduleRescheduleButton),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.proposed_time,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: spacing / 2),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: theme.primaryColor,
                                    onPrimary: theme.colorScheme.onPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(width: spacing / 2),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: theme.primaryColor,
                                    onPrimary: theme.colorScheme.onPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedTime = pickedTime;
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time, size: 18),
                        label: Text(
                          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                Text(
                  s.response_message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: spacing / 2),
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: s.response_message,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(spacing / 2),
                    ),
                    filled: true,
                    fillColor: theme.scaffoldBackgroundColor,
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                s.cancel,
                style: TextStyle(color: theme.textTheme.bodySmall?.color),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final proposedDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                Navigator.pop(dialogContext);
                onReschedule?.call(
                  proposedDateTime,
                  messageController.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing / 2),
                ),
              ),
              child: Text(s.scheduleRescheduleButton),
            ),
          ],
        ),
      ),
    );
  }
}
