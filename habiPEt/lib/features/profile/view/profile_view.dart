import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/router/app_router.dart';
import '../widgets/profile_stat_card.dart';
import '../widgets/settings_tile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = AppScope.of(context).authController;
    final habitCtrl = AppScope.of(context).habitController;
    final badgeCtrl = AppScope.of(context).badgeController;
    final themeCtrl = AppScope.of(context).themeController;

    return ListenableBuilder(
      listenable: Listenable.merge([authCtrl, habitCtrl, badgeCtrl, themeCtrl]),
      builder: (context, _) {
        final user = authCtrl.currentUser;

        return Scaffold(
          appBar: AppBar(title: const Text('Profil & Hesap')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                _ProfileUserHeader(
                  name: user?.name ?? 'Kullanıcı',
                  email: user?.email ?? 'misafir@habipet.app',
                  days: user?.daysSinceJoined ?? 16,
                ),
                const SizedBox(height: 20),
                _ProfileStatsGrid(
                  maxStreak: habitCtrl.maxStreak,
                  badgeCount: badgeCtrl.unlockedCount,
                  habitCount: habitCtrl.habitCount,
                  coins: badgeCtrl.totalBadgeCoins,
                ),
                const SizedBox(height: 24),
                _ProfileMenuCard(
                  isDarkMode: themeCtrl.isDarkMode,
                  onToggleTheme: themeCtrl.toggleTheme,
                  onGoSettings: () =>
                      Navigator.of(context).pushNamed(AppRouter.settingsRoute),
                  onGoHelp: () =>
                      Navigator.of(context).pushNamed(AppRouter.helpSupportRoute),
                  onGoPet: () => Navigator.of(context)
                      .pushNamed(AppRouter.petSelectionRoute),
                  onLogout: () {
                    authCtrl.logout();
                    Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileUserHeader extends StatelessWidget {
  final String name;
  final String email;
  final int days;

  const _ProfileUserHeader({
    required this.name,
    required this.email,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.darkMint, AppColors.secondary],
                ),
              ),
              alignment: Alignment.center,
              child: const Text('🌿', style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkMint.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$days gündür birlikteyiz',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkMint,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStatsGrid extends StatelessWidget {
  final int maxStreak;
  final int badgeCount;
  final int habitCount;
  final int coins;

  const _ProfileStatsGrid({
    required this.maxStreak,
    required this.badgeCount,
    required this.habitCount,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ProfileStatCard(
            title: 'En Uzun Seri',
            value: '$maxStreak Gün',
            emoji: '🔥',
            color: AppColors.accentOrange,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ProfileStatCard(
            title: 'Kazanılan Rozet',
            value: '$badgeCount Adet',
            emoji: '🎖️',
            color: AppColors.accentPurple,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ProfileStatCard(
            title: 'Rozet Cüzdanı',
            value: '$coins',
            emoji: '🪙',
            color: AppColors.accentGold,
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuCard extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onGoSettings;
  final VoidCallback onGoHelp;
  final VoidCallback onGoPet;
  final VoidCallback onLogout;

  const _ProfileMenuCard({
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onGoSettings,
    required this.onGoHelp,
    required this.onGoPet,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SettingsTile(
            icon: Icons.palette_outlined,
            title: 'Tema (Koyu / Aydınlık)',
            subtitle: isDarkMode ? 'Sage & Cream Koyu' : 'Sage & Cream Açık',
            trailing: Switch(
              value: isDarkMode,
              onChanged: (_) => onToggleTheme(),
            ),
          ),
          const Divider(),
          SettingsTile(
            icon: Icons.pets_outlined,
            title: 'Evcil Hayvanımı Yönet',
            subtitle: 'Tür ve isim değiştir',
            onTap: onGoPet,
          ),
          const Divider(),
          SettingsTile(
            icon: Icons.settings_outlined,
            title: 'Ayarlar',
            subtitle: 'Bildirimler ve tercihler',
            onTap: onGoSettings,
          ),
          const Divider(),
          SettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Yardım ve Destek',
            subtitle: 'SSS ve 21 gün kuralı rehberi',
            onTap: onGoHelp,
          ),
          const Divider(),
          SettingsTile(
            icon: Icons.logout_rounded,
            title: 'Çıkış Yap',
            iconColor: AppColors.error,
            textColor: AppColors.error,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
