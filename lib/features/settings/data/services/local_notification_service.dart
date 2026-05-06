import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../inventory/domain/entities/inventory_item.dart';

class LocalNotificationService {
  const LocalNotificationService();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize({
    required void Function(String payload) onPayload,
  }) async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
      linux: LinuxInitializationSettings(defaultActionName: 'Open'),
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          onPayload(payload);
        }
      },
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<NotificationAppLaunchDetails?> launchDetails() {
    return _plugin.getNotificationAppLaunchDetails();
  }

  Future<void> showLowStock(InventoryItem item, int threshold) {
    return _plugin.show(
      item.id,
      'Low stock warning',
      '${item.name} stock is below $threshold',
      _details(),
      payload: 'inventory:${item.id}',
    );
  }

  Future<void> showDailyLowStockSummary({
    required int lowStockCount,
    required int outOfStockCount,
  }) {
    return _plugin.show(
      900001,
      'Daily stock summary',
      '$lowStockCount low stock, $outOfStockCount out of stock',
      _details(),
      payload: 'settings:notifications',
    );
  }

  NotificationDetails _details() {
    const android = AndroidNotificationDetails(
      'low_stock_alerts',
      'Low stock alerts',
      channelDescription: 'Inventory low stock warnings and daily summaries',
      importance: Importance.high,
      priority: Priority.high,
    );
    const linux = LinuxNotificationDetails();
    const darwin = DarwinNotificationDetails();
    return const NotificationDetails(
      android: android,
      iOS: darwin,
      macOS: darwin,
      linux: linux,
    );
  }
}
