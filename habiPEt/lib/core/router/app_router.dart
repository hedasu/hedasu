import 'package:flutter/material.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/pets/view/pet_selection_view.dart';
import '../../features/pets/view/pet_detail_view.dart';
import '../../features/habits/view/add_habit_view.dart';
import '../../features/market/view/market_view.dart';
import '../../features/cupboard/view/cupboard_view.dart';
import '../../features/notifications/view/notifications_view.dart';
import '../../features/profile/view/settings_view.dart';
import '../../features/profile/view/help_support_view.dart';
import '../widgets/app_bottom_navigation.dart';

class AppRouter {
  AppRouter._();

  static const String initialRoute = '/';
  static const String loginRoute = '/login';
  static const String petSelectionRoute = '/pet-selection';
  static const String petDetailRoute = '/pet-detail';
  static const String addHabitRoute = '/add-habit';
  static const String marketRoute = '/market';
  static const String cupboardRoute = '/cupboard';
  static const String notificationsRoute = '/notifications';
  static const String settingsRoute = '/settings';
  static const String helpSupportRoute = '/help-support';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => const AppBottomNavigation());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case petSelectionRoute:
        return MaterialPageRoute(builder: (_) => const PetSelectionView());
      case petDetailRoute:
        return MaterialPageRoute(builder: (_) => const PetDetailView());
      case addHabitRoute:
        return MaterialPageRoute(builder: (_) => const AddHabitView());
      case marketRoute:
        return MaterialPageRoute(builder: (_) => const MarketView());
      case cupboardRoute:
        return MaterialPageRoute(builder: (_) => const CupboardView());
      case notificationsRoute:
        return MaterialPageRoute(builder: (_) => const NotificationsView());
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsView());
      case helpSupportRoute:
        return MaterialPageRoute(builder: (_) => const HelpSupportView());
      default:
        return MaterialPageRoute(builder: (_) => const AppBottomNavigation());
    }
  }
}
