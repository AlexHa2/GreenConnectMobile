import 'package:GreenConnectMobile/features/post/domain/entities/scrap_post_entity.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSlotSection extends StatelessWidget {
  final ScrapPostTimeSlotEntity? timeSlot;
  final ThemeData theme;
  final double spacing;
  final S s;

  const TimeSlotSection({
    super.key,
    required this.timeSlot,
    required this.theme,
    required this.spacing,
    required this.s,
  });

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy', 'vi').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String timeString) {
    try {
      // Format from "00:17:00" to "00:17"
      if (timeString.length >= 5) {
        return timeString.substring(0, 5);
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (timeSlot == null) {
      return const SizedBox.shrink();
    }

    final formattedDate = _formatDate(timeSlot!.specificDate);
    final formattedStartTime = _formatTime(timeSlot!.startTime);
    final formattedEndTime = _formatTime(timeSlot!.endTime);
    final isBooked = timeSlot!.isBooked == true;

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
                  Icons.access_time,
                  color: theme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: spacing / 2),
                Text(
                  s.selected_time_slot,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),

          // Content
          Padding(
            padding: EdgeInsets.all(spacing),
            child: Container(
              padding: EdgeInsets.all(spacing * 0.75),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(spacing / 2),
                border: Border.all(color: theme.dividerColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: theme.primaryColor,
                      ),
                      SizedBox(width: spacing / 2),
                      Text(
                        s.time_slot_date,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing / 2),
                  Padding(
                    padding: EdgeInsets.only(left: spacing * 1.5),
                    child: Text(
                      formattedDate,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing * 0.75),

                  // Time range
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 16,
                        color: theme.primaryColor,
                      ),
                      SizedBox(width: spacing / 2),
                      Text(
                        s.time_slot_start_time,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing / 2),
                  Padding(
                    padding: EdgeInsets.only(left: spacing * 1.5),
                    child: Row(
                      children: [
                        Text(
                          '$formattedStartTime - $formattedEndTime',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isBooked) ...[
                          SizedBox(width: spacing / 2),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing / 2,
                              vertical: spacing / 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(spacing / 2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: theme.primaryColor,
                                  size: 14,
                                ),
                                SizedBox(width: spacing / 4),
                                Text(
                                  s.booked,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
