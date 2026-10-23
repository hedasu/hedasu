import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // 1. LIGHT MODE – Sage & Cream
  // Primary (Ana renk): #557C6B
  // Secondary (İkincil renk): #BBD2C0
  // Background (Arka plan): #FAF8F1
  // Surface (Kart arka planı): #FFFFFF
  // Accent (Vurgu/Ödül): #D6A85B
  // Text Primary (Ana yazı): #273B34
  // Text Secondary (İkincil yazı): #64756D
  // Border (Kart kenarlıkları): #DCE8DF
  static const Color lightPrimary = Color(0xFF557C6B);
  static const Color lightSecondary = Color(0xFFBBD2C0);
  static const Color lightBackground = Color(0xFFFAF8F1);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF0F5F2);
  static const Color lightBorder = Color(0xFFDCE8DF);
  static const Color lightTextPrimary = Color(0xFF273B34);
  static const Color lightTextSecondary = Color(0xFF64756D);
  static const Color lightAccent = Color(0xFFD6A85B);

  // 2. DARK MODE – Sage & Cream
  // Primary (Ana renk): #6EA286
  // Secondary (İkincil renk): #3A5B4F
  // Background (Arka plan): #0F1412
  // Surface (Kart arka planı): #1A221E
  // Surface Variant (İkincil kart): #232E28
  // Accent (Vurgu/Ödül): #D6A85B
  // Text Primary (Ana yazı): #E8EDE6
  // Text Secondary (İkincil yazı): #A8B5AC
  // Border (Kart kenarlıkları): #34463C
  static const Color darkPrimary = Color(0xFF6EA286);
  static const Color darkSecondary = Color(0xFF3A5B4F);
  static const Color darkBackground = Color(0xFF0F1412);
  static const Color darkSurface = Color(0xFF1A221E);
  static const Color darkSurfaceVariant = Color(0xFF232E28);
  static const Color darkBorder = Color(0xFF34463C);
  static const Color darkTextPrimary = Color(0xFFE8EDE6);
  static const Color darkTextSecondary = Color(0xFFA8B5AC);
  static const Color darkAccent = Color(0xFFD6A85B);

  // Ortak Vurgu ve Ödül (Sage & Cream Gold Accent)
  static const Color accentGold = Color(0xFFD6A85B);
  static const Color accent = Color(0xFFD6A85B);

  // Backward-Compatible Semantic Aliases
  static const Color darkMint = darkPrimary; // #6EA286
  static const Color darkMintGlow = Color(0xFF7EBC9A);
  static const Color lightMint = lightPrimary; // #557C6B
  static const Color lightMintLight = Color(0xFF6A9984);
  static const Color primary = darkPrimary;
  static const Color primaryDark = lightPrimary;
  static const Color secondary = darkSecondary; // #3A5B4F

  // Status & Utility Accents
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentBlue = Color(0xFF0EA5E9);
  static const Color success = Color(0xFF6EA286); // Sage Success
  static const Color warning = Color(0xFFD6A85B); // Sage Gold Warning
  static const Color error = Color(0xFFEF4444);

  // Badge Hierarchy Colors (Yıllık > Aylık > Haftalık > Günlük)
  static const Color badgeDaily = Color(0xFF38BDF8); // Günlük - Sky Cyan
  static const Color badgeWeekly = Color(0xFF6EA286); // Haftalık - Sage Green
  static const Color badgeMonthly = Color(0xFF8B5CF6); // Aylık - Royal Purple
  static const Color badgeYearly = Color(0xFFD6A85B); // Yıllık - Sage Gold (#D6A85B)
  static const Color badgeMulti = Color(0xFF557C6B); // Çoklu Alışkanlık - Deep Sage
  static const Color badgeSpecial = Color(0xFFEC4899); // Özel 21. Gün

  // Alışkanlıkların Kendilerine Özgü Renkleri (Her iki temada korunur)
  // - Su İçme: Mavi #0EA5E9
  // - Spor & Antrenman: Turuncu #F97316
  // - Yoga & Meditasyon: Mor #8B5CF6
  // - Sigara Bırakma: Mint #34D399
  // - Kitap Okuma: Kehribar/Altın #EAB308
  static const Color habitWater = Color(0xFF0EA5E9);
  static const Color habitSport = Color(0xFFF97316);
  static const Color habitYoga = Color(0xFF8B5CF6);
  static const Color habitSmoking = Color(0xFF34D399);
  static const Color habitReading = Color(0xFFEAB308);

  static const List<Color> habitColors = [
    Color(0xFF34D399), // Mint Green (#34D399) - Sigara Bırakma
    Color(0xFF0EA5E9), // Ocean Blue (#0EA5E9) - Su İçme
    Color(0xFF8B5CF6), // Amethyst Purple (#8B5CF6) - Yoga
    Color(0xFFF97316), // Sunset Orange (#F97316) - Spor
    Color(0xFFEC4899), // Rose Berry
    Color(0xFFEAB308), // Sunflower Amber - Kitap Okuma
    Color(0xFF06B6D4), // Cyan
    Color(0xFF6EA286), // Sage Green
  ];
}
