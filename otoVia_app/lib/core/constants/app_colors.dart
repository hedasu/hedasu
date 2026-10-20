import 'package:flutter/material.dart';

/// otoVia Monochrome Luxury Renk Sistemi
/// still.md belgesindeki renk token'larının birebir karşılığıdır.
abstract final class AppColors {
  // Light Theme (Ivory White)
  static const Color lightBackground = Color(0xFFF7F7F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEEEEEB);
  static const Color lightPrimary = Color(0xFF1C1C1C);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF191919);
  static const Color lightOnSurfaceVariant = Color(0xFF62625F);
  static const Color lightOutline = Color(0xFFDCDCD8);
  static const Color lightAccent = Color(0xFFA79A89); // Champagne

  // Dark Theme (Obsidian Luxury)
  static const Color darkBackground = Color(0xFF141414);
  static const Color darkSurface = Color(0xFF222222);
  static const Color darkSurfaceVariant = Color(0xFF303030);
  static const Color darkPrimary = Color(0xFFEEEDE9);
  static const Color darkOnPrimary = Color(0xFF191919);
  static const Color darkOnSurface = Color(0xFFF5F5F2);
  static const Color darkOnSurfaceVariant = Color(0xFFB8B8B2);
  static const Color darkOutline = Color(0xFF393939);
  static const Color darkAccent = Color(0xFFC0B09A); // Champagne

  // Semantik Durum Renkleri
  static const Color success = Color(0xFF2E7D32);
  static const Color successDark = Color(0xFF4CAF50);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorDark = Color(0xFFEF5350);
  static const Color warning = Color(0xFFED6C02);
  static const Color warningDark = Color(0xFFFF9800);
  static const Color info = Color(0xFF0288D1);
  static const Color infoDark = Color(0xFF29B6F6);

  // Şeffaf ve ara katman renkleri
  static const Color transparent = Colors.transparent;
}
