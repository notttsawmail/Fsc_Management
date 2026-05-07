import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../inventory/domain/entities/inventory_item.dart';
import '../providers/receipt_barcode_providers.dart';

class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({
    super.key,
    this.onItemFound,
    this.closeOnFound = true,
  });

  final ValueChanged<InventoryItem>? onItemFound;
  final bool closeOnFound;

  @override
  ConsumerState<BarcodeScannerScreen> createState() =>
      _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen> {
  final _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.qrCode,
    ],
  );

  String? _lastCode;
  DateTime? _lastScanAt;
  bool _busy = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan barcode'),
        actions: [
          IconButton(
            tooltip: 'Torch',
            onPressed: _scannerController.toggleTorch,
            icon: const Icon(Icons.flash_on_outlined),
          ),
          IconButton(
            tooltip: 'Switch camera',
            onPressed: _scannerController.switchCamera,
            icon: const Icon(Icons.cameraswitch_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _handleDetection,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 280,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (_busy)
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: Text('Looking up item...'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    final code = capture.barcodes
        .map((barcode) => barcode.rawValue?.trim())
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .firstOrNull;
    if (code == null || _isDuplicate(code) || _busy) {
      return;
    }

    setState(() {
      _busy = true;
      _lastCode = code;
      _lastScanAt = DateTime.now();
    });

    try {
      final item = await ref
          .read(barcodeControllerProvider.notifier)
          .findItem(code);
      if (!mounted) return;
      if (item == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No item found for $code')));
        setState(() => _busy = false);
        return;
      }
      widget.onItemFound?.call(item);
      if (widget.closeOnFound) {
        Navigator.of(context).pop(item);
        return;
      }
      setState(() => _busy = false);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
      setState(() => _busy = false);
    }
  }

  bool _isDuplicate(String code) {
    final lastScanAt = _lastScanAt;
    if (_lastCode != code || lastScanAt == null) {
      return false;
    }
    return DateTime.now().difference(lastScanAt) < const Duration(seconds: 2);
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}
