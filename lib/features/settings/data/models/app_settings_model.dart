import 'package:isar/isar.dart';

import '../../../../core/formatters/currency_formatters.dart';
import '../../../billing/domain/entities/billing_enums.dart';
import '../../domain/entities/app_settings.dart';

part 'app_settings_model.g.dart';

@collection
class AppSettingsModel {
  Id id = 1;

  late String shopName;
  late String shopAddress;
  late String currencySymbol;
  late double taxPercentage;
  late bool useNepaliTimezone;
  late String defaultPaymentMethod;
  late String tokenResetRule;
  late bool taxesEnabled;
  late bool notificationsEnabled;
  late bool dailyLowStockSummaryEnabled;
  late int lowStockAlertThreshold;
  DateTime? latestBackupAt;
  String? latestBackupPath;
  DateTime? lastDailyLowStockSummaryAt;
  late DateTime updatedAt;

  AppSettings toEntity() {
    return AppSettings(
      id: id,
      shopName: shopName,
      shopAddress: shopAddress,
      currencySymbol: nepaliRupeeSymbol,
      taxPercentage: taxPercentage,
      useNepaliTimezone: useNepaliTimezone,
      defaultPaymentMethod: PaymentMethod.values.firstWhere(
        (value) => value.name == defaultPaymentMethod,
        orElse: () => PaymentMethod.cash,
      ),
      tokenResetRule: TokenResetRule.values.firstWhere(
        (value) => value.name == tokenResetRule,
        orElse: () => TokenResetRule.daily,
      ),
      taxesEnabled: taxesEnabled,
      notificationsEnabled: notificationsEnabled,
      dailyLowStockSummaryEnabled: dailyLowStockSummaryEnabled,
      lowStockAlertThreshold: lowStockAlertThreshold,
      latestBackupAt: latestBackupAt,
      latestBackupPath: latestBackupPath,
      lastDailyLowStockSummaryAt: lastDailyLowStockSummaryAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopName': shopName,
      'shopAddress': shopAddress,
      'currencySymbol': currencySymbol,
      'taxPercentage': taxPercentage,
      'useNepaliTimezone': useNepaliTimezone,
      'defaultPaymentMethod': defaultPaymentMethod,
      'tokenResetRule': tokenResetRule,
      'taxesEnabled': taxesEnabled,
      'notificationsEnabled': notificationsEnabled,
      'dailyLowStockSummaryEnabled': dailyLowStockSummaryEnabled,
      'lowStockAlertThreshold': lowStockAlertThreshold,
      'latestBackupAt': latestBackupAt?.toIso8601String(),
      'latestBackupPath': latestBackupPath,
      'lastDailyLowStockSummaryAt': lastDailyLowStockSummaryAt
          ?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static AppSettingsModel fromEntity(AppSettings settings) {
    return AppSettingsModel()
      ..id = settings.id
      ..shopName = settings.shopName.trim()
      ..shopAddress = settings.shopAddress.trim()
      ..currencySymbol = nepaliRupeeSymbol
      ..taxPercentage = settings.taxPercentage
      ..useNepaliTimezone = settings.useNepaliTimezone
      ..defaultPaymentMethod = settings.defaultPaymentMethod.name
      ..tokenResetRule = settings.tokenResetRule.name
      ..taxesEnabled = settings.taxesEnabled
      ..notificationsEnabled = settings.notificationsEnabled
      ..dailyLowStockSummaryEnabled = settings.dailyLowStockSummaryEnabled
      ..lowStockAlertThreshold = settings.lowStockAlertThreshold
      ..latestBackupAt = settings.latestBackupAt
      ..latestBackupPath = settings.latestBackupPath
      ..lastDailyLowStockSummaryAt = settings.lastDailyLowStockSummaryAt
      ..updatedAt = settings.updatedAt;
  }

  static AppSettingsModel defaults() {
    return fromEntity(AppSettings.defaults());
  }

  static AppSettingsModel fromJson(Map<String, dynamic> json) {
    return AppSettingsModel()
      ..id = (json['id'] as num?)?.toInt() ?? 1
      ..shopName = json['shopName'] as String? ?? 'FSC Shop'
      ..shopAddress = json['shopAddress'] as String? ?? ''
      ..currencySymbol = nepaliRupeeSymbol
      ..taxPercentage = (json['taxPercentage'] as num?)?.toDouble() ?? 0
      ..useNepaliTimezone = json['useNepaliTimezone'] as bool? ?? true
      ..defaultPaymentMethod =
          json['defaultPaymentMethod'] as String? ?? PaymentMethod.cash.name
      ..tokenResetRule =
          json['tokenResetRule'] as String? ?? TokenResetRule.daily.name
      ..taxesEnabled = json['taxesEnabled'] as bool? ?? false
      ..notificationsEnabled = json['notificationsEnabled'] as bool? ?? true
      ..dailyLowStockSummaryEnabled =
          json['dailyLowStockSummaryEnabled'] as bool? ?? true
      ..lowStockAlertThreshold =
          (json['lowStockAlertThreshold'] as num?)?.toInt() ?? 0
      ..latestBackupAt = DateTime.tryParse(
        json['latestBackupAt'] as String? ?? '',
      )
      ..latestBackupPath = json['latestBackupPath'] as String?
      ..lastDailyLowStockSummaryAt = DateTime.tryParse(
        json['lastDailyLowStockSummaryAt'] as String? ?? '',
      )
      ..updatedAt =
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now();
  }
}
