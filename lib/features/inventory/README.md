# Inventory Module

Offline-first inventory management feature built with Flutter, Riverpod, Isar,
and clean architecture.

## Folder Structure

```text
lib/features/inventory/
├── data
│   ├── datasources
│   │   └── inventory_local_data_source.dart
│   ├── models
│   │   ├── inventory_item_model.dart
│   │   └── inventory_item_model.g.dart
│   └── repositories
│       └── inventory_repository_impl.dart
├── domain
│   ├── entities
│   │   └── inventory_item.dart
│   ├── repositories
│   │   └── inventory_repository.dart
│   └── usecases
│       ├── add_inventory_item.dart
│       ├── adjust_inventory_quantity.dart
│       ├── delete_inventory_item.dart
│       ├── update_inventory_item.dart
│       └── watch_inventory_items.dart
└── presentation
    ├── providers
    │   └── inventory_providers.dart
    ├── screens
    │   ├── add_edit_inventory_item_screen.dart
    │   └── inventory_list_screen.dart
    └── widgets
        ├── inventory_empty_state.dart
        ├── inventory_item_tile.dart
        ├── inventory_loading_state.dart
        └── item_image_preview.dart
```

## Setup

1. Install packages:

   ```bash
   flutter pub get
   ```

2. Generate Isar collection code after model changes:

   ```bash
   dart run build_runner build
   ```

3. Run the app:

   ```bash
   flutter run
   ```

4. Verify code quality:

   ```bash
   flutter analyze
   flutter test
   ```

## Notes

- Inventory data is persisted offline in Isar.
- Picked item images are copied into the app documents directory under
  `inventory_images`.
- Quantity adjustments clamp at `0`, so stock cannot go negative.
- Search watches Isar directly and updates instantly as the local query changes.
- Billing is intentionally not included in this module.
