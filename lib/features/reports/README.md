# Reports, Analytics, and PDF Export

Offline-first clean architecture module connected to the existing billing,
inventory, and Isar database layers.

## Folder structure

```text
lib/features/reports/
  data/
    datasources/reports_local_data_source.dart
    repositories/reports_repository_impl.dart
    services/reports_pdf_service.dart
  domain/
    entities/
      analytics_dashboard.dart
      calendar_sales_day.dart
      daily_sales_report.dart
      item_sales_summary.dart
      payment_method_summary.dart
      report_date_filter.dart
    repositories/reports_repository.dart
    services/
      nepali_report_clock.dart
      sales_report_generator.dart
    usecases/
      get_analytics_dashboard.dart
      get_calendar_sales.dart
      get_sales_report.dart
  presentation/
    providers/reports_providers.dart
    screens/
      analytics_dashboard_screen.dart
      calendar_sales_screen.dart
      pdf_preview_screen.dart
      reports_screen.dart
    widgets/
      date_filter_bar.dart
      report_formatters.dart
      report_summary_card.dart
```

## Setup

1. Run `flutter pub get`.
2. Start the app with `flutter run`.
3. Open the bottom navigation item `Reports`.

No Isar migration is required because this module reads the existing
`BillingOrderModel` and `InventoryItemModel` collections.

## Data flow

- `ReportsLocalDataSource` opens the existing `fsc_inventory` Isar database.
- `ReportsRepositoryImpl` queries orders by Nepali date boundaries and maps
  Isar models to existing billing/inventory domain entities.
- `SalesReportGenerator` calculates sales totals, itemized sales, payment
  summaries, best sellers, calendar totals, and low-stock analytics.
- `ReportsPdfService` builds printable PDFs with the `pdf` package and exposes
  preview/share/save flows through `printing` and local documents storage.

## Timezone

Reports use `NepaliReportClock` with UTC+05:45. This matches the current billing
module convention, where order `createdAt` and `nepaliDate` are saved using
Nepal time.
