import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/printer_settings.dart';

class PrinterSettingsLocalDataSource {
  const PrinterSettingsLocalDataSource();

  Future<PrinterSettings> read() async {
    final file = await _settingsFile();
    if (!await file.exists()) {
      return PrinterSettings.defaults();
    }
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return PrinterSettings(
      connectionType: PrinterConnectionType.values.firstWhere(
        (value) => value.name == json['connectionType'],
        orElse: () => PrinterConnectionType.network,
      ),
      paperSize: ReceiptPaperSize.values.firstWhere(
        (value) => value.name == json['paperSize'],
        orElse: () => ReceiptPaperSize.mm58,
      ),
      networkHost: json['networkHost'] as String? ?? '192.168.1.100',
      networkPort: (json['networkPort'] as num?)?.toInt() ?? 9100,
      bluetoothDeviceName: json['bluetoothDeviceName'] as String? ?? '',
      bluetoothAddress: json['bluetoothAddress'] as String? ?? '',
      usbVendorId: json['usbVendorId'] as String? ?? '',
      usbProductId: json['usbProductId'] as String? ?? '',
      autoPrintAfterBilling: json['autoPrintAfterBilling'] as bool? ?? false,
    );
  }

  Future<void> write(PrinterSettings settings) async {
    final file = await _settingsFile();
    await file.parent.create(recursive: true);
    await file.writeAsString(
      jsonEncode({
        'connectionType': settings.connectionType.name,
        'paperSize': settings.paperSize.name,
        'networkHost': settings.networkHost,
        'networkPort': settings.networkPort,
        'bluetoothDeviceName': settings.bluetoothDeviceName,
        'bluetoothAddress': settings.bluetoothAddress,
        'usbVendorId': settings.usbVendorId,
        'usbProductId': settings.usbProductId,
        'autoPrintAfterBilling': settings.autoPrintAfterBilling,
      }),
    );
  }

  Future<File> _settingsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(path.join(dir.path, 'printer_settings.json'));
  }
}
