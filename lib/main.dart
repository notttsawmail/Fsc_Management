import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/billing/presentation/screens/billing_screen.dart';
import 'features/inventory/domain/entities/inventory_item.dart';
import 'features/inventory/presentation/screens/add_edit_inventory_item_screen.dart';
import 'features/inventory/presentation/screens/inventory_list_screen.dart';
import 'features/reports/presentation/screens/reports_screen.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/settings/data/services/local_notification_service.dart';
import 'features/settings/presentation/providers/settings_providers.dart';
import 'features/settings/presentation/screens/settings_screen.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.initialize(onPayload: _handleNotificationTap);
  final launchDetails = await LocalNotificationService.launchDetails();
  final initialPayload = launchDetails?.didNotificationLaunchApp == true
      ? launchDetails?.notificationResponse?.payload
      : null;
  runApp(ProviderScope(child: MainApp(initialPayload: initialPayload)));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, this.initialPayload});

  final String? initialPayload;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'FSC Inventory',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFF8FAFC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
      home: MainShell(initialPayload: initialPayload),
    );
  }
}

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, this.initialPayload});

  final String? initialPayload;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final payload = widget.initialPayload;
      if (payload != null && payload.isNotEmpty) {
        _handleNotificationTap(payload);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(lowStockMonitorProvider);
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          BillingScreen(),
          InventoryListScreen(),
          ReportsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined),
            selectedIcon: Icon(Icons.point_of_sale),
            label: 'Billing',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

Future<void> _handleNotificationTap(String payload) async {
  final navigator = appNavigatorKey.currentState;
  if (navigator == null) {
    return;
  }

  if (payload.startsWith('inventory:')) {
    final id = int.tryParse(payload.substring('inventory:'.length));
    if (id == null) {
      return;
    }
    final dataSource = await SettingsLocalDataSource.open();
    InventoryItem? item;
    for (final candidate in await dataSource.getInventoryItems()) {
      if (candidate.id == id) {
        item = candidate.toEntity();
        break;
      }
    }
    if (item == null) {
      return;
    }
    await navigator.push(
      MaterialPageRoute(builder: (_) => AddEditInventoryItemScreen(item: item)),
    );
    return;
  }

  if (payload.startsWith('settings:')) {
    await navigator.push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }
}
