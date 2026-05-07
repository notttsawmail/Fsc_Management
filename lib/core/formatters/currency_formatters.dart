const nepaliRupeeSymbol = 'Rs.';

String nepaliRupees(num value, {bool decimals = true}) {
  final amount = decimals ? value.toStringAsFixed(2) : value.toStringAsFixed(0);
  return '$nepaliRupeeSymbol $amount';
}
