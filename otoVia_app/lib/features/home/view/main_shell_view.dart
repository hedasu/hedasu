import 'package:flutter/material.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../../core/theme/theme_controller.dart';
import '../../notifications/controller/notification_controller.dart';
import 'home_view.dart';
import '../../favorites/view/favorites_view.dart';
import '../../reservations/view/reservations_view.dart';
import '../../notifications/view/notifications_view.dart';
import '../../profile/view/profile_view.dart';

/// otoVia Ana Kabuk Ekranı (MainShellView)
///
/// Uygulamanın 5 ana sekmesini (Ana Sayfa, Favoriler, Kiralamalar, Bildirimler, Profil)
/// bir [IndexedStack] içerisinde tutarak sayfaların durumunu (scroll vb.) korur.
/// Üst çubukta (AppBar) logo, tema değiştirici (Açık/Koyu) ve bildirim rozeti yer alır.
class MainShellView extends StatefulWidget {
  const MainShellView({super.key});

  @override
  State<MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<MainShellView> {
  // Seçili aktif sekme indeksi
  int _currentIndex = 0;

  // Alt sekmelere karşılık gelen sayfa widget'ları listesi
  static const List<Widget> _pages = [
    HomeView(),
    FavoritesView(),
    ReservationsView(),
    NotificationsView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  /// Üst AppBar: Marka logosu, tema geçiş butonu ve okunmamış bildirim rozeti
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const BrandLogo(size: 32, fontSize: 20),
      actions: [
        _buildThemeToggle(context),
        _buildNotificationAction(context),
      ],
    );
  }

  /// Tek dokunuşla koyu ve açık tema arasında geçiş yapan buton
  Widget _buildThemeToggle(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        final isDark = themeController.isDarkMode;
        return IconButton(
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: const Color(0xFFC0B09A),
          ),
          tooltip: isDark ? 'Aydınlık Tema' : 'Karanlık Tema',
          onPressed: () => themeController.toggleTheme(),
        );
      },
    );
  }

  /// Bildirim simgesi ve varsa okunmamış bildirim adedini gösteren kırmızı sayaç rozeti
  Widget _buildNotificationAction(BuildContext context) {
    return ListenableBuilder(
      listenable: notificationController,
      builder: (context, _) {
        final unread = notificationController.unreadCount;
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              tooltip: 'Bildirimler',
              onPressed: () => setState(() => _currentIndex = 3),
            ),
            if (unread > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD32F2F),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Alt navigasyon çubuğu (Material 3 NavigationBar)
  Widget _buildBottomNav(BuildContext context) {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.directions_car_outlined),
          selectedIcon: Icon(Icons.directions_car),
          label: 'Ana Sayfa',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border_rounded),
          selectedIcon: Icon(Icons.favorite),
          label: 'Favoriler',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month),
          label: 'Kiralamalar',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(Icons.notifications),
          label: 'Bildirimler',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
