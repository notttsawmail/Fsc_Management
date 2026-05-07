import '../../../billing/domain/entities/billing_enums.dart';
import '../../../../core/formatters/currency_formatters.dart';

enum TokenResetRule { daily, never }

class AppSettings {
  const AppSettings({
    required this.id,
    required this.shopName,
    required this.shopAddress,
    required this.currencySymbol,
    required this.taxPercentage,
    required this.useNepaliTimezone,
    required this.defaultPaymentMethod,
    required this.tokenResetRule,
    required this.taxesEnabled,
    required this.notificationsEnabled,
    required this.dailyLowStockSummaryEnabled,
    required this.lowStockAlertThreshold,
    required this.latestBackupAt,
    required this.latestBackupPath,
    required this.lastDailyLowStockSummaryAt,
    required this.updatedAt,
  });

  factory AppSettings.defaults() {
    final now = DateTime.now();
    return AppSettings(
      id: 1,
      shopName: 'FSC Shop',
      shopAddress: '',
      currencySymbol: nepaliRupeeSymbol,
      taxPercentage: 0,
      useNepaliTimezone: true,
      defaultPaymentMethod: PaymentMethod.cash,
      tokenResetRule: TokenResetRule.daily,
      taxesEnabled: false,
      notificationsEnabled: true,
      dailyLowStockSummaryEnabled: true,
      lowStockAlertThreshold: 0,
      latestBackupAt: null,
      latestBackupPath: null,
      lastDailyLowStockSummaryAt: null,
      updatedAt: now,
    );
  }

  final int id;
  final String shopName;
  final String shopAddress;
  final String currencySymbol;
  final double taxPercentage;
  final bool useNepaliTimezone;
  final PaymentMethod defaultPaymentMethod;
  final TokenResetRule tokenResetRule;
  final bool taxesEnabled;
  final bool notificationsEnabled;
  final bool dailyLowStockSummaryEnabled;
  final int lowStockAlertThreshold;
  final DateTime? latestBackupAt;
  final String? latestBackupPath;
  final DateTime? lastDailyLowStockSummaryAt;
  final DateTime updatedAt;

  AppSettings copyWith({
    int? id,
    String? shopName,
    String? shopAddress,
    String? currencySymbol,
    double? taxPercentage,
    bool? useNepaliTimezone,
    PaymentMethod? defaultPaymentMethod,
    TokenResetRule? tokenResetRule,
    bool? taxesEnabled,
    bool? notificationsEnabled,
    bool? dailyLowStockSummaryEnabled,
    int? lowStockAlertThreshold,
    DateTime? latestBackupAt,
    bool clearLatestBackupAt = false,
    String? latestBackupPath,
    bool clearLatestBackupPath = false,
    DateTime? lastDailyLowStockSummaryAt,
    bool clearLastDailyLowStockSummaryAt = false,
    DateTime? updatedAt,
  }) {
    return AppSettings(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      shopAddress: shopAddress ?? this.shopAddress,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      useNepaliTimezone: useNepaliTimezone ?? this.useNepaliTimezone,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
      tokenResetRule: tokenResetRule ?? this.tokenResetRule,
      taxesEnabled: taxesEnabled ?? this.taxesEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyLowStockSummaryEnabled:
          dailyLowStockSummaryEnabled ?? this.dailyLowStockSummaryEnabled,
      lowStockAlertThreshold:
          lowStockAlertThreshold ?? this.lowStockAlertThreshold,
      latestBackupAt: clearLatestBackupAt
          ? null
          : latestBackupAt ?? this.latestBackupAt,
      latestBackupPath: clearLatestBackupPath
          ? null
          : latestBackupPath ?? this.latestBackupPath,
      lastDailyLowStockSummaryAt: clearLastDailyLowStockSummaryAt
          ? null
          : lastDailyLowStockSummaryAt ?? this.lastDailyLowStockSummaryAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
