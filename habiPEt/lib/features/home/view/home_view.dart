import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/router/app_router.dart';
import '../../../core/extensions/context_extensions.dart';
import '../widgets/welcome_dialog.dart';
import '../widgets/pet_preview_card.dart';
import '../widgets/habit_summary_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkWelcomeDialog());
  }

  void _checkWelcomeDialog() {
    final homeCtrl = AppScope.of(context).homeController;
    if (!homeCtrl.welcomeDialogShown) {
      homeCtrl.markWelcomeDialogShown();
      final petCtrl = AppScope.of(context).petController;
      final habitCtrl = AppScope.of(context).habitController;

      showDialog(
        context: context,
        builder: (ctx) => WelcomeDialog(
          currentStreak: habitCtrl.maxStreak,
          petName: petCtrl.pet.name,
          recentBadgeTitle: '2. Hafta İstikrarı',
          onDismiss: () => Navigator.of(ctx).pop(),
        ),
      );
    }
  }

  void _feedPet(String foodId) {
    final cupboardCtrl = AppScope.of(context).cupboardController;
    final petCtrl = AppScope.of(context).petController;

    final food = cupboardCtrl.consumeFood(foodId);
    if (food != null) {
      final leveledUp = petCtrl.feedPet(
        satietyBoost: food.satietyBoost,
        expBoost: food.expBoost,
      );

      if (leveledUp) {
        context.showAppSnackBar(
          '🎉 Tebrikler! ${petCtrl.pet.name} Seviye ${petCtrl.pet.level}\'e yükseldi!',
        );
      } else {
        context.showAppSnackBar(
          '${petCtrl.pet.name} afiyetle ${food.name} yedi! (+${food.expBoost} XP)',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final petCtrl = AppScope.of(context).petController;
    final cupboardCtrl = AppScope.of(context).cupboardController;
    final habitCtrl = AppScope.of(context).habitController;
    final badgeCtrl = AppScope.of(context).badgeController;
    final notifCtrl = AppScope.of(context).notificationController;
    final themeCtrl = AppScope.of(context).themeController;

    return ListenableBuilder(
      listenable: Listenable.merge([
        petCtrl,
        cupboardCtrl,
        habitCtrl,
        badgeCtrl,
        notifCtrl,
        themeCtrl,
      ]),
      builder: (context, _) {
        return Scaffold(
          appBar: _HomeAppBar(
            unreadCount: notifCtrl.unreadCount,
            coins: badgeCtrl.totalBadgeCoins,
            isDarkMode: themeCtrl.isDarkMode,
            onToggleTheme: themeCtrl.toggleTheme,
            onGoNotif: () =>
                Navigator.of(context).pushNamed(AppRouter.notificationsRoute),
            onGoMarket: () =>
                Navigator.of(context).pushNamed(AppRouter.marketRoute),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                PetPreviewCard(
                  pet: petCtrl.pet,
                  cupboardItems: cupboardCtrl.items,
                  isCupboardOpen: cupboardCtrl.isCupboardOpen,
                  onToggleCupboard: cupboardCtrl.toggleCupboard,
                  onFeedPet: _feedPet,
                  onGoToMarket: () =>
                      Navigator.of(context).pushNamed(AppRouter.marketRoute),
                  onChangePet: () => Navigator.of(context)
                      .pushNamed(AppRouter.petSelectionRoute),
                ),
                const SizedBox(height: 16),
                HabitSummaryCard(
                  habits: habitCtrl.habits,
                  onToggleHabit: (id) {
                    habitCtrl.toggleHabitCompletion(id, DateTime.now());
                    badgeCtrl.syncProgressWithHabits(
                      maxStreak: habitCtrl.maxStreak,
                      habitCount: habitCtrl.habitCount,
                    );
                  },
                  onAddHabit: () =>
                      Navigator.of(context).pushNamed(AppRouter.addHabitRoute),
                ),
                const SizedBox(height: 16),
                const _DailyMotivationBanner(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int unreadCount;
  final int coins;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onGoNotif;
  final VoidCallback onGoMarket;

  const _HomeAppBar({
    required this.unreadCount,
    required this.coins,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onGoNotif,
    required this.onGoMarket,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        children: [
          Text('🐾', style: TextStyle(fontSize: 22)),
          SizedBox(width: 8),
          Text(
            'habiPEt',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(isDarkMode
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined),
          tooltip: 'Tema Değiştir',
          onPressed: onToggleTheme,
        ),
        _BadgeCoinButton(coins: coins, onTap: onGoMarket),
        _NotificationBellButton(unreadCount: unreadCount, onTap: onGoNotif),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _BadgeCoinButton extends StatelessWidget {
  final int coins;
  final VoidCallback onTap;

  const _BadgeCoinButton({required this.coins, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.accentGold.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accentGold.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            const Text('🪙', style: TextStyle(fontSize: 13)),
            const SizedBox(width: 4),
            Text(
              '$coins',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.accentGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationBellButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationBellButton({
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.notifications_outlined),
          if (unreadCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.darkMint,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DailyMotivationBanner extends StatelessWidget {
  const _DailyMotivationBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkMint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkMint.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded,
              color: AppColors.darkMint, size: 28),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Günün Bilimsel İpucu',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 2),
                Text(
                  'Bir alışkanlığı her gün aynı saatte tekrarlamak, beynin basal ganglion bölgesindeki nöral kalıpları 2 kat daha hızlı güçlendirir.',
                  style: TextStyle(fontSize: 11, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
