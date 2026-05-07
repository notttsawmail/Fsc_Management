import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../reports/presentation/widgets/report_formatters.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_enums.dart';
import '../../domain/entities/expense_filters.dart';
import '../providers/expense_providers.dart';
import 'add_edit_expense_screen.dart';
import 'expense_analytics_screen.dart';
import 'profit_dashboard_screen.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider);
    final filters = ref.watch(expenseFiltersProvider);
    final controller = ref.watch(expenseControllerProvider);

    ref.listen<AsyncValue<void>>(expenseControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Expenses'),
          actions: [
            IconButton(
              tooltip: 'Add expense',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddEditExpenseScreen()),
              ),
              icon: const Icon(Icons.add),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.receipt_long_outlined), text: 'Expenses'),
              Tab(icon: Icon(Icons.dashboard_outlined), text: 'Profit'),
              Tab(icon: Icon(Icons.query_stats_outlined), text: 'Analytics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                _ExpenseFilters(filters: filters),
                const Divider(height: 1),
                Expanded(
                  child: expenses.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    data: (items) {
                      if (items.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('No expenses found.'),
                          ),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async =>
                            ref.refresh(expensesProvider.future),
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
                          itemCount: items.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            return _ExpenseTile(
                              expense: items[index],
                              isBusy: controller.isLoading,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const ProfitDashboardScreen(),
            const ExpenseAnalyticsScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddEditExpenseScreen()),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Expense'),
        ),
      ),
    );
  }
}

class _ExpenseFilters extends ConsumerStatefulWidget {
  const _ExpenseFilters({required this.filters});

  final ExpenseFilters filters;

  @override
  ConsumerState<_ExpenseFilters> createState() => _ExpenseFiltersState();
}

class _ExpenseFiltersState extends ConsumerState<_ExpenseFilters> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.filters.searchQuery);
  }

  @override
  void didUpdateWidget(covariant _ExpenseFilters oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filters.searchQuery != _searchController.text) {
      _searchController.text = widget.filters.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(expenseCategoriesProvider).value ?? const [];
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search expenses',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.filters.searchQuery.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        _searchController.clear();
                        _setFilters(widget.filters.copyWith(searchQuery: ''));
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
            onChanged: (value) {
              _setFilters(widget.filters.copyWith(searchQuery: value));
            },
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilterChip(
                label: const Text('All categories'),
                selected: widget.filters.category == null,
                onSelected: (_) {
                  _setFilters(widget.filters.copyWith(clearCategory: true));
                },
              ),
              for (final category in categories)
                FilterChip(
                  label: Text(category),
                  selected: widget.filters.category == category,
                  onSelected: (_) {
                    _setFilters(widget.filters.copyWith(category: category));
                  },
                ),
              OutlinedButton.icon(
                onPressed: _pickDateRange,
                icon: const Icon(Icons.date_range_outlined),
                label: Text(_dateRangeLabel(widget.filters)),
              ),
              if (widget.filters.startDate != null ||
                  widget.filters.endDate != null)
                IconButton(
                  tooltip: 'Clear dates',
                  onPressed: () {
                    _setFilters(widget.filters.copyWith(clearDates: true));
                  },
                  icon: const Icon(Icons.event_busy_outlined),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange: widget.filters.startDate == null
          ? null
          : DateTimeRange(
              start: widget.filters.startDate!,
              end: widget.filters.endDate ?? widget.filters.startDate!,
            ),
    );
    if (picked == null) {
      return;
    }
    _setFilters(
      widget.filters.copyWith(startDate: picked.start, endDate: picked.end),
    );
  }

  void _setFilters(ExpenseFilters filters) {
    ref.read(expenseFiltersProvider.notifier).state = filters;
  }

  String _dateRangeLabel(ExpenseFilters filters) {
    if (filters.startDate == null) {
      return 'Date range';
    }
    final start = _shortDate(filters.startDate!);
    final end = _shortDate(filters.endDate ?? filters.startDate!);
    return start == end ? start : '$start - $end';
  }

  String _shortDate(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/'
        '${value.month.toString().padLeft(2, '0')}/${value.year}';
  }
}

class _ExpenseTile extends ConsumerWidget {
  const _ExpenseTile({required this.expense, required this.isBusy});

  final Expense expense;
  final bool isBusy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;
          final details =
              '${expense.category} • ${expense.paymentMethod.label} • '
              '${_date(expense.expenseDate)}';
          final actions = Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                money(expense.amount),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                tooltip: 'Edit',
                onPressed: isBusy
                    ? null
                    : () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              AddEditExpenseScreen(expense: expense),
                        ),
                      ),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: isBusy ? null : () => _confirmDelete(context, ref),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          );
          if (compact) {
            return InkWell(
              onTap: () => _openEditor(context),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      child: Icon(_categoryIcon(expense.category), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(details),
                          const SizedBox(height: 8),
                          actions,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListTile(
            leading: CircleAvatar(
              child: Icon(_categoryIcon(expense.category), size: 20),
            ),
            title: Text(expense.title),
            subtitle: Text(details),
            trailing: actions,
            onTap: () => _openEditor(context),
          );
        },
      ),
    );
  }

  void _openEditor(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddEditExpenseScreen(expense: expense)),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete expense?'),
        content: Text('Delete "${expense.title}" permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(expenseControllerProvider.notifier).delete(expense.id);
    }
  }

  IconData _categoryIcon(String category) {
    final normalized = category.toLowerCase();
    if (normalized.contains('rent')) {
      return Icons.storefront_outlined;
    }
    if (normalized.contains('electric') || normalized.contains('power')) {
      return Icons.bolt_outlined;
    }
    if (normalized.contains('internet') || normalized.contains('wifi')) {
      return Icons.wifi_outlined;
    }
    if (normalized.contains('salary') || normalized.contains('staff')) {
      return Icons.badge_outlined;
    }
    if (normalized.contains('purchase') || normalized.contains('stock')) {
      return Icons.inventory_2_outlined;
    }
    if (normalized.contains('transport') || normalized.contains('delivery')) {
      return Icons.local_shipping_outlined;
    }
    return Icons.category_outlined;
  }

  String _date(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/'
        '${value.month.toString().padLeft(2, '0')}/${value.year}';
  }
}
