import 'package:flutter/material.dart';
import '../../auth/controller/auth_controller.dart';
import 'edit_profile_dialog.dart';
import 'statistics_view.dart';
import '../../reservations/view/reservations_view.dart';
import '../../favorites/view/favorites_view.dart';
import '../../coupons/view/coupons_view.dart';
import '../../support/view/support_view.dart';
import '../../auth/view/welcome_view.dart';

/// otoVia Kullanıcı Profil Ekranı (ProfileView)
///
/// Kullanıcı kartını (ad, soyad, e-posta, ehliyet sınıfı), profil düzenleme butonunu
/// ve Rezervasyonlarım, Favorilerim, Kuponlarım, Yardım & Destek, İstatistikler
/// ile Çıkış Yap seçeneklerini barındıran lüks menü kartını sergiler.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authController,
      builder: (context, _) {
        final user = authController.currentUser;
        return Scaffold(
          appBar: AppBar(title: const Text('Profil')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Kullanıcı kimlik ve ehliyet özeti kartı
                _buildUserCard(context, user),
                const SizedBox(height: 24),
                // Profil menü listesi
                _buildMenuItems(context),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Kullanıcı profil kartı (Avatar, ad-soyad, e-posta, ehliyet sınıfı ve düzenle butonu)
  Widget _buildUserCard(BuildContext context, dynamic user) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFC0B09A),
            child: Text(
              user?.name.isNotEmpty == true ? user.name[0] : 'U',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.fullName ?? 'Misafir Kullanıcı',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  user?.email ?? '',
                  style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ehliyet Sınıfı: ${user?.driverLicenseClass ?? "B"}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFC0B09A)),
                ),
              ],
            ),
          ),
          IconButton.outlined(
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const EditProfileDialog(),
            ),
            tooltip: 'Bilgileri Düzenle',
          ),
        ],
      ),
    );
  }

  /// Profil navigasyon menü öğeleri
  Widget _buildMenuItems(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildItem(context, Icons.calendar_today_outlined, 'Rezervasyonlarım', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservationsView()));
          }),
          _buildDivider(context),
          _buildItem(context, Icons.favorite_border_rounded, 'Favorilerim', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesView()));
          }),
          _buildDivider(context),
          _buildItem(context, Icons.local_offer_outlined, 'Kuponlarım', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CouponsView()));
          }),
          _buildDivider(context),
          _buildItem(context, Icons.help_outline, 'Yardım & Destek', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportView()));
          }),
          _buildDivider(context),
          _buildItem(context, Icons.bar_chart_rounded, 'Kiralama İstatistiklerim', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const StatisticsView()));
          }),
          _buildDivider(context),
          _buildItem(context, Icons.logout, 'Çıkış Yap', () => _confirmLogout(context), isDestructive: true),
        ],
      ),
    );
  }

  /// Menü satırı oluşturucu
  Widget _buildItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? const Color(0xFFD32F2F) : null, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDestructive ? const Color(0xFFD32F2F) : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }

  /// Menü içi ince ayırıcı
  Widget _buildDivider(BuildContext context) {
    return Divider(height: 1, indent: 16, endIndent: 16, color: Theme.of(context).colorScheme.outline);
  }

  /// Oturum kapatma onay modal penceresi
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
            onPressed: () {
              authController.logout();
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeView()),
                (route) => false,
              );
            },
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }
}
