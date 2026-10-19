import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/washi_tape.dart';
import '../../../core/widgets/paper_background.dart';

/// Dünce uygulamasının adının anlamını ve felsefesini anlatan nostaljik açılış ekranı.
class SplashView extends StatelessWidget {
  final VoidCallback onStart;

  const SplashView({
    super.key,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _buildScrapbookBookCover(context),
          ),
        ),
      ),
    );
  }

  Widget _buildScrapbookBookCover(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        PaperBackground(
          showLines: false,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              _buildAppLogo(),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 8),
              _buildTagline(),
              const Divider(height: 36),
              _buildEtymologyBox(context),
              const SizedBox(height: 28),
              _buildStartButton(),
            ],
          ),
        ),
        const Positioned(
          top: -10,
          child: WashiTape(width: 100, height: 22, rotation: -0.02),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      AppStrings.appName,
      style: GoogleFonts.playfairDisplay(
        fontSize: 38,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildTagline() {
    return Text(
      AppStrings.appTagline,
      style: GoogleFonts.caveat(
        fontSize: 18,
        color: AppColors.lightAccent,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEtymologyBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.appMeaningTitle,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.appMeaningDesc,
            style: GoogleFonts.lora(
              fontSize: 13,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      icon: const Icon(Icons.menu_book),
      label: Text(
        AppStrings.startJournaling,
        style: GoogleFonts.lora(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      onPressed: onStart,
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          AppStrings.appLogoPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
