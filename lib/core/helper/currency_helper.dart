/// Helper to format a number as Vietnamese currency with thousands separator (e.g., 1.000)
String formatVND(num value) {
  if (value == 0) return '0';
  return value
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
}
