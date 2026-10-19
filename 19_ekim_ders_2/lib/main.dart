import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/badges/controllers/badge_controller.dart';
import 'features/badges/view/badge_view.dart';
import 'features/water_tracker/controllers/water_tracker_controller.dart';
import 'features/water_tracker/view/water_tracker_view.dart';
import 'features/workout/controllers/workout_controller.dart';
import 'features/workout/view/workout_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SusadimApp());
}

/// Susadım v1 - Ana Uygulama Kökü (Dinamik Tema Destekli)
class SusadimApp extends StatefulWidget {
  const SusadimApp({super.key});

  @override
  State<SusadimApp> createState() => _SusadimAppState();
}

class _SusadimAppState extends State<SusadimApp> {
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController.themeMode,
      builder: (context, activeMode, _) {
        return MaterialApp(
          title: 'Susadım v1',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: activeMode,
          home: SusadimHomePage(themeController: _themeController),
        );
      },
    );
  }
}

/// Ana Sayfa ve Sekme Yönetimi
class SusadimHomePage extends StatefulWidget {
  final ThemeController themeController;

  const SusadimHomePage({
    super.key,
    required this.themeController,
  });

  @override
  State<SusadimHomePage> createState() => _SusadimHomePageState();
}

class _SusadimHomePageState extends State<SusadimHomePage> {
  late final BadgeController _badgeController;
  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;
  final ValueNotifier<int> _currentTab = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _badgeController = BadgeController();
    _waterController = WaterTrackerController(badgeController: _badgeController);
    _workoutController = WorkoutController(badgeController: _badgeController);

    _badgeController.lastUnlockedBadgeNotification.addListener(_onBadgeUnlocked);
  }

  void _onBadgeUnlocked() {
    final title = _badgeController.lastUnlockedBadgeNotification.value;
    if (title != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.military_tech_rounded, color: AppColors.goldOf(context)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Tebrikler! Yeni Rozet: $title',
                  style: TextStyle(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      _badgeController.clearNotification();
    }
  }

  @override
  void dispose() {
    _badgeController.lastUnlockedBadgeNotification.removeListener(_onBadgeUnlocked);
    _badgeController.dispose();
    _waterController.dispose();
    _workoutController.dispose();
    _currentTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SusadimAppBar(themeController: widget.themeController),
      body: ValueListenableBuilder<int>(
        valueListenable: _currentTab,
        builder: (context, activeIndex, _) {
          return IndexedStack(
            index: activeIndex,
            children: [
              WaterTrackerView(controller: _waterController),
              WorkoutView(controller: _workoutController),
              BadgeView(controller: _badgeController),
            ],
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _currentTab,
        builder: (context, activeIndex, _) {
          return _SusadimBottomNav(
            currentIndex: activeIndex,
            onTap: (index) => _currentTab.value = index,
          );
        },
      ),
    );
  }
}

class _SusadimAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeController themeController;

  const _SusadimAppBar({required this.themeController});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return AppBar(
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          const Text('Susadım v1'),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: InkWell(
            onTap: themeController.toggleTheme,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceLightOf(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceBorderOf(context)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                    color: isDark ? AppColors.neonCyan : AppColors.neonOrange,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isDark ? 'Karanlık' : 'Aydınlık',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SusadimBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _SusadimBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cyan = AppColors.cyanOf(context);
    final green = AppColors.greenOf(context);
    final gold = AppColors.goldOf(context);
    final muted = AppColors.textSecondaryOf(context);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: AppColors.surfaceOf(context),
      indicatorColor: AppColors.surfaceLightOf(context),
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.water_drop_outlined, color: muted),
          selectedIcon: Icon(Icons.water_drop_rounded, color: cyan),
          label: 'Su Takibi',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined, color: muted),
          selectedIcon: Icon(Icons.fitness_center_rounded, color: green),
          label: 'Egzersiz',
        ),
        NavigationDestination(
          icon: Icon(Icons.military_tech_outlined, color: muted),
          selectedIcon: Icon(Icons.military_tech_rounded, color: gold),
          label: 'Rozetler',
        ),
      ],
    );
  }
}
