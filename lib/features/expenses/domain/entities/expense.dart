import 'expense_enums.dart';

class Expense {
  const Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.description,
    required this.paymentMethod,
    required this.expenseDate,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String category;
  final double amount;
  final String description;
  final ExpensePaymentMethod paymentMethod;
  final DateTime expenseDate;
  final DateTime createdAt;

  Expense copyWith({
    int? id,
    String? title,
    String? category,
    double? amount,
    String? description,
    ExpensePaymentMethod? paymentMethod,
    DateTime? expenseDate,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
