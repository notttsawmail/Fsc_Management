import '../../../billing/domain/entities/billing_order.dart';
import 'item_sales_summary.dart';
import 'payment_method_summary.dart';

class DailySalesReport {
  const DailySalesReport({
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.orders,
    required this.totalOrders,
    required this.totalIncome,
    required this.totalQuantitySold,
    required this.cancelledOrdersCount,
    required this.paymentSummaries,
    required this.itemSales,
    required this.bestSellingItems,
  });

  final String label;
  final DateTime startDate;
  final DateTime endDate;
  final List<BillingOrder> orders;
  final int totalOrders;
  final double totalIncome;
  final int totalQuantitySold;
  final int cancelledOrdersCount;
  final List<PaymentMethodSummary> paymentSummaries;
  final List<ItemSalesSummary> itemSales;
  final List<ItemSalesSummary> bestSellingItems;
}
