import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../inventory/domain/entities/inventory_item.dart';
import '../providers/receipt_barcode_providers.dart';

class BarcodeGeneratorScreen extends ConsumerStatefulWidget {
  const BarcodeGeneratorScreen({super.key, required this.item});

  final InventoryItem item;

  @override
  ConsumerState<BarcodeGeneratorScreen> createState() =>
      _BarcodeGeneratorScreenState();
}

class _BarcodeGeneratorScreenState
    extends ConsumerState<BarcodeGeneratorScreen> {
  final _barcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _barcodeController.text = widget.item.barcode ?? '';
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(barcodeControllerProvider);
    final barcode = _barcodeController.text.trim();

    ref.listen<AsyncValue<String?>>(barcodeControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (value) {
          if (previous?.isLoading == true && value != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Barcode saved')));
          }
        },
        error: (error, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString()))),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Barcode')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.item.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(widget.item.itemCode),
          const SizedBox(height: 20),
          TextField(
            controller: _barcodeController,
            decoration: const InputDecoration(
              labelText: 'Barcode',
              prefixIcon: Icon(Icons.qr_code_2),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9_.-]')),
            ],
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: state.isLoading ? null : _generate,
                icon: const Icon(Icons.auto_fix_high_outlined),
                label: const Text('Generate'),
              ),
              OutlinedButton.icon(
                onPressed: state.isLoading || barcode.isEmpty ? null : _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (barcode.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: barcode,
                      height: 110,
                      drawText: true,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () =>
                          Clipboard.setData(ClipboardData(text: barcode)),
                      icon: const Icon(Icons.copy_outlined),
                      label: const Text('Copy'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _generate() async {
    final barcode = await ref
        .read(barcodeControllerProvider.notifier)
        .generate(itemId: widget.item.id);
    if (!mounted) return;
    setState(() => _barcodeController.text = barcode);
  }

  Future<void> _save() async {
    await ref
        .read(barcodeControllerProvider.notifier)
        .saveBarcode(
          item: widget.item,
          barcode: _barcodeController.text.trim(),
        );
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
