import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../billing/data/models/billing_order_model.dart';
import '../../../expenses/data/models/expense_model.dart';
import '../../../inventory/data/models/inventory_item_model.dart';
import '../models/app_settings_model.dart';
import '../models/low_stock_notification_model.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource._(this._isar);

  final Isar _isar;

  static Future<SettingsLocalDataSource> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        InventoryItemModelSchema,
        BillingOrderModelSchema,
        ExpenseModelSchema,
        AppSettingsModelSchema,
        LowStockNotificationModelSchema,
      ],
      directory: dir.path,
      name: 'fsc_inventory',
    );
    return SettingsLocalDataSource._(isar);
  }

  Stream<AppSettingsModel> watchSettings() async* {
    await ensureSettings();
    yield* _isar.appSettingsModels
        .watchObject(1, fireImmediately: true)
        .map((settings) => settings ?? AppSettingsModel.defaults());
  }

  Future<AppSettingsModel> getSettings() async {
    await ensureSettings();
    return await _isar.appSettingsModels.get(1) ?? AppSettingsModel.defaults();
  }

  Future<void> ensureSettings() async {
    final existing = await _isar.appSettingsModels.get(1);
    if (existing != null) {
      return;
    }
    await _isar.writeTxn(
      () => _isar.appSettingsModels.put(AppSettingsModel.defaults()),
    );
  }

  Future<void> saveSettings(AppSettingsModel settings) {
    return _isar.writeTxn(() => _isar.appSettingsModels.put(settings..id = 1));
  }

  Stream<List<InventoryItemModel>> watchInventoryItems() {
    return _isar.inventoryItemModels.where().watch(fireImmediately: true);
  }

  Future<List<InventoryItemModel>> getInventoryItems() {
    return _isar.inventoryItemModels.where().sortByName().findAll();
  }

  Future<List<BillingOrderModel>> getOrders() {
    return _isar.billingOrderModels.where().sortByCreatedAtDesc().findAll();
  }

  Future<List<ExpenseModel>> getExpenses() {
    return _isar.expenseModels.where().sortByExpenseDateDesc().findAll();
  }

  Future<List<LowStockNotificationModel>> getNotificationStates() {
    return _isar.lowStockNotificationModels.where().findAll();
  }

  Future<LowStockNotificationModel?> getNotificationState(int inventoryItemId) {
    return _isar.lowStockNotificationModels
        .filter()
        .inventoryItemIdEqualTo(inventoryItemId)
        .findFirst();
  }

  Future<void> putNotificationState(LowStockNotificationModel state) {
    return _isar.writeTxn(() => _isar.lowStockNotificationModels.put(state));
  }

  Future<void> deleteNotificationState(int inventoryItemId) async {
    await _isar.writeTxn(() async {
      final state = await getNotificationState(inventoryItemId);
      if (state != null) {
        await _isar.lowStockNotificationModels.delete(state.id);
      }
    });
  }

  Future<String> exportBackup() async {
    await ensureSettings();
    final createdAt = DateTime.now();
    final data = {
      'format': 'fsc_management_backup',
      'version': 1,
      'createdAt': createdAt.toIso8601String(),
      'inventoryItems': (await getInventoryItems())
          .map(_inventoryToJson)
          .toList(),
      'orders': (await getOrders()).map(_orderToJson).toList(),
      'expenses': (await getExpenses()).map(_expenseToJson).toList(),
      'settings': (await _isar.appSettingsModels.where().findAll())
          .map((settings) => settings.toJson())
          .toList(),
      'notificationStates': (await getNotificationStates())
          .map((state) => state.toJson())
          .toList(),
      'reports': <Map<String, dynamic>>[],
      'tokenHistory': (await getOrders())
          .map(
            (order) => {
              'orderId': order.orderId,
              'tokenNumber': order.tokenNumber,
              'nepaliDate': order.nepaliDate,
              'createdAt': order.createdAt.toIso8601String(),
              'status': order.orderStatus,
            },
          )
          .toList(),
    };

    final documentsDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(path.join(documentsDir.path, 'backups'));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    final filePath = path.join(
      backupDir.path,
      'fsc_backup_${createdAt.millisecondsSinceEpoch}.json',
    );
    await File(filePath).writeAsString(jsonEncode(data), flush: true);
    return filePath;
  }

  Future<BackupImportCounts> restoreBackup(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw ArgumentError('Backup file does not exist.');
    }

    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! Map<String, dynamic>) {
      throw FormatException('Backup file is not valid JSON.');
    }
    _validateBackup(decoded);

    final inventoryItems = (decoded['inventoryItems'] as List)
        .cast<Map<String, dynamic>>()
        .map(_inventoryFromJson)
        .toList();
    final orders = (decoded['orders'] as List)
        .cast<Map<String, dynamic>>()
        .map(_orderFromJson)
        .toList();
    final expenses = (decoded['expenses'] as List? ?? const [])
        .cast<Map<String, dynamic>>()
        .map(_expenseFromJson)
        .toList();
    final settings = (decoded['settings'] as List)
        .cast<Map<String, dynamic>>()
        .map(AppSettingsModel.fromJson)
        .toList();
    final states = (decoded['notificationStates'] as List? ?? const [])
        .cast<Map<String, dynamic>>()
        .map(LowStockNotificationModel.fromJson)
        .where((state) => state.inventoryItemId > 0)
        .toList();

    await _isar.writeTxn(() async {
      await _isar.lowStockNotificationModels.clear();
      await _isar.expenseModels.clear();
      await _isar.billingOrderModels.clear();
      await _isar.inventoryItemModels.clear();
      await _isar.appSettingsModels.clear();
      await _isar.inventoryItemModels.putAll(inventoryItems);
      await _isar.billingOrderModels.putAll(orders);
      await _isar.expenseModels.putAll(expenses);
      await _isar.appSettingsModels.putAll(
        settings.isEmpty ? [AppSettingsModel.defaults()] : settings,
      );
      await _isar.lowStockNotificationModels.putAll(states);
    });

    return BackupImportCounts(
      inventoryCount: inventoryItems.length,
      orderCount: orders.length,
      expenseCount: expenses.length,
      settingsCount: settings.isEmpty ? 1 : settings.length,
    );
  }

  Future<void> clearAllData() async {
    await _isar.writeTxn(() async {
      await _isar.lowStockNotificationModels.clear();
      await _isar.expenseModels.clear();
      await _isar.billingOrderModels.clear();
      await _isar.inventoryItemModels.clear();
      await _isar.appSettingsModels.clear();
      await _isar.appSettingsModels.put(AppSettingsModel.defaults());
    });
  }

  void _validateBackup(Map<String, dynamic> data) {
    if (data['format'] != 'fsc_management_backup') {
      throw FormatException('This is not an FSC backup file.');
    }
    if (data['version'] != 1) {
      throw FormatException('Unsupported backup version.');
    }
    if (data['inventoryItems'] is! List ||
        data['orders'] is! List ||
        data['settings'] is! List) {
      throw FormatException('Backup file is missing required data.');
    }
  }

  Map<String, dynamic> _inventoryToJson(InventoryItemModel item) {
    return {
      'id': item.id,
      'name': item.name,
      'itemCode': item.itemCode,
      'category': item.category,
      'price': item.price,
      'quantity': item.quantity,
      'lowStockLimit': item.lowStockLimit,
      'imagePath': item.imagePath,
      'isTrackableInventory': item.isTrackableInventory,
      'createdAt': item.createdAt.toIso8601String(),
      'updatedAt': item.updatedAt.toIso8601String(),
    };
  }

  InventoryItemModel _inventoryFromJson(Map<String, dynamic> json) {
    return InventoryItemModel()
      ..id = (json['id'] as num?)?.toInt() ?? Isar.autoIncrement
      ..name = json['name'] as String? ?? ''
      ..itemCode = json['itemCode'] as String? ?? ''
      ..category = json['category'] as String? ?? ''
      ..price = (json['price'] as num?)?.toDouble() ?? 0
      ..quantity = (json['quantity'] as num?)?.toInt() ?? 0
      ..lowStockLimit = (json['lowStockLimit'] as num?)?.toInt() ?? 0
      ..imagePath = json['imagePath'] as String?
      ..isTrackableInventory = json['isTrackableInventory'] as bool? ?? true
      ..createdAt =
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now()
      ..updatedAt =
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now();
  }

  Map<String, dynamic> _orderToJson(BillingOrderModel order) {
    return {
      'id': order.id,
      'orderId': order.orderId,
      'tokenNumber': order.tokenNumber,
      'nepaliDate': order.nepaliDate,
      'items': order.items.map(_orderItemToJson).toList(),
      'subtotal': order.subtotal,
      'totalAmount': order.totalAmount,
      'paymentMethod': order.paymentMethod,
      'paymentStatus': order.paymentStatus,
      'orderStatus': order.orderStatus,
      'createdAt': order.createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _orderItemToJson(BillingOrderItemModel item) {
    return {
      'inventoryItemId': item.inventoryItemId,
      'itemName': item.itemName,
      'itemCode': item.itemCode,
      'unitPrice': item.unitPrice,
      'quantity': item.quantity,
      'lineTotal': item.lineTotal,
    };
  }

  BillingOrderModel _orderFromJson(Map<String, dynamic> json) {
    return BillingOrderModel()
      ..id = (json['id'] as num?)?.toInt() ?? Isar.autoIncrement
      ..orderId = json['orderId'] as String? ?? ''
      ..tokenNumber = (json['tokenNumber'] as num?)?.toInt() ?? 0
      ..nepaliDate = json['nepaliDate'] as String? ?? ''
      ..items = (json['items'] as List? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(_orderItemFromJson)
          .toList()
      ..subtotal = (json['subtotal'] as num?)?.toDouble() ?? 0
      ..totalAmount = (json['totalAmount'] as num?)?.toDouble() ?? 0
      ..paymentMethod = json['paymentMethod'] as String? ?? 'cash'
      ..paymentStatus = json['paymentStatus'] as String? ?? 'paid'
      ..orderStatus = json['orderStatus'] as String? ?? 'paid'
      ..createdAt =
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now();
  }

  BillingOrderItemModel _orderItemFromJson(Map<String, dynamic> json) {
    return BillingOrderItemModel()
      ..inventoryItemId = (json['inventoryItemId'] as num?)?.toInt() ?? 0
      ..itemName = json['itemName'] as String? ?? ''
      ..itemCode = json['itemCode'] as String? ?? ''
      ..unitPrice = (json['unitPrice'] as num?)?.toDouble() ?? 0
      ..quantity = (json['quantity'] as num?)?.toInt() ?? 0
      ..lineTotal = (json['lineTotal'] as num?)?.toDouble() ?? 0;
  }

  Map<String, dynamic> _expenseToJson(ExpenseModel expense) {
    return {
      'id': expense.id,
      'title': expense.title,
      'category': expense.category,
      'amount': expense.amount,
      'description': expense.description,
      'paymentMethod': expense.paymentMethod,
      'expenseDate': expense.expenseDate.toIso8601String(),
      'createdAt': expense.createdAt.toIso8601String(),
    };
  }

  ExpenseModel _expenseFromJson(Map<String, dynamic> json) {
    return ExpenseModel()
      ..id = (json['id'] as num?)?.toInt() ?? Isar.autoIncrement
      ..title = json['title'] as String? ?? ''
      ..category = json['category'] as String? ?? 'miscellaneous'
      ..amount = (json['amount'] as num?)?.toDouble() ?? 0
      ..description = json['description'] as String? ?? ''
      ..paymentMethod = json['paymentMethod'] as String? ?? 'cash'
      ..expenseDate =
          DateTime.tryParse(json['expenseDate'] as String? ?? '') ??
          DateTime.now()
      ..createdAt =
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now();
  }
}

class BackupImportCounts {
  const BackupImportCounts({
    required this.inventoryCount,
    required this.orderCount,
    required this.expenseCount,
    required this.settingsCount,
  });

  final int inventoryCount;
  final int orderCount;
  final int expenseCount;
  final int settingsCount;
}
