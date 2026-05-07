import '../../../../core/formatters/currency_formatters.dart';

String money(num value) => nepaliRupees(value, decimals: false);

String shortDate(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  return '$day/$month/${value.year}';
}
