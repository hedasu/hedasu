import 'package:flutter/material.dart';

/// Dark Obsidian & Fresh Neon Spor Salonu Renk Paleti (Karanlık ve Aydınlık Uyumlu)
class AppColors {
  const AppColors._();

  // Koyu Tema Renkleri (Dark Obsidian)
  static const Color darkBackground = Color(0xFF0D0F14);
  static const Color darkSurface = Color(0xFF161A23);
  static const Color darkSurfaceLight = Color(0xFF1F2533);
  static const Color darkSurfaceBorder = Color(0xFF2C3549);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF90A4AE);
  static const Color darkTextMuted = Color(0xFF546E7A);

  // Aydınlık Tema Renkleri (Clean Minimalist Gym)
  static const Color lightBackground = Color(0xFFF6F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceLight = Color(0xFFEEF2F6);
  static const Color lightSurfaceBorder = Color(0xFFD7DFE9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Sabit Geriye Uyumluluk Değerleri (Varsayılan Koyu)
  static const Color background = darkBackground;
  static const Color surface = darkSurface;
  static const Color surfaceLight = darkSurfaceLight;
  static const Color surfaceBorder = darkSurfaceBorder;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textMuted = darkTextMuted;

  // Neon Vurgu Renkleri (Her iki temada da canlı ve dinamik)
  static const Color neonCyan = Color(0xFF00E5FF);       // Su & Hidrasyon
  static const Color neonCyanDarker = Color(0xFF0091EA); // Aydınlık mod için yüksek kontrast
  static const Color neonCyanGlow = Color(0x3300E5FF);
  
  static const Color neonGreen = Color(0xFF00E676);      // Fitness & Egzersiz
  static const Color neonGreenDarker = Color(0xFF00C853);
  static const Color neonGreenGlow = Color(0x3300E676);
  
  static const Color neonGold = Color(0xFFFFD700);       // Rozet & Başarı
  static const Color neonGoldDarker = Color(0xFFFFB300);
  static const Color neonGoldGlow = Color(0x33FFD700);
  
  static const Color neonOrange = Color(0xFFFF6D00);     // Kalori & Yoğunluk
  static const Color neonOrangeGlow = Color(0x33FF6D00);

  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF00E676);

  // Dinamik Context Yardımcıları
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color backgroundOf(BuildContext context) =>
      isDark(context) ? darkBackground : lightBackground;

  static Color surfaceOf(BuildContext context) =>
      isDark(context) ? darkSurface : lightSurface;

  static Color surfaceLightOf(BuildContext context) =>
      isDark(context) ? darkSurfaceLight : lightSurfaceLight;

  static Color surfaceBorderOf(BuildContext context) =>
      isDark(context) ? darkSurfaceBorder : lightSurfaceBorder;

  static Color textPrimaryOf(BuildContext context) =>
      isDark(context) ? darkTextPrimary : lightTextPrimary;

  static Color textSecondaryOf(BuildContext context) =>
      isDark(context) ? darkTextSecondary : lightTextSecondary;

  static Color textMutedOf(BuildContext context) =>
      isDark(context) ? darkTextMuted : lightTextMuted;

  static Color cyanOf(BuildContext context) =>
      isDark(context) ? neonCyan : neonCyanDarker;

  static Color greenOf(BuildContext context) =>
      isDark(context) ? neonGreen : neonGreenDarker;

  static Color goldOf(BuildContext context) =>
      isDark(context) ? neonGold : neonGoldDarker;
}
