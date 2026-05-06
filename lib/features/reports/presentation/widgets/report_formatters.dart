String money(num value) => 'Rs. ${value.toStringAsFixed(0)}';

String shortDate(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  return '$day/$month/${value.year}';
}
