import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../reports/presentation/providers/reports_providers.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_enums.dart';
import '../providers/expense_providers.dart';

class AddEditExpenseScreen extends ConsumerStatefulWidget {
  const AddEditExpenseScreen({super.key, this.expense});

  final Expense? expense;

  @override
  ConsumerState<AddEditExpenseScreen> createState() =>
      _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends ConsumerState<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  ExpensePaymentMethod _paymentMethod = ExpensePaymentMethod.cash;
  late DateTime _expenseDate;

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    if (expense == null) {
      _expenseDate = DateTime.now();
      _categoryController.text = 'Miscellaneous';
      return;
    }
    _titleController.text = expense.title;
    _categoryController.text = expense.category;
    _amountController.text = expense.amount.toStringAsFixed(2);
    _descriptionController.text = expense.description;
    _paymentMethod = expense.paymentMethod;
    _expenseDate = expense.expenseDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(expenseControllerProvider);
    final categories = ref.watch(expenseCategoriesProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit expense' : 'Add expense'),
        actions: [
          TextButton.icon(
            onPressed: controllerState.isLoading ? null : _save,
            icon: controllerState.isLoading
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: const Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.receipt_long_outlined),
                ),
                textInputAction: TextInputAction.next,
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'Type your own category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                validator: _requiredValidator,
              ),
              if (categories.isNotEmpty) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final category in categories)
                        ActionChip(
                          label: Text(category),
                          onPressed: () {
                            _categoryController.text = category;
                          },
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (Nepali Rs.)',
                  prefixIcon: Icon(Icons.payments_outlined),
                  prefixText: 'Rs. ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: _positiveAmountValidator,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ExpensePaymentMethod>(
                initialValue: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment method',
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                ),
                items: ExpensePaymentMethod.values
                    .map(
                      (method) => DropdownMenuItem(
                        value: method,
                        child: Text(method.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _paymentMethod = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_outlined),
                title: const Text('Expense date'),
                subtitle: Text(_date(_expenseDate)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickDate,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: controllerState.isLoading ? null : _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDate: _expenseDate,
    );
    if (picked == null) {
      return;
    }
    setState(() => _expenseDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final clock = ref.read(nepaliReportClockProvider);
    final now = clock.now();
    final selectedDate = DateTime(
      _expenseDate.year,
      _expenseDate.month,
      _expenseDate.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
    );
    final existing = widget.expense;
    final expense = Expense(
      id: existing?.id ?? 0,
      title: _titleController.text.trim(),
      category: normalizeExpenseCategory(_categoryController.text),
      amount: double.parse(_amountController.text),
      description: _descriptionController.text.trim(),
      paymentMethod: _paymentMethod,
      expenseDate: selectedDate,
      createdAt: existing?.createdAt ?? now,
    );
    await ref.read(expenseControllerProvider.notifier).save(expense);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  String? _positiveAmountValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    final parsed = double.tryParse(value);
    if (parsed == null) {
      return 'Enter a valid number';
    }
    if (parsed <= 0) {
      return 'Must be above 0';
    }
    return null;
  }

  String _date(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/'
        '${value.month.toString().padLeft(2, '0')}/${value.year}';
  }
}
