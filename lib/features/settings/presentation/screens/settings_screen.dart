import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/currency_formatters.dart';
import '../../../billing/domain/entities/billing_enums.dart';
import '../../../receipt_barcode/presentation/screens/printer_settings_screen.dart';
import '../../domain/entities/app_settings.dart';
import '../providers/settings_providers.dart';
import '../widgets/settings_formatters.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(lowStockMonitorProvider);
    final settings = ref.watch(appSettingsProvider);
    final controllerState = ref.watch(settingsControllerProvider);

    ref.listen(settingsControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (result) {
          if (result == null) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Backup ready: ${result.path}')),
          );
        },
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            tooltip: 'Printer settings',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PrinterSettingsScreen()),
            ),
            icon: const Icon(Icons.print_outlined),
          ),
          if (controllerState.isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: settings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (data) => SettingsForm(settings: data),
      ),
    );
  }
}

class SettingsForm extends ConsumerStatefulWidget {
  const SettingsForm({super.key, required this.settings});

  final AppSettings settings;

  @override
  ConsumerState<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();
  final _currencyController = TextEditingController();
  final _taxController = TextEditingController();
  final _lowStockThresholdController = TextEditingController();

  late PaymentMethod _defaultPaymentMethod;
  late TokenResetRule _tokenResetRule;
  late bool _useNepaliTimezone;
  late bool _taxesEnabled;
  late bool _notificationsEnabled;
  late bool _dailySummaryEnabled;

  @override
  void initState() {
    super.initState();
    _sync(widget.settings);
  }

  @override
  void didUpdateWidget(covariant SettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings.updatedAt != widget.settings.updatedAt) {
      _sync(widget.settings);
    }
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _shopAddressController.dispose();
    _currencyController.dispose();
    _taxController.dispose();
    _lowStockThresholdController.dispose();
    super.dispose();
  }

  void _sync(AppSettings settings) {
    _shopNameController.text = settings.shopName;
    _shopAddressController.text = settings.shopAddress;
    _currencyController.text = nepaliRupeeSymbol;
    _taxController.text = settings.taxPercentage.toStringAsFixed(2);
    _lowStockThresholdController.text = settings.lowStockAlertThreshold
        .toString();
    _defaultPaymentMethod = settings.defaultPaymentMethod;
    _tokenResetRule = settings.tokenResetRule;
    _useNepaliTimezone = settings.useNepaliTimezone;
    _taxesEnabled = settings.taxesEnabled;
    _notificationsEnabled = settings.notificationsEnabled;
    _dailySummaryEnabled = settings.dailyLowStockSummaryEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final notificationSummary = ref.watch(notificationSummaryProvider);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          _DashboardIntegrationCard(
            settings: widget.settings,
            notificationSummary: notificationSummary,
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'General settings',
            children: [
              TextFormField(
                controller: _shopNameController,
                decoration: const InputDecoration(
                  labelText: 'Shop name',
                  prefixIcon: Icon(Icons.storefront_outlined),
                ),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _shopAddressController,
                decoration: const InputDecoration(
                  labelText: 'Shop address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _currencyController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Currency',
                  prefixIcon: Icon(Icons.currency_exchange_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _taxController,
                decoration: const InputDecoration(
                  labelText: 'Tax percentage',
                  suffixText: '%',
                  prefixIcon: Icon(Icons.percent_outlined),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: _nonNegativeDecimal,
              ),
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Use Nepali timezone'),
                subtitle: const Text('Reports and summaries use UTC+05:45.'),
                value: _useNepaliTimezone,
                onChanged: (value) {
                  setState(() => _useNepaliTimezone = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Billing settings',
            children: [
              DropdownButtonFormField<PaymentMethod>(
                initialValue: _defaultPaymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Default payment method',
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                ),
                items: PaymentMethod.values
                    .map(
                      (method) => DropdownMenuItem(
                        value: method,
                        child: Text(method.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _defaultPaymentMethod = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<TokenResetRule>(
                initialValue: _tokenResetRule,
                decoration: const InputDecoration(
                  labelText: 'Token reset rule',
                  prefixIcon: Icon(Icons.confirmation_number_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: TokenResetRule.daily,
                    child: Text('Daily'),
                  ),
                  DropdownMenuItem(
                    value: TokenResetRule.never,
                    child: Text('Never'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _tokenResetRule = value);
                  }
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable taxes'),
                value: _taxesEnabled,
                onChanged: (value) {
                  setState(() => _taxesEnabled = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Notification settings',
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable notifications'),
                subtitle: const Text('Local low stock alerts only.'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Daily low stock summary'),
                value: _dailySummaryEnabled,
                onChanged: _notificationsEnabled
                    ? (value) => setState(() => _dailySummaryEnabled = value)
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lowStockThresholdController,
                decoration: const InputDecoration(
                  labelText: 'Global low stock threshold',
                  helperText: 'Use 0 to use each item low stock limit.',
                  prefixIcon: Icon(Icons.notification_important_outlined),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _nonNegativeInt,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _DataSettingsCard(
            isBusy: ref.watch(settingsControllerProvider).isLoading,
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: ref.watch(settingsControllerProvider).isLoading
                ? null
                : _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final settings = widget.settings.copyWith(
      shopName: _shopNameController.text,
      shopAddress: _shopAddressController.text,
      currencySymbol: nepaliRupeeSymbol,
      taxPercentage: double.parse(_taxController.text),
      useNepaliTimezone: _useNepaliTimezone,
      defaultPaymentMethod: _defaultPaymentMethod,
      tokenResetRule: _tokenResetRule,
      taxesEnabled: _taxesEnabled,
      notificationsEnabled: _notificationsEnabled,
      dailyLowStockSummaryEnabled: _dailySummaryEnabled,
      lowStockAlertThreshold: int.parse(_lowStockThresholdController.text),
      updatedAt: DateTime.now(),
    );
    await ref.read(settingsControllerProvider.notifier).saveSettings(settings);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Settings saved')));
  }

  String? _required(String? value) {
    return value == null || value.trim().isEmpty ? 'Required' : null;
  }

  String? _nonNegativeDecimal(String? value) {
    final parsed = double.tryParse(value ?? '');
    if (parsed == null) {
      return 'Enter a valid number';
    }
    return parsed < 0 ? 'Cannot be below 0' : null;
  }

  String? _nonNegativeInt(String? value) {
    final parsed = int.tryParse(value ?? '');
    if (parsed == null) {
      return 'Enter a valid number';
    }
    return parsed < 0 ? 'Cannot be below 0' : null;
  }
}

class _DashboardIntegrationCard extends StatelessWidget {
  const _DashboardIntegrationCard({
    required this.settings,
    required this.notificationSummary,
  });

  final AppSettings settings;
  final AsyncValue<dynamic> notificationSummary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _MetricTile(
                  icon: Icons.warning_amber_outlined,
                  label: 'Low stock',
                  value: notificationSummary.maybeWhen(
                    data: (summary) => summary.lowStockItems.length.toString(),
                    orElse: () => '...',
                  ),
                ),
                _MetricTile(
                  icon: Icons.notifications_active_outlined,
                  label: 'Notifications',
                  value: settings.notificationsEnabled ? 'On' : 'Off',
                ),
                _MetricTile(
                  icon: Icons.backup_outlined,
                  label: 'Latest backup',
                  value: settingsDate(settings.latestBackupAt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double tileWidth = constraints.maxWidth < 420
            ? constraints.maxWidth
            : 220.0;
        return SizedBox(
          width: tileWidth,
          child: Row(
            children: [
              CircleAvatar(child: Icon(icon)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.labelMedium),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DataSettingsCard extends ConsumerWidget {
  const _DataSettingsCard({required this.isBusy});

  final bool isBusy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SectionCard(
      title: 'Data settings',
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: isBusy
                  ? null
                  : () => ref
                        .read(settingsControllerProvider.notifier)
                        .exportBackup(),
              icon: const Icon(Icons.backup_outlined),
              label: const Text('Backup database'),
            ),
            OutlinedButton.icon(
              onPressed: isBusy ? null : () => _confirmRestore(context, ref),
              icon: const Icon(Icons.restore_outlined),
              label: const Text('Restore database'),
            ),
            OutlinedButton.icon(
              onPressed: isBusy ? null : () => _confirmClear(context, ref),
              icon: const Icon(Icons.delete_forever_outlined),
              label: const Text('Clear all data'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _confirmRestore(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore backup'),
        content: const Text(
          'Restoring a backup will replace local inventory, orders, expenses, settings, and notification history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Choose file'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await ref.read(settingsControllerProvider.notifier).pickAndRestoreBackup();
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all data'),
        content: const Text(
          'This removes local inventory, billing orders, expenses, token history, notification state, and saved settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(settingsControllerProvider.notifier).clearAllData();
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
