enum PrinterConnectionType { network, bluetooth, usb }

enum ReceiptPaperSize { mm58, mm80 }

class PrinterSettings {
  const PrinterSettings({
    required this.connectionType,
    required this.paperSize,
    required this.networkHost,
    required this.networkPort,
    required this.bluetoothDeviceName,
    required this.bluetoothAddress,
    required this.usbVendorId,
    required this.usbProductId,
    required this.autoPrintAfterBilling,
  });

  factory PrinterSettings.defaults() {
    return const PrinterSettings(
      connectionType: PrinterConnectionType.network,
      paperSize: ReceiptPaperSize.mm58,
      networkHost: '192.168.1.100',
      networkPort: 9100,
      bluetoothDeviceName: '',
      bluetoothAddress: '',
      usbVendorId: '',
      usbProductId: '',
      autoPrintAfterBilling: false,
    );
  }

  final PrinterConnectionType connectionType;
  final ReceiptPaperSize paperSize;
  final String networkHost;
  final int networkPort;
  final String bluetoothDeviceName;
  final String bluetoothAddress;
  final String usbVendorId;
  final String usbProductId;
  final bool autoPrintAfterBilling;

  PrinterSettings copyWith({
    PrinterConnectionType? connectionType,
    ReceiptPaperSize? paperSize,
    String? networkHost,
    int? networkPort,
    String? bluetoothDeviceName,
    String? bluetoothAddress,
    String? usbVendorId,
    String? usbProductId,
    bool? autoPrintAfterBilling,
  }) {
    return PrinterSettings(
      connectionType: connectionType ?? this.connectionType,
      paperSize: paperSize ?? this.paperSize,
      networkHost: networkHost ?? this.networkHost,
      networkPort: networkPort ?? this.networkPort,
      bluetoothDeviceName: bluetoothDeviceName ?? this.bluetoothDeviceName,
      bluetoothAddress: bluetoothAddress ?? this.bluetoothAddress,
      usbVendorId: usbVendorId ?? this.usbVendorId,
      usbProductId: usbProductId ?? this.usbProductId,
      autoPrintAfterBilling:
          autoPrintAfterBilling ?? this.autoPrintAfterBilling,
    );
  }
}

extension PrinterConnectionTypeLabel on PrinterConnectionType {
  String get label {
    switch (this) {
      case PrinterConnectionType.network:
        return 'Network thermal';
      case PrinterConnectionType.bluetooth:
        return 'Bluetooth thermal';
      case PrinterConnectionType.usb:
        return 'USB thermal';
    }
  }
}

extension ReceiptPaperSizeLabel on ReceiptPaperSize {
  String get label {
    switch (this) {
      case ReceiptPaperSize.mm58:
        return '58 mm';
      case ReceiptPaperSize.mm80:
        return '80 mm';
    }
  }
}
