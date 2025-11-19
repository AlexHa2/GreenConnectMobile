String formatDateOnly(DateTime dob) {
  return "${dob.year.toString().padLeft(4, '0')}-"
      "${dob.month.toString().padLeft(2, '0')}-"
      "${dob.day.toString().padLeft(2, '0')}";
}
