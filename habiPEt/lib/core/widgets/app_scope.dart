import 'package:flutter/material.dart';
import '../theme/theme_controller.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/pets/controller/pet_controller.dart';
import '../../features/habits/controller/habit_controller.dart';
import '../../features/badges/controller/badge_controller.dart';
import '../../features/market/controller/market_controller.dart';
import '../../features/cupboard/controller/cupboard_controller.dart';
import '../../features/calendar/controller/calendar_controller.dart';
import '../../features/notifications/controller/notification_controller.dart';
import '../../features/profile/controller/profile_controller.dart';
import '../../features/home/controller/home_controller.dart';

class AppScope extends InheritedWidget {
  final ThemeController themeController;
  final AuthController authController;
  final PetController petController;
  final HabitController habitController;
  final BadgeController badgeController;
  final MarketController marketController;
  final CupboardController cupboardController;
  final CalendarController calendarController;
  final NotificationController notificationController;
  final ProfileController profileController;
  final HomeController homeController;

  const AppScope({
    super.key,
    required this.themeController,
    required this.authController,
    required this.petController,
    required this.habitController,
    required this.badgeController,
    required this.marketController,
    required this.cupboardController,
    required this.calendarController,
    required this.notificationController,
    required this.profileController,
    required this.homeController,
    required super.child,
  });

  static AppScope of(BuildContext context) {
    final AppScope? result = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(result != null, 'No AppScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
