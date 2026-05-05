# Billing Module

Offline-first billing and cart feature built with Flutter, Riverpod, Isar, and
clean architecture. It shares the existing `fsc_inventory` Isar database with
the inventory module.

## Folder structure

```text
lib/features/billing/
├── data
│   ├── datasources
│   │   └── billing_local_data_source.dart
│   ├── models
│   │   ├── billing_order_model.dart
│   │   └── billing_order_model.g.dart
│   └── repositories
│       └── billing_repository_impl.dart
├── domain
│   ├── entities
│   │   ├── billing_enums.dart
│   │   ├── billing_order.dart
│   │   ├── billing_order_item.dart
│   │   └── cart_item.dart
│   ├── repositories
│   │   └── billing_repository.dart
│   └── usecases
│       ├── cancel_order.dart
│       ├── create_paid_order.dart
│       └── watch_billing_orders.dart
└── presentation
    ├── providers
    │   └── billing_providers.dart
    ├── screens
    │   ├── billing_screen.dart
    │   └── order_success_screen.dart
    └── widgets
        ├── cart_panel.dart
        ├── item_quantity_controls.dart
        └── payment_dialog.dart
```

## Database schema updates

- Added `BillingOrderModel` Isar collection.
- Added embedded `BillingOrderItemModel` list for order lines.
- `InventoryLocalDataSource` and `BillingLocalDataSource` now open the same
  database name, `fsc_inventory`, with both schemas:
  `InventoryItemModelSchema` and `BillingOrderModelSchema`.
- Token numbers are generated from saved orders for the current Nepali timezone
  date and reset automatically when the date changes.

## Implementation flow

1. Search inventory items from the existing inventory repository.
2. Create one or more open restaurant-style tokens from the billing screen.
3. Add items to the active token's Riverpod cart state.
4. Temporarily reduce displayed available stock by subtracting cart quantity
   across every open token.
5. Restore temporary stock automatically when quantity decreases, item is
   removed, a token is closed, or a token cart is cleared.
6. On payment confirmation, create the order and deduct final inventory stock in
   one Isar transaction.
7. For Phone Pay, the transaction only runs after tapping `Payment completed`.
8. Cancelling a saved order restores inventory stock in an Isar transaction.

## Commands

```sh
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```
