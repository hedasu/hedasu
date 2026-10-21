import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/packpilot_logo.dart';
import '../../auth/models/user_model.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_menu_tile.dart';

class ProfileView extends StatefulWidget {
  final StorageService storageService;

  const ProfileView({super.key, required this.storageService});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = ProfileController(storageService: widget.storageService);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final secTextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: borderColor),
        ),
        title: Text(
          'Hesabı Sıfırla',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.error,
          ),
        ),
        content: Text(
          'Profilinizi ve tüm kayıtlı seyahat verilerinizi sıfırlamak istediğinizden emin misiniz?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: secTextColor,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Vazgeç',
              style: GoogleFonts.inter(color: secTextColor, fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await controller.deleteAccount();
              if (context.mounted) {
                context.go('/auth');
              }
            },
            child: const Text('Hesabı Sıfırla'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secTextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: borderColor),
        ),
        title: Row(
          children: [
            Icon(Icons.help_outline_rounded, color: primaryColor, size: 22),
            const SizedBox(width: 10),
            Text(
              'Yardım & Destek',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PackPilot Nasıl Çalışır?',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '1. Yeni Seyahat: Tarih ve varış noktası seçin.\n2. Hava Durumu: Open-Meteo ile günlük ve saatlik hava durumunu inceleyin.\n3. Seyahat Türü: Gezinize en uygun tür ve alt türleri belirleyin.\n4. Öneriler: Hava koşullarına göre akıllı eşya tavsiyelerini listenize ekleyin.\n5. Valiz Kontrolü: Eşyalarınızı yerleştirdikçe tek tıkla işaretleyin.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: secTextColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Tasarım Dili — Atlas & Sage',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Doğadan ilham alan adaçayı yeşili, sıcak krem ve derin orman tonlarıyla ferah, modern ve minimalist bir deneyim.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: secTextColor,
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: isDark ? const Color(0xFF101C1B) : Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Ayarlar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<UserModel>(
          valueListenable: controller.user,
          builder: (context, user, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User Profile Hero Card
                  GlassContainer(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        const PackPilotLogo(size: 54),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: GoogleFonts.manrope(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user.email,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: secondaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'PackPilot Gezgini • Atlas & Sage',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tema Tercihi Seçici Kartı (3 Seçenek: Sistem, Warm Linen, Deep Forest)
                  Text(
                    'Tema Seçimi — Atlas & Sage',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  GlassContainer(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildThemeOption(
                              label: 'Sistem',
                              icon: Icons.brightness_auto_rounded,
                              preference: 'system',
                              currentPreference: user.themePreference,
                              isDark: isDark,
                            ),
                            const SizedBox(width: 8),
                            _buildThemeOption(
                              label: 'Warm Linen',
                              icon: Icons.light_mode_rounded,
                              preference: 'light',
                              currentPreference: user.themePreference,
                              isDark: isDark,
                            ),
                            const SizedBox(width: 8),
                            _buildThemeOption(
                              label: 'Deep Forest',
                              icon: Icons.dark_mode_rounded,
                              preference: 'dark',
                              currentPreference: user.themePreference,
                              isDark: isDark,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.themePreference == 'system'
                              ? 'Cihazınızın sistem temasına göre otomatik uyum sağlanır.'
                              : (user.themePreference == 'light'
                                  ? 'Warm Linen: Sıcak krem arka plan ve koyu adaçayı tonları.'
                                  : 'Deep Forest: Doğal orman yeşili ve yumuşak mint tonları.'),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Menu Sections
                  Text(
                    'Uygulama Modülleri',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  GlassContainer(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ProfileMenuTile(
                          icon: Icons.calendar_month_rounded,
                          title: 'Seyahat Ajandam',
                          subtitle: 'Geçmiş, güncel ve gelecek tüm geziler',
                          onTap: () => context.push('/agenda'),
                        ),
                        Divider(height: 1, color: borderColor),
                        ProfileMenuTile(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Alışveriş Listem',
                          subtitle: 'Seyahat öncesi alınacak eksik eşyalar',
                          iconColor: isDark ? AppColors.darkAccent : AppColors.lightAccent,
                          onTap: () => context.push('/shopping'),
                        ),
                        Divider(height: 1, color: borderColor),
                        ProfileMenuTile(
                          icon: Icons.water_drop_outlined,
                          title: 'Döngü & Seyahat Takibi',
                          subtitle: 'İsteğe bağlı seyahat dönemi kontrolü',
                          iconColor: isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
                          onTap: () => context.push('/cycle-tracking'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Bildirim & Sistem',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  GlassContainer(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ProfileMenuTile(
                          icon: Icons.notifications_none_rounded,
                          title: 'Hava Durumu Bildirimleri',
                          subtitle: 'Yağış ve ani sıcaklık düşüşü uyarıları',
                          trailing: Switch(
                            value: user.notificationsEnabled,
                            activeTrackColor: primaryColor,
                            onChanged: (val) => controller.toggleNotifications(val),
                          ),
                        ),
                        Divider(height: 1, color: borderColor),
                        ProfileMenuTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Yardım & Destek',
                          subtitle: 'PackPilot kullanım kılavuzu ve ipuçları',
                          onTap: () => _showHelpDialog(context),
                        ),
                        Divider(height: 1, color: borderColor),
                        ProfileMenuTile(
                          icon: Icons.refresh_rounded,
                          title: 'Hesap Verilerini Sıfırla',
                          subtitle: 'Örnek verileri ve geçmişi temizle',
                          isDestructive: true,
                          onTap: () => _showDeleteAccountDialog(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String label,
    required IconData icon,
    required String preference,
    required String currentPreference,
    required bool isDark,
  }) {
    final isSelected = currentPreference == preference;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final selectedBg = isDark ? AppColors.darkSelected : AppColors.lightSelected;
    final unselectedBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => controller.setThemePreference(preference),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected ? selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryColor : unselectedBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? primaryColor : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? primaryColor : textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
