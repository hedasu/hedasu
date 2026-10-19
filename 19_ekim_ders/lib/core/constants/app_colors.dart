import 'package:flutter/material.dart';

/// Gece Spor Salonu (Dark Obsidian & Neon) konseptine ait renk sabitleri.
abstract final class AppColors {
  // Arka Plan ve Yüzeyler (Dark Obsidian)
  static const Color background = Color(0xFF0F0F12);
  static const Color surface = Color(0xFF18181D);
  static const Color surfaceVariant = Color(0xFF22222A);
  static const Color cardBorder = Color(0xFF2E2E38);

  // Neon Vurgu Renkleri
  static const Color neonCyan = Color(0xFF00E5FF);       // Su takibi vurgusu
  static const Color neonLime = Color(0xFF76FF03);       // Egzersiz & Tamamlanma vurgusu
  static const Color neonOrange = Color(0xFFFF6D00);     // Kalori & Efor vurgusu
  static const Color neonPurple = Color(0xFFD500F9);     // Hedef & Başarı vurgusu

  // Metin Renkleri
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFFA0A0B2);
  static const Color textMuted = Color(0xFF6B6B7E);

  // Durum Renkleri
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF1744);
  static const Color warning = Color(0xFFFFAB00);
}
