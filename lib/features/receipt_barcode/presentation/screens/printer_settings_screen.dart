import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/printer_settings.dart';
import '../providers/receipt_barcode_providers.dart';

class PrinterSettingsScreen extends ConsumerStatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  ConsumerState<PrinterSettingsScreen> createState() =>
      _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends ConsumerState<PrinterSettingsScreen> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _btNameController = TextEditingController();
  final _btAddressController = TextEditingController();
  final _usbVendorController = TextEditingController();
  final _usbProductController = TextEditingController();

  PrinterConnectionType _connectionType = PrinterConnectionType.network;
  ReceiptPaperSize _paperSize = ReceiptPaperSize.mm58;
  bool _autoPrint = false;
  bool _loaded = false;

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _btNameController.dispose();
    _btAddressController.dispose();
    _usbVendorController.dispose();
    _usbProductController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(printerSettingsProvider);
    final controllerState = ref.watch(printerSettingsControllerProvider);

    ref.listen<AsyncValue<void>>(printerSettingsControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (_) {
          if (previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Printer settings saved')),
            );
          }
        },
        error: (error, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString()))),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer settings'),
        actions: [
          TextButton.icon(
            onPressed: controllerState.isLoading ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save'),
          ),
        ],
      ),
      body: settings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (value) {
          _loadOnce(value);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SegmentedButton<PrinterConnectionType>(
                segments: PrinterConnectionType.values
                    .map(
                      (type) =>
                          ButtonSegment(value: type, label: Text(type.label)),
                    )
                    .toList(),
                selected: {_connectionType},
                onSelectionChanged: (selection) {
                  setState(() => _connectionType = selection.first);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ReceiptPaperSize>(
                initialValue: _paperSize,
                decoration: const InputDecoration(
                  labelText: 'Paper size',
                  prefixIcon: Icon(Icons.receipt_long_outlined),
                ),
                items: ReceiptPaperSize.values
                    .map(
                      (size) => DropdownMenuItem(
                        value: size,
                        child: Text(size.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _paperSize = value);
                },
              ),
              const SizedBox(height: 12),
              if (_connectionType == PrinterConnectionType.network) ...[
                TextField(
                  controller: _hostController,
                  decoration: const InputDecoration(
                    labelText: 'Printer IP address',
                    prefixIcon: Icon(Icons.router_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _portController,
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    prefixIcon: Icon(Icons.settings_ethernet_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
              if (_connectionType == PrinterConnectionType.bluetooth) ...[
                TextField(
                  controller: _btNameController,
                  decoration: const InputDecoration(
                    labelText: 'Bluetooth device name',
                    prefixIcon: Icon(Icons.bluetooth_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _btAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Bluetooth address',
                    prefixIcon: Icon(Icons.perm_device_information_outlined),
                  ),
                ),
              ],
              if (_connectionType == PrinterConnectionType.usb) ...[
                TextField(
                  controller: _usbVendorController,
                  decoration: const InputDecoration(
                    labelText: 'USB vendor ID',
                    prefixIcon: Icon(Icons.usb_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _usbProductController,
                  decoration: const InputDecoration(
                    labelText: 'USB product ID',
                    prefixIcon: Icon(Icons.usb_outlined),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Auto print after billing'),
                value: _autoPrint,
                onChanged: (value) => setState(() => _autoPrint = value),
              ),
            ],
          );
        },
      ),
    );
  }

  void _loadOnce(PrinterSettings settings) {
    if (_loaded) return;
    _connectionType = settings.connectionType;
    _paperSize = settings.paperSize;
    _hostController.text = settings.networkHost;
    _portController.text = settings.networkPort.toString();
    _btNameController.text = settings.bluetoothDeviceName;
    _btAddressController.text = settings.bluetoothAddress;
    _usbVendorController.text = settings.usbVendorId;
    _usbProductController.text = settings.usbProductId;
    _autoPrint = settings.autoPrintAfterBilling;
    _loaded = true;
  }

  Future<void> _save() async {
    final settings = PrinterSettings(
      connectionType: _connectionType,
      paperSize: _paperSize,
      networkHost: _hostController.text.trim(),
      networkPort: int.tryParse(_portController.text) ?? 9100,
      bluetoothDeviceName: _btNameController.text.trim(),
      bluetoothAddress: _btAddressController.text.trim(),
      usbVendorId: _usbVendorController.text.trim(),
      usbProductId: _usbProductController.text.trim(),
      autoPrintAfterBilling: _autoPrint,
    );
    await ref.read(printerSettingsControllerProvider.notifier).save(settings);
  }
}
