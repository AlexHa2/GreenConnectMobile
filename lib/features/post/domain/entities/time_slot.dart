import 'package:flutter/material.dart';

class TimeSlotEntity {
  final String id;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String? description;

  TimeSlotEntity({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.description,
  });
}
