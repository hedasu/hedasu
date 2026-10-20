import 'package:flutter/material.dart';

/// otoVia Monochrome Luxury Renk Sistemi
///
/// Tasarım kılavuzundaki renk token'larının birebir karşılığıdır.
/// Aydınlık tema (Ivory White) ve Karanlık tema (Obsidian Luxury) için
/// kontrastı yüksek, rafine ve lüks bir palet sunar.
abstract final class AppColors {
  // ==========================================
  // Light Theme (Ivory White) Renk Token'ları
  // ==========================================
  /// Açık tema arka plan rengi (kırık fildişi)
  static const Color lightBackground = Color(0xFFF7F7F5);
  /// Açık tema kart ve yüzey rengi (saf beyaz)
  static const Color lightSurface = Color(0xFFFFFFFF);
  /// Açık tema alternatif yüzey / çip rengi
  static const Color lightSurfaceVariant = Color(0xFFEEEEEB);
  /// Açık tema birincil buton ve vurgu rengi (koyu antrasit)
  static const Color lightPrimary = Color(0xFF1C1C1C);
  /// Açık tema birincil eleman üstü metin rengi
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  /// Açık tema ana metin rengi
  static const Color lightOnSurface = Color(0xFF191919);
  /// Açık tema ikincil/açıklama metin rengi
  static const Color lightOnSurfaceVariant = Color(0xFF62625F);
  /// Açık tema sınır ve ayırıcı çizgi rengi
  static const Color lightOutline = Color(0xFFDCDCD8);
  /// Açık tema şampanya tonlu zarif vurgu rengi
  static const Color lightAccent = Color(0xFFA79A89);

  // ===========================================
  // Dark Theme (Obsidian Luxury) Renk Token'ları
  // ===========================================
  /// Koyu tema ana arka plan rengi (obsidyen derin siyahı)
  static const Color darkBackground = Color(0xFF141414);
  /// Koyu tema kart ve yüzey rengi (grafit)
  static const Color darkSurface = Color(0xFF222222);
  /// Koyu tema alternatif yüzey / çip rengi
  static const Color darkSurfaceVariant = Color(0xFF303030);
  /// Koyu tema birincil buton rengi (yumuşak açık kemik)
  static const Color darkPrimary = Color(0xFFEEEDE9);
  /// Koyu tema birincil buton üzeri metin rengi
  static const Color darkOnPrimary = Color(0xFF191919);
  /// Koyu tema ana metin rengi
  static const Color darkOnSurface = Color(0xFFF5F5F2);
  /// Koyu tema ikincil/açıklama metin rengi
  static const Color darkOnSurfaceVariant = Color(0xFFB8B8B2);
  /// Koyu tema sınır ve ayırıcı çizgi rengi
  static const Color darkOutline = Color(0xFF393939);
  /// Koyu tema şampanya altın vurgu rengi
  static const Color darkAccent = Color(0xFFC0B09A);

  // ==========================================
  // Semantik Durum Renkleri (Hata, Başarı, vb.)
  // ==========================================
  /// Başarılı durum açık renk tonu
  static const Color success = Color(0xFF2E7D32);
  /// Başarılı durum koyu renk tonu
  static const Color successDark = Color(0xFF4CAF50);
  /// Hata durumu açık renk tonu
  static const Color error = Color(0xFFD32F2F);
  /// Hata durumu koyu renk tonu
  static const Color errorDark = Color(0xFFEF5350);
  /// Uyarı durumu açık renk tonu
  static const Color warning = Color(0xFFED6C02);
  /// Uyarı durumu koyu renk tonu
  static const Color warningDark = Color(0xFFFF9800);
  /// Bilgilendirme durumu açık renk tonu
  static const Color info = Color(0xFF0288D1);
  /// Bilgilendirme durumu koyu renk tonu
  static const Color infoDark = Color(0xFF29B6F6);

  // ==========================================
  // Yardımcı Renkler
  // ==========================================
  /// Tamamen saydam renk
  static const Color transparent = Colors.transparent;
}
