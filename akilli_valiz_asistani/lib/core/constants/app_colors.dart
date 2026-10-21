import 'package:flutter/material.dart';

/// Atlas & Sage — Modern, minimalist, doğal ve premium tasarım sistemi renk paleti
class AppColors {
  AppColors._();

  // ==========================================
  // 1. AYDINLIK TEMA — WARM LINEN
  // ==========================================
  /// Ana Renk: Koyu adaçayı yeşili (#166F65)
  static const Color lightPrimary = Color(0xFF166F65);

  /// İkincil Renk: Turkuaz yeşili (#168C80)
  static const Color lightSecondary = Color(0xFF168C80);

  /// Arka Plan: Sıcak krem (#FAF7F0)
  static const Color lightBackground = Color(0xFFFAF7F0);

  /// Kart Yüzeyleri: Beyaz (#FFFFFF)
  static const Color lightCard = Color(0xFFFFFFFF);

  /// Vurgu Rengi: Kum altını (#E9C998)
  static const Color lightAccent = Color(0xFFE9C998);

  /// Ana Metin: Koyu yeşil (#203E39)
  static const Color lightTextPrimary = Color(0xFF203E39);

  /// Yardımcı Metin: Gri yeşil (#61736B)
  static const Color lightTextSecondary = Color(0xFF61736B);

  /// Kenarlık: Açık adaçayı (#DCE4DA)
  static const Color lightBorder = Color(0xFFDCE4DA);

  /// Seçili Alan: Pastel yeşil (#E5F1E9)
  static const Color lightSelected = Color(0xFFE5F1E9);

  // ==========================================
  // 2. KARANLIK TEMA — DEEP FOREST
  // ==========================================
  /// Ana Renk: Yumuşak mint (#80D9C0)
  static const Color darkPrimary = Color(0xFF80D9C0);

  /// İkincil Renk: Adaçayı turkuazı (#4CB49D)
  static const Color darkSecondary = Color(0xFF4CB49D);

  /// Arka Plan: Koyu orman yeşili (#101C1B)
  static const Color darkBackground = Color(0xFF101C1B);

  /// Kart Yüzeyleri: Koyu yeşil (#182A27)
  static const Color darkCard = Color(0xFF182A27);

  /// Vurgu Rengi: Mat altın (#D5AE72)
  static const Color darkAccent = Color(0xFFD5AE72);

  /// Ana Metin: Kırık beyaz (#EFF6F0)
  static const Color darkTextPrimary = Color(0xFFEFF6F0);

  /// Yardımcı Metin: Açık gri yeşil (#B6C9BE)
  static const Color darkTextSecondary = Color(0xFFB6C9BE);

  /// Kenarlık: Orman yeşili (#355349)
  static const Color darkBorder = Color(0xFF355349);

  /// Seçili Alan: Koyu adaçayı (#254D43)
  static const Color darkSelected = Color(0xFF254D43);

  // ==========================================
  // BİLDİRİM VE DURUM RENKLERİ (DOĞAL UYUM)
  // ==========================================
  static const Color success = Color(0xFF2E8B57); // Deniz yeşili / Başarı
  static const Color warning = Color(0xFFD5AE72); // Mat altın / Uyarı
  static const Color error = Color(0xFFD9534F); // Sıcak mercan / Hata
  static const Color info = Color(0xFF168C80); // Turkuaz yeşili / Bilgi

  // ==========================================
  // GERİYE DÖNÜK VE STATİK UYUMLULUK ALIAS'LARI
  // ==========================================
  static const Color primary = lightPrimary;
  static const Color primaryLight = Color(0xFF2C8A7E);
  static const Color primaryDark = Color(0xFF0F4E46);

  static const Color secondary = lightSecondary;
  static const Color secondaryLight = Color(0xFF4CB49D);
  static const Color accent = lightAccent;
  static const Color accentIndigo = Color(0xFF4CB49D);
  static const Color accentCyan = Color(0xFF168C80);

  // Aydınlık alias'lar
  static const Color backgroundLight = lightBackground;
  static const Color surfaceLight = lightCard;
  static const Color surfaceVariantLight = lightSelected;
  static const Color cardLight = lightCard;
  static const Color borderLight = lightBorder;
  static const Color textPrimaryLight = lightTextPrimary;
  static const Color textSecondaryLight = lightTextSecondary;
  static const Color textMutedLight = Color(0xFF8A9B93);
  static const Color selectedLight = lightSelected;

  // Karanlık alias'lar
  static const Color backgroundDark = darkBackground;
  static const Color surfaceDark = darkCard;
  static const Color surfaceVariantDark = darkSelected;
  static const Color cardDark = darkCard;
  static const Color borderDark = darkBorder;
  static const Color textPrimaryDark = darkTextPrimary;
  static const Color textSecondaryDark = darkTextSecondary;
  static const Color textMutedDark = Color(0xFF7A9187);
  static const Color selectedDark = darkSelected;

  // İnce ve sade gradyanlar (Aşırı parlamalardan arındırılmış)
  static const LinearGradient sageGradient = LinearGradient(
    colors: [Color(0xFF166F65), Color(0xFF168C80)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient forestGradient = LinearGradient(
    colors: [Color(0xFF182A27), Color(0xFF101C1B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFD5AE72), Color(0xFFE9C998)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Eski referansları kırılmadan karşılayan uyumluluk gradyanları
  static const LinearGradient primaryGradient = sageGradient;
  static const LinearGradient sunsetGradient = accentGradient;
  static const LinearGradient darkCardGradient = forestGradient;
}
