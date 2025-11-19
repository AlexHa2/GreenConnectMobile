import 'package:flutter/material.dart';

/// ===========================
/// DATE PICKER
/// ===========================
Future<void> pickDate(
  BuildContext context,
  DateTime? selectedDate,
  TextEditingController dobController,
  void Function(void Function()) setState,
) async {
  final now = DateTime.now();
  final DateTime? date = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime(now.year - 18),
    firstDate: DateTime(1900),
    lastDate: now,
  );

  if (date != null) {
    setState(() {
      selectedDate = date;
      dobController.text = "${date.year}-${date.month}-${date.day}";
    });
  }
}
