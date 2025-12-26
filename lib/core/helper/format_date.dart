import 'package:flutter/material.dart';

String formatDateOnly(DateTime dob) {
  return "${dob.year.toString().padLeft(4, '0')}-"
      "${dob.month.toString().padLeft(2, '0')}-"
      "${dob.day.toString().padLeft(2, '0')}";
}

String formatTimeOfDay(TimeOfDay time) {
  return "${time.hour.toString().padLeft(2, '0')}:"
      "${time.minute.toString().padLeft(2, '0')}";
}