import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Theme Palette (Gece Ormanı Konsepti)
  static const Color darkBackground = Color(0xFF0B131E);
  static const Color darkSurface = Color(0xFF14202E);
  static const Color darkSurfaceVariant = Color(0xFF1D2D40);
  static const Color darkBorder = Color(0xFF263A50);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkMint = Color(0xFF38D9A9);
  static const Color darkMintGlow = Color(0xFF20C997);

  // Light Theme Palette (Ferah Doğa Konsepti)
  static const Color lightBackground = Color(0xFFF7FAF8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEBF7F2);
  static const Color lightBorder = Color(0xFFD6E9E0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightMint = Color(0xFF059669);
  static const Color lightMintLight = Color(0xFF10B981);

  // Shared Accents & Highlights
  static const Color primary = Color(0xFF10B981);
  static const Color primaryDark = Color(0xFF059669);
  static const Color secondary = Color(0xFF06B6D4);
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Badge Hierarchy Colors (Yıllık > Aylık > Haftalık > Günlük)
  static const Color badgeDaily = Color(0xFF38BDF8); // Günlük - Sky Cyan
  static const Color badgeWeekly = Color(0xFF10B981); // Haftalık - Emerald
  static const Color badgeMonthly = Color(0xFF8B5CF6); // Aylık - Royal Purple
  static const Color badgeYearly = Color(0xFFF59E0B); // Yıllık - Shiny Gold
  static const Color badgeSpecial = Color(0xFFEC4899); // Özel 21. Gün & Milestones

  // Apple Calendar Habit Colors
  static const List<Color> habitColors = [
    Color(0xFF38D9A9), // Mint Green
    Color(0xFF0EA5E9), // Ocean Blue
    Color(0xFF8B5CF6), // Amethyst Purple
    Color(0xFFF97316), // Sunset Coral
    Color(0xFFEC4899), // Rose Berry
    Color(0xFFEAB308), // Sunflower Yellow
    Color(0xFF06B6D4), // Cyan
    Color(0xFF14B8A6), // Teal
  ];
}
