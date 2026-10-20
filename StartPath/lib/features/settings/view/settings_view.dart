import 'package:flutter/material.dart';
import '../../../core/services/theme_service.dart';
import '../controller/settings_controller.dart';

class SettingsView extends StatelessWidget {
  final SettingsController controller;

  const SettingsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ThemeTile(controller: controller),
            const SizedBox(height: 12),
            _NotificationSwitches(controller: controller),
            const SizedBox(height: 12),
            const _SupportSection(),
          ],
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final SettingsController controller;

  const _ThemeTile({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeService.instance.themeMode,
        builder: (context, mode, _) {
          final isDark = mode == ThemeMode.dark;
          return SwitchListTile(
            title: const Text('Karanlık Mod (Modern Professional)'),
            subtitle: Text(isDark ? 'Koyu petrol ve antrasit' : 'Fildişi ve adaçayı yeşili'),
            secondary: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
            value: isDark,
            onChanged: (_) => controller.toggleTheme(),
          );
        },
      ),
    );
  }
}

class _NotificationSwitches extends StatelessWidget {
  final SettingsController controller;

  const _NotificationSwitches({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: controller.pushNotificationsEnabled,
            builder: (context, enabled, _) {
              return SwitchListTile(
                title: const Text('Anlık Bildirimler'),
                subtitle: const Text('Mentor ve başvuru güncellemeleri'),
                secondary: const Icon(Icons.notifications_active_outlined),
                value: enabled,
                onChanged: controller.togglePush,
              );
            },
          ),
          const Divider(height: 1),
          ValueListenableBuilder<bool>(
            valueListenable: controller.emailRemindersEnabled,
            builder: (context, enabled, _) {
              return SwitchListTile(
                title: const Text('Hibe Son Gün Hatırlatıcıları'),
                subtitle: const Text('Son başvuru tarihlerini kaçırmayın'),
                secondary: const Icon(Icons.alarm_on_rounded),
                value: enabled,
                onChanged: controller.toggleEmail,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SupportSection extends StatelessWidget {
  const _SupportSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.help_outline_rounded),
            title: const Text('Yardım ve Destek'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Gizlilik ve Hukuki Şartlar'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
