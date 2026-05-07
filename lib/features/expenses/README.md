# Expense Tracking and Profit Management

Offline-first clean architecture module for local expense tracking, profit
analytics, calendar summaries, and PDF exports.

## Folder Structure

- `data/datasources`: Isar local persistence and billing-order reads.
- `data/models`: Isar collection model and generated adapter.
- `data/repositories`: Repository implementation.
- `data/services`: PDF export service.
- `domain/entities`: Expense, filters, reports, analytics, profit summaries.
- `domain/repositories`: Repository contract.
- `domain/services`: Profit and trend calculation service.
- `domain/usecases`: CRUD, watch, analytics, and report use cases.
- `presentation/providers`: Riverpod data, controller, and PDF providers.
- `presentation/screens`: Expense list, add/edit form, profit dashboard, analytics.
- `presentation/widgets`: Reserved for reusable expense widgets.

## Setup

1. Add the module files under `lib/features/expenses`.
2. Register `ExpenseModelSchema` in every `Isar.open` call for the shared
   `fsc_inventory` database.
3. Generate Isar code:

   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run static analysis:

   ```sh
   flutter analyze
   ```

5. Start the app:

   ```sh
   flutter run
   ```

## Integrations

- Inventory: expenses share the same local Isar database as inventory records.
  `Product purchase` is provided as a first-class category for stock purchasing.
- Billing: profit uses paid, non-cancelled billing orders as total sales.
- Reports: calendar days display daily sales, expenses, and net profit.
- PDF: expense and profit reports can be shared or saved locally.

## Profit Formula

```text
Profit = Total Sales - Total Expenses
```

The module uses Nepal time through the existing `NepaliReportClock`.
