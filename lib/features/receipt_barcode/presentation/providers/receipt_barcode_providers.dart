import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../billing/domain/entities/billing_order.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../data/datasources/printer_settings_local_data_source.dart';
import '../../data/datasources/receipt_barcode_local_data_source.dart';
import '../../data/repositories/receipt_barcode_repository_impl.dart';
import '../../data/services/receipt_pdf_service.dart';
import '../../data/services/thermal_printer_service.dart';
import '../../domain/entities/printer_settings.dart';
import '../../domain/repositories/receipt_barcode_repository.dart';
import '../../domain/usecases/watch_receipt_orders.dart';

final receiptBarcodeLocalDataSourceProvider =
    FutureProvider<ReceiptBarcodeLocalDataSource>((ref) {
      return ReceiptBarcodeLocalDataSource.open();
    });

final printerSettingsLocalDataSourceProvider =
    Provider<PrinterSettingsLocalDataSource>((ref) {
      return const PrinterSettingsLocalDataSource();
    });

final receiptBarcodeRepositoryProvider =
    FutureProvider<ReceiptBarcodeRepository>((ref) async {
      final localDataSource = await ref.watch(
        receiptBarcodeLocalDataSourceProvider.future,
      );
      return ReceiptBarcodeRepositoryImpl(
        localDataSource: localDataSource,
        printerSettingsDataSource: ref.watch(
          printerSettingsLocalDataSourceProvider,
        ),
      );
    });

final receiptOrdersProvider = StreamProvider.autoDispose<List<BillingOrder>>((
  ref,
) async* {
  final repository = await ref.watch(receiptBarcodeRepositoryProvider.future);
  yield* WatchReceiptOrders(repository)();
});

final printerSettingsProvider = FutureProvider<PrinterSettings>((ref) async {
  final repository = await ref.watch(receiptBarcodeRepositoryProvider.future);
  return repository.getPrinterSettings();
});

final receiptPdfServiceProvider = Provider<ReceiptPdfService>((ref) {
  return const ReceiptPdfService();
});

final thermalPrinterServiceProvider = Provider<ThermalPrinterService>((ref) {
  return const ThermalPrinterService();
});

final printerSettingsControllerProvider =
    StateNotifierProvider<PrinterSettingsController, AsyncValue<void>>((ref) {
      return PrinterSettingsController(ref);
    });

final receiptActionControllerProvider =
    StateNotifierProvider<ReceiptActionController, AsyncValue<String?>>((ref) {
      return ReceiptActionController(ref);
    });

class PrinterSettingsController extends StateNotifier<AsyncValue<void>> {
  PrinterSettingsController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> save(PrinterSettings settings) async {
    state = const AsyncLoading();
    try {
      final repository = await _ref.read(
        receiptBarcodeRepositoryProvider.future,
      );
      await repository.savePrinterSettings(settings);
      _ref.invalidate(printerSettingsProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

class ReceiptActionController extends StateNotifier<AsyncValue<String?>> {
  ReceiptActionController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<AppSettings> get _settings async {
    return _ref.read(appSettingsProvider.future);
  }

  Future<PrinterSettings> get _printerSettings async {
    final repository = await _ref.read(receiptBarcodeRepositoryProvider.future);
    return repository.getPrinterSettings();
  }

  Future<void> printPdf(BillingOrder order) async {
    await _run(() async {
      await _ref
          .read(receiptPdfServiceProvider)
          .printPdf(order: order, settings: await _settings);
      return null;
    });
  }

  Future<void> printThermal(BillingOrder order) async {
    await _run(() async {
      final message = await _ref
          .read(thermalPrinterServiceProvider)
          .printReceipt(
            order: order,
            appSettings: await _settings,
            printerSettings: await _printerSettings,
          );
      return message;
    });
  }

  Future<String> savePdf(BillingOrder order) async {
    final path = await _run(() async {
      return _ref
          .read(receiptPdfServiceProvider)
          .savePdf(order: order, settings: await _settings);
    });
    return path!;
  }

  Future<void> sharePdf(BillingOrder order) async {
    await _run(() async {
      await _ref
          .read(receiptPdfServiceProvider)
          .sharePdf(order: order, settings: await _settings);
      return null;
    });
  }

  Future<String?> _run(Future<String?> Function() action) async {
    state = const AsyncLoading();
    try {
      final result = await action();
      state = AsyncData(result);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
