import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/extensions/context_extensions.dart';
import '../widgets/settings_tile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hesabı Kapat & Verileri Sıfırla'),
        content: const Text(
          'Tüm alışkanlıkların, evcil hayvanının gelişimi ve kazandığın rozetler kalıcı olarak silinecektir. Devam etmek istiyor musun?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.showAppSnackBar('Hesabınız başarıyla kapatıldı.');
            },
            child: const Text('Hesabımı Kapat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeCtrl = AppScope.of(context).themeController;
    final profileCtrl = AppScope.of(context).profileController;

    return ListenableBuilder(
      listenable: Listenable.merge([themeCtrl, profileCtrl]),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Ayarlar')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _ThemeSettingsCard(
                  isDarkMode: themeCtrl.isDarkMode,
                  onToggle: themeCtrl.toggleTheme,
                ),
                const SizedBox(height: 16),
                _NotificationPreferencesCard(profileCtrl: profileCtrl),
                const SizedBox(height: 24),
                _AccountDangerCard(
                  onDeleteAccount: () => _showDeleteAccountDialog(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ThemeSettingsCard extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const _ThemeSettingsCard({required this.isDarkMode, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SettingsTile(
            icon: Icons.dark_mode_rounded,
            title: 'Koyu Tema (Gece Ormanı)',
            subtitle: 'Dark navy ve mint yeşili vurgular',
            trailing: Switch(
              value: isDarkMode,
              onChanged: (_) => onToggle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationPreferencesCard extends StatelessWidget {
  final dynamic profileCtrl;

  const _NotificationPreferencesCard({required this.profileCtrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SettingsTile(
            icon: Icons.notifications_active_outlined,
            title: 'Günlük Hatırlatıcılar',
            subtitle: 'Alışkanlıklarını aksatmaman için anımsatıcı',
            trailing: Switch(
              value: profileCtrl.dailyReminders,
              onChanged: (v) => profileCtrl.toggleDailyReminders(v),
            ),
          ),
          const Divider(),
          SettingsTile(
            icon: Icons.volume_up_outlined,
            title: 'Ses Efektleri',
            subtitle: 'Besleme ve ödül sesleri',
            trailing: Switch(
              value: profileCtrl.soundEnabled,
              onChanged: (v) => profileCtrl.toggleSound(v),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountDangerCard extends StatelessWidget {
  final VoidCallback onDeleteAccount;

  const _AccountDangerCard({required this.onDeleteAccount});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.error.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: SettingsTile(
        icon: Icons.delete_forever_rounded,
        title: 'Hesabı Kapat & Sıfırla',
        subtitle: 'Tüm verilerini ve ilerlemeni kalıcı sil',
        iconColor: AppColors.error,
        textColor: AppColors.error,
        onTap: onDeleteAccount,
      ),
    );
  }
}
