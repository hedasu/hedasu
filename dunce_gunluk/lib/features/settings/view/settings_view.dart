import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/paper_background.dart';
import '../controller/theme_controller.dart';

/// Uygulama ayarları ve görünüm tercihlerinin yönetildiği ekran.
class SettingsView extends StatelessWidget {
  final ThemeController themeController;

  const SettingsView({
    super.key,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        final isDark = themeController.isDarkMode;
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            _buildThemeCard(context, isDark),
            const SizedBox(height: 16),
            _buildAboutCard(context),
            const SizedBox(height: 16),
            _buildPrivacyCard(context),
          ],
        );
      },
    );
  }

  Widget _buildThemeCard(BuildContext context, bool isDark) {
    return PaperBackground(
      showLines: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.themeMode,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(
              isDark ? AppStrings.darkTheme : AppStrings.lightTheme,
              style: GoogleFonts.lora(fontSize: 14),
            ),
            subtitle: Text(
              isDark
                  ? 'Koyu parşömen, sepya ve antika kitap atmosferi'
                  : 'Nostaljik krem defter ve açık parşömen kâğıdı',
              style: GoogleFonts.lora(fontSize: 12),
            ),
            secondary: Icon(
              isDark ? Icons.menu_book : Icons.auto_stories,
              color: isDark ? AppColors.darkGold : AppColors.lightAccent,
            ),
            value: isDark,
            onChanged: (_) => themeController.toggleTheme(),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return PaperBackground(
      showLines: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  AppStrings.appLogoPath,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.appMeaningTitle,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'v1.0.0 • Vintage Scrapbook',
                    style: GoogleFonts.lora(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.appMeaningDesc,
            style: GoogleFonts.lora(fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard(BuildContext context) {
    return PaperBackground(
      showLines: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.sageGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kişisel ve Güvenli',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tüm anılarınız, fotoğraflarınız ve çizimleriniz yalnızca bu cihazda yerel olarak saklanır. Hiçbir veriniz üçüncü taraf sunuculara aktarılmaz.',
                  style: GoogleFonts.lora(fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
