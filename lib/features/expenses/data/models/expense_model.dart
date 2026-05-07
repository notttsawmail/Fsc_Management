import 'package:isar/isar.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_enums.dart';

part 'expense_model.g.dart';

@collection
class ExpenseModel {
  Id id = Isar.autoIncrement;

  @Index(caseSensitive: false)
  late String title;

  @Index(caseSensitive: false)
  late String category;

  late double amount;
  late String description;

  @Index(caseSensitive: false)
  late String paymentMethod;

  @Index()
  late DateTime expenseDate;

  @Index()
  late DateTime createdAt;

  Expense toEntity() {
    return Expense(
      id: id,
      title: title,
      category: normalizeExpenseCategory(category),
      amount: amount,
      description: description,
      paymentMethod: expensePaymentMethodFromName(paymentMethod),
      expenseDate: expenseDate,
      createdAt: createdAt,
    );
  }

  static ExpenseModel fromEntity(Expense expense) {
    return ExpenseModel()
      ..id = expense.id == 0 ? Isar.autoIncrement : expense.id
      ..title = expense.title
      ..category = normalizeExpenseCategory(expense.category)
      ..amount = expense.amount
      ..description = expense.description
      ..paymentMethod = expense.paymentMethod.name
      ..expenseDate = expense.expenseDate
      ..createdAt = expense.createdAt;
  }
}
