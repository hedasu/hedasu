import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/router/app_router.dart';
import 'core/widgets/app_scope.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/pets/controller/pet_controller.dart';
import 'features/habits/controller/habit_controller.dart';
import 'features/badges/controller/badge_controller.dart';
import 'features/market/controller/market_controller.dart';
import 'features/cupboard/controller/cupboard_controller.dart';
import 'features/calendar/controller/calendar_controller.dart';
import 'features/notifications/controller/notification_controller.dart';
import 'features/profile/controller/profile_controller.dart';
import 'features/home/controller/home_controller.dart';

class HabiPetApp extends StatefulWidget {
  const HabiPetApp({super.key});

  @override
  State<HabiPetApp> createState() => _HabiPetAppState();
}

class _HabiPetAppState extends State<HabiPetApp> {
  late final ThemeController _themeController;
  late final AuthController _authController;
  late final PetController _petController;
  late final HabitController _habitController;
  late final BadgeController _badgeController;
  late final MarketController _marketController;
  late final CupboardController _cupboardController;
  late final CalendarController _calendarController;
  late final NotificationController _notificationController;
  late final ProfileController _profileController;
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
    _authController = AuthController();
    _petController = PetController();
    _habitController = HabitController();
    _badgeController = BadgeController();
    _marketController = MarketController();
    _cupboardController = CupboardController();
    _calendarController = CalendarController();
    _notificationController = NotificationController();
    _profileController = ProfileController();
    _homeController = HomeController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    _authController.dispose();
    _petController.dispose();
    _habitController.dispose();
    _badgeController.dispose();
    _marketController.dispose();
    _cupboardController.dispose();
    _calendarController.dispose();
    _notificationController.dispose();
    _profileController.dispose();
    _homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      themeController: _themeController,
      authController: _authController,
      petController: _petController,
      habitController: _habitController,
      badgeController: _badgeController,
      marketController: _marketController,
      cupboardController: _cupboardController,
      calendarController: _calendarController,
      notificationController: _notificationController,
      profileController: _profileController,
      homeController: _homeController,
      child: ListenableBuilder(
        listenable: _themeController,
        builder: (context, _) {
          return MaterialApp(
            title: 'habiPEt',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _themeController.themeMode,
            initialRoute: AppRouter.initialRoute,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
