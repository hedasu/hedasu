import 'package:flutter/material.dart';
import '../../features/home/view/main_shell_view.dart';
import '../../features/auth/view/welcome_view.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/auth/view/register_view.dart';
import '../../features/reservations/view/reservations_view.dart';
import '../../features/favorites/view/favorites_view.dart';
import '../../features/coupons/view/coupons_view.dart';
import '../../features/support/view/support_view.dart';

/// otoVia Uygulama Yönlendirme (Routing) Yöneticisi
///
/// Uygulama içi isimlendirilmiş rotaları (named routes) ve rota geçişlerini merkezi olarak yönetir.
abstract final class AppRouter {
  // Rota İsimleri Sabitleri
  static const String initial = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String reservations = '/reservations';
  static const String favorites = '/favorites';
  static const String coupons = '/coupons';
  static const String support = '/support';

  /// Gelen rota isteğine göre ilgili sayfa widget'ını oluşturan fonksiyon
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const MainShellView());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeView());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case reservations:
        return MaterialPageRoute(builder: (_) => const ReservationsView());
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesView());
      case coupons:
        return MaterialPageRoute(builder: (_) => const CouponsView());
      case support:
        return MaterialPageRoute(builder: (_) => const SupportView());
      default:
        // Tanımsız bir rota talep edildiğinde varsayılan olarak ana kabuk ekranına döner
        return MaterialPageRoute(builder: (_) => const MainShellView());
    }
  }
}
