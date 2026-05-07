# Receipt Barcode Module

Offline-first receipt printing and barcode support for billing and inventory.

## Folder structure

```text
lib/features/receipt_barcode/
  data/
    datasources/
      printer_settings_local_data_source.dart
      receipt_barcode_local_data_source.dart
    repositories/
      receipt_barcode_repository_impl.dart
    services/
      receipt_formatters.dart
      receipt_pdf_service.dart
      thermal_printer_service.dart
  domain/
    entities/
      printer_settings.dart
    repositories/
      receipt_barcode_repository.dart
    services/
      barcode_service.dart
    usecases/
      generate_unique_barcode.dart
      validate_barcode.dart
      watch_receipt_orders.dart
  presentation/
    providers/
      receipt_barcode_providers.dart
    screens/
      barcode_generator_screen.dart
      barcode_scanner_screen.dart
      printer_settings_screen.dart
      receipt_preview_screen.dart
      reprint_receipts_screen.dart
```

## Receipt printing flow

1. Billing creates and saves a paid `BillingOrder` in Isar.
2. `OrderSuccessScreen` opens `ReceiptPreviewScreen`.
3. `ReceiptPreviewScreen` loads shop settings from the settings module.
4. The receipt can be printed through `printing`, saved/shared as PDF, or sent to a network thermal printer through `esc_pos_printer`.
5. `ReportsScreen` exposes `ReprintReceiptsScreen`, which watches saved Isar billing orders and reopens the preview for old receipts.

## Barcode scanning flow

1. Inventory items store an optional `barcode` with an Isar index.
2. `BarcodeGeneratorScreen` generates a unique local barcode or saves manual entry after uniqueness validation.
3. Billing search matches item name, item code, category, and barcode.
4. `BarcodeScannerScreen` uses `mobile_scanner` with duplicate detection.
5. When a barcode resolves to an inventory item, billing adds it to the active cart or increases quantity if already present.

## Setup

1. Run `flutter pub get`.
2. Run `dart run build_runner build --delete-conflicting-outputs` after Isar schema changes.
3. Configure printer IP, port, paper size, and auto-print from Settings > printer icon.
4. Add or edit inventory items and use the barcode field or item action menu to generate barcodes.
5. During billing, use Scan barcode or search by barcode to quick-add items.

## Notes

- The module is offline-first and uses the existing local Isar database.
- Nepali timezone support follows the existing billing clock, which stores order timestamps in UTC+05:45.
- Network thermal printing is active. Bluetooth and USB settings are persisted and represented in the UI, but sending ESC/POS bytes over those transports requires platform transport plugins in addition to the requested ESC/POS packages.
- `pubspec.yaml` includes an `image` override because the requested `esc_pos_printer` package declares an older image dependency than the current PDF/printing stack.
