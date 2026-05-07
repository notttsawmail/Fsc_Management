import '../../../billing/domain/entities/billing_enums.dart';
import '../../../billing/domain/entities/billing_order.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../entities/analytics_dashboard.dart';
import '../entities/calendar_sales_day.dart';
import '../entities/daily_sales_report.dart';
import '../entities/item_sales_summary.dart';
import '../entities/payment_method_summary.dart';
import '../entities/report_date_filter.dart';
import 'nepali_report_clock.dart';

class SalesReportGenerator {
  SalesReportGenerator(this._clock);

  final NepaliReportClock _clock;

  DailySalesReport buildReport({
    required ReportDateFilter filter,
    required List<BillingOrder> orders,
    List<Expense> expenses = const [],
  }) {
    final range = _clock.resolve(filter);
    final paidOrders = orders
        .where((order) => order.orderStatus != OrderStatus.cancelled)
        .toList(growable: false);
    final cancelledOrders = orders
        .where((order) => order.orderStatus == OrderStatus.cancelled)
        .length;
    final itemSales = _itemSalesFor(paidOrders);
    final paymentSummaries = _paymentSummariesFor(paidOrders);
    final bestSelling = [...itemSales]
      ..sort((a, b) {
        final quantityCompare = b.quantitySold.compareTo(a.quantitySold);
        if (quantityCompare != 0) {
          return quantityCompare;
        }
        return b.totalRevenue.compareTo(a.totalRevenue);
      });

    return DailySalesReport(
      label: range.label,
      startDate: range.startInclusive,
      endDate: range.endInclusive,
      orders: orders,
      totalOrders: paidOrders.length,
      totalIncome: paidOrders.fold(
        0,
        (total, order) => total + order.totalAmount,
      ),
      totalExpenses: expenses.fold(
        0.0,
        (total, expense) => total + expense.amount,
      ),
      totalQuantitySold: itemSales.fold(
        0,
        (total, item) => total + item.quantitySold,
      ),
      cancelledOrdersCount: cancelledOrders,
      paymentSummaries: paymentSummaries,
      itemSales: itemSales,
      bestSellingItems: bestSelling.take(5).toList(growable: false),
      expenses: expenses,
    );
  }

  List<CalendarSalesDay> buildCalendar({
    required DateTime month,
    required List<BillingOrder> orders,
    List<Expense> expenses = const [],
  }) {
    final firstDay = DateTime(month.year, month.month);
    final nextMonth = DateTime(month.year, month.month + 1);
    final days = <CalendarSalesDay>[];

    for (
      var date = firstDay;
      date.isBefore(nextMonth);
      date = date.add(const Duration(days: 1))
    ) {
      final dayKey = _clock.compactDate(date);
      final dayOrders = orders
          .where(
            (order) =>
                order.nepaliDate == dayKey &&
                order.orderStatus != OrderStatus.cancelled,
          )
          .toList(growable: false);
      final dayExpenses = expenses
          .where((expense) => _clock.compactDate(expense.expenseDate) == dayKey)
          .fold(0.0, (total, expense) => total + expense.amount);
      days.add(
        CalendarSalesDay(
          date: date,
          tokenCount: dayOrders.length,
          orderCount: dayOrders.length,
          totalIncome: dayOrders.fold(
            0,
            (total, order) => total + order.totalAmount,
          ),
          totalExpenses: dayExpenses,
        ),
      );
    }

    return days;
  }

  AnalyticsDashboard buildDashboard({
    required DailySalesReport todayReport,
    required List<InventoryItem> inventoryItems,
  }) {
    final trackable = inventoryItems.where((item) => item.isTrackableInventory);
    final outOfStock = trackable
        .where((item) => item.quantity <= 0)
        .toList(growable: false);
    final lowStock = trackable
        .where(
          (item) => item.quantity > 0 && item.quantity <= item.lowStockLimit,
        )
        .toList(growable: false);

    return AnalyticsDashboard(
      todaySales: todayReport.totalIncome,
      todayTokenCount: todayReport.totalOrders,
      lowStockItems: lowStock,
      outOfStockItems: outOfStock,
      bestSellingItems: todayReport.bestSellingItems,
      totalInventoryItems: inventoryItems.length,
    );
  }

  List<ItemSalesSummary> _itemSalesFor(List<BillingOrder> orders) {
    final summaries = <String, ItemSalesSummary>{};
    for (final order in orders) {
      for (final item in order.items) {
        final key = '${item.inventoryItemId}_${item.unitPrice}';
        final existing = summaries[key];
        summaries[key] = ItemSalesSummary(
          inventoryItemId: item.inventoryItemId,
          itemName: item.itemName,
          itemCode: item.itemCode,
          quantitySold: (existing?.quantitySold ?? 0) + item.quantity,
          unitPrice: item.unitPrice,
          totalRevenue: (existing?.totalRevenue ?? 0) + item.lineTotal,
        );
      }
    }
    final items = summaries.values.toList();
    items.sort(
      (a, b) => a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase()),
    );
    return items;
  }

  List<PaymentMethodSummary> _paymentSummariesFor(List<BillingOrder> orders) {
    return PaymentMethod.values
        .map((method) {
          final matching = orders.where(
            (order) => order.paymentMethod == method,
          );
          return PaymentMethodSummary(
            paymentMethod: method,
            orderCount: matching.length,
            totalAmount: matching.fold(
              0,
              (total, order) => total + order.totalAmount,
            ),
          );
        })
        .where((summary) => summary.orderCount > 0)
        .toList(growable: false);
  }
}
