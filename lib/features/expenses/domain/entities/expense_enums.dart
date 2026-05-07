const Map<String, String> legacyExpenseCategoryLabels = {
  'rent': 'Rent',
  'electricity': 'Electricity',
  'internet': 'Internet',
  'staffSalary': 'Staff salary',
  'productPurchase': 'Product purchase',
  'transportation': 'Transportation',
  'miscellaneous': 'Miscellaneous',
};

String normalizeExpenseCategory(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return 'Miscellaneous';
  }
  return legacyExpenseCategoryLabels[trimmed] ?? trimmed;
}

enum ExpensePaymentMethod { cash, phonePay, bankTransfer }

extension ExpensePaymentMethodLabel on ExpensePaymentMethod {
  String get label {
    switch (this) {
      case ExpensePaymentMethod.cash:
        return 'Cash';
      case ExpensePaymentMethod.phonePay:
        return 'Phone Pay';
      case ExpensePaymentMethod.bankTransfer:
        return 'Bank Transfer';
    }
  }
}

ExpensePaymentMethod expensePaymentMethodFromName(String name) {
  return ExpensePaymentMethod.values.firstWhere(
    (value) => value.name == name,
    orElse: () => ExpensePaymentMethod.cash,
  );
}
