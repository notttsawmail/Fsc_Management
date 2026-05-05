import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/inventory_item.dart';
import '../providers/inventory_providers.dart';
import '../widgets/item_image_preview.dart';

class AddEditInventoryItemScreen extends ConsumerStatefulWidget {
  const AddEditInventoryItemScreen({super.key, this.item});

  final InventoryItem? item;

  @override
  ConsumerState<AddEditInventoryItemScreen> createState() =>
      _AddEditInventoryItemScreenState();
}

class _AddEditInventoryItemScreenState
    extends ConsumerState<AddEditInventoryItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _itemCodeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _lowStockLimitController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? _imagePath;
  bool _isTrackableInventory = true;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item == null) {
      _quantityController.text = '0';
      _lowStockLimitController.text = '0';
      return;
    }

    _nameController.text = item.name;
    _itemCodeController.text = item.itemCode;
    _categoryController.text = item.category;
    _priceController.text = item.price.toStringAsFixed(2);
    _quantityController.text = item.quantity.toString();
    _lowStockLimitController.text = item.lowStockLimit.toString();
    _imagePath = item.imagePath;
    _isTrackableInventory = item.isTrackableInventory;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _itemCodeController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _lowStockLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(inventoryControllerProvider);
    final categories = ref.watch(inventoryCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit item' : 'Add item'),
        actions: [
          TextButton.icon(
            onPressed: controllerState.isLoading ? null : _saveItem,
            icon: controllerState.isLoading
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: const Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ImagePickerField(
                imagePath: _imagePath,
                onPickImage: _pickImage,
                onRemoveImage: () => setState(() => _imagePath = null),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
                textInputAction: TextInputAction.next,
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _itemCodeController,
                decoration: const InputDecoration(
                  labelText: 'Item code',
                  prefixIcon: Icon(Icons.qr_code_2),
                ),
                textInputAction: TextInputAction.next,
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                textInputAction: TextInputAction.next,
                validator: _requiredValidator,
              ),
              categories.maybeWhen(
                data: (items) {
                  if (items.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: items
                          .map(
                            (category) => ActionChip(
                              label: Text(category),
                              onPressed: () {
                                _categoryController.text = category;
                              },
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: _nonNegativeDecimalValidator,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Track inventory'),
                subtitle: Text(
                  _isTrackableInventory
                      ? 'Quantity and low stock alerts are enabled.'
                      : 'Keep item details without stock tracking.',
                ),
                value: _isTrackableInventory,
                onChanged: (value) {
                  setState(() => _isTrackableInventory = value);
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _nonNegativeIntValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lowStockLimitController,
                      decoration: const InputDecoration(
                        labelText: 'Low stock limit',
                        prefixIcon: Icon(Icons.notification_important_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _nonNegativeIntValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: controllerState.isLoading ? null : _saveItem,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save item'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  String? _nonNegativeDecimalValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    final parsed = double.tryParse(value);
    if (parsed == null) {
      return 'Enter a valid number';
    }
    if (parsed < 0) {
      return 'Cannot be below 0';
    }
    return null;
  }

  String? _nonNegativeIntValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    final parsed = int.tryParse(value);
    if (parsed == null) {
      return 'Enter a valid number';
    }
    if (parsed < 0) {
      return 'Cannot be below 0';
    }
    return null;
  }

  Future<void> _pickImage() async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (pickedImage == null) return;

    final savedPath = await ref
        .read(inventoryControllerProvider.notifier)
        .saveImageLocally(pickedImage.path);
    if (!mounted) return;
    setState(() => _imagePath = savedPath);
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();
    final existing = widget.item;
    final item = InventoryItem(
      id: existing?.id ?? 0,
      name: _nameController.text.trim(),
      itemCode: _itemCodeController.text.trim(),
      category: _categoryController.text.trim(),
      price: double.parse(_priceController.text),
      quantity: int.parse(_quantityController.text),
      lowStockLimit: int.parse(_lowStockLimitController.text),
      imagePath: _imagePath,
      isTrackableInventory: _isTrackableInventory,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    final controller = ref.read(inventoryControllerProvider.notifier);
    if (_isEditing) {
      await controller.updateItem(item);
    } else {
      await controller.addItem(item);
    }

    if (!mounted) return;
    final state = ref.read(inventoryControllerProvider);
    if (!state.hasError) {
      Navigator.of(context).pop();
    }
  }
}

class _ImagePickerField extends StatelessWidget {
  const _ImagePickerField({
    required this.imagePath,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  final String? imagePath;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage =
        imagePath != null &&
        imagePath!.isNotEmpty &&
        File(imagePath!).existsSync();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ItemImagePreview(imagePath: imagePath, size: 88),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item image',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasImage
                      ? 'Saved locally on this device.'
                      : 'No image selected',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: onPickImage,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(hasImage ? 'Change' : 'Choose'),
                    ),
                    if (hasImage)
                      IconButton.filledTonal(
                        tooltip: 'Remove image',
                        onPressed: onRemoveImage,
                        icon: const Icon(Icons.delete_outline),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
