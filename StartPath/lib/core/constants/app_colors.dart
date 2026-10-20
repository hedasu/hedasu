import 'package:flutter/material.dart';

/// StartPath Merkezi Renk Paleti
/// Material 3 Modern Professional tasarım anlayışına tam uyumludur.
abstract final class AppColors {
  // === Koyu Tema Renkleri (Dark Mode) ===
  static const Color darkBackground = Color(0xFF091416);
  static const Color darkSurface = Color(0xFF0F2225);
  static const Color darkSurfaceVariant = Color(0xFF163236);
  static const Color darkCard = Color(0xFF132A2E);
  static const Color darkPrimary = Color(0xFF26B6A5);
  static const Color darkOnPrimary = Color(0xFF032622);
  static const Color darkSecondary = Color(0xFF3B726B);
  static const Color darkAnthracite = Color(0xFF111718);
  static const Color darkDeepForest = Color(0xFF0C2925);
  static const Color darkText = Color(0xFFEDF5F4);
  static const Color darkTextSecondary = Color(0xFF9FB9B7);

  // === Aydınlık Tema Renkleri (Light Mode) ===
  static const Color lightBackground = Color(0xFFFAF8F5); // Fildişi
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF2ECE1); // Krem
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF134E48); // Petrol yeşili
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightSecondary = Color(0xFF6B948C); // Adaçayı yeşili
  static const Color lightText = Color(0xFF0D1E20);
  static const Color lightTextSecondary = Color(0xFF556866);

  // === Vurgular (Accents) ===
  static const Color champagneGold = Color(0xFFE5C378); // Koyu tema altın vurgusu
  static const Color elegantGold = Color(0xFFC09842); // Aydınlık tema altın vurgusu

  // === Durum Renkleri (Status Colors) ===
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFE65100);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);
  static const Color borderSubtle = Color(0x1FFFFFFF);
  static const Color borderSubtleLight = Color(0x14000000);
}
