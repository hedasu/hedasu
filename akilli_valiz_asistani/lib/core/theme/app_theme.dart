import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Atlas & Sage — Material 3 tabanlı, modern, minimalist, doğal ve premium tema sistemi
class AppTheme {
  AppTheme._();

  /// Manrope (Başlıklar) ve Inter (İçerik) kombinasyonu ile tipografi kurallarını oluşturur
  static TextTheme _buildTextTheme({
    required Color primaryText,
    required Color secondaryText,
    required Color mutedText,
  }) {
    final headingFont = GoogleFonts.manropeTextTheme();
    final bodyFont = GoogleFonts.interTextTheme();

    return TextTheme(
      // Ana Başlık: 28 sp / Bold
      displayLarge: headingFont.displayLarge?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primaryText,
        letterSpacing: -0.5,
      ),
      displayMedium: headingFont.displayMedium?.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: primaryText,
        letterSpacing: -0.4,
      ),
      // Sayfa Başlığı: 24 sp / Bold
      headlineLarge: headingFont.headlineLarge?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primaryText,
        letterSpacing: -0.3,
      ),
      headlineMedium: headingFont.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      headlineSmall: headingFont.headlineSmall?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      // Kart Başlığı: 18 sp / SemiBold
      titleLarge: headingFont.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleMedium: headingFont.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleSmall: headingFont.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      // İçerik Metni: 16 sp / Regular
      bodyLarge: bodyFont.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText,
        height: 1.5,
      ),
      // Açıklama Metni: 14 sp / Regular
      bodyMedium: bodyFont.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryText,
        height: 1.4,
      ),
      bodySmall: bodyFont.bodySmall?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: mutedText,
      ),
      // Buton Metni: 15 sp / SemiBold
      labelLarge: bodyFont.labelLarge?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      // Küçük Etiketler: 12 sp / Medium
      labelMedium: bodyFont.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryText,
      ),
      labelSmall: bodyFont.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: mutedText,
      ),
    );
  }

  // ==========================================
  // 1. AYDINLIK TEMA — WARM LINEN
  // ==========================================
  static ThemeData get lightTheme {
    final textTheme = _buildTextTheme(
      primaryText: AppColors.lightTextPrimary,
      secondaryText: AppColors.lightTextSecondary,
      mutedText: AppColors.textMutedLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.inter().fontFamily,
      scaffoldBackgroundColor: AppColors.lightBackground,
      primaryColor: AppColors.lightPrimary,
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.lightSelected,
        onPrimaryContainer: AppColors.lightTextPrimary,
        secondary: AppColors.lightSecondary,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.lightSelected,
        onSecondaryContainer: AppColors.lightTextPrimary,
        tertiary: AppColors.lightAccent,
        onTertiary: AppColors.lightTextPrimary,
        surface: AppColors.lightCard,
        onSurface: AppColors.lightTextPrimary,
        surfaceContainerHighest: AppColors.lightSelected,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.lightBorder,
        outlineVariant: AppColors.lightBorder,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.lightTextPrimary,
          size: 22,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCard,
        hintStyle: GoogleFonts.inter(
          color: AppColors.lightTextSecondary,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightCard,
        selectedColor: AppColors.lightSelected,
        side: const BorderSide(color: AppColors.lightBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          color: AppColors.lightTextPrimary,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightCard,
        indicatorColor: AppColors.lightSelected,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.lightPrimary : AppColors.lightTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: isSelected ? AppColors.lightPrimary : AppColors.lightTextSecondary,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // ==========================================
  // 2. KARANLIK TEMA — DEEP FOREST
  // ==========================================
  static ThemeData get darkTheme {
    final textTheme = _buildTextTheme(
      primaryText: AppColors.darkTextPrimary,
      secondaryText: AppColors.darkTextSecondary,
      mutedText: AppColors.textMutedDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.inter().fontFamily,
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.darkPrimary,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: Color(0xFF101C1B), // Koyu orman yeşili üstünde okunaklı
        primaryContainer: AppColors.darkSelected,
        onPrimaryContainer: AppColors.darkTextPrimary,
        secondary: AppColors.darkSecondary,
        onSecondary: Color(0xFF101C1B),
        secondaryContainer: AppColors.darkSelected,
        onSecondaryContainer: AppColors.darkTextPrimary,
        tertiary: AppColors.darkAccent,
        onTertiary: Color(0xFF101C1B),
        surface: AppColors.darkCard,
        onSurface: AppColors.darkTextPrimary,
        surfaceContainerHighest: AppColors.darkSelected,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.darkBorder,
        outlineVariant: AppColors.darkBorder,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkTextPrimary,
          size: 22,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        hintStyle: GoogleFonts.inter(
          color: AppColors.darkTextSecondary,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: const Color(0xFF101C1B),
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkCard,
        selectedColor: AppColors.darkSelected,
        side: const BorderSide(color: AppColors.darkBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkCard,
        indicatorColor: AppColors.darkSelected,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.darkPrimary : AppColors.darkTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: isSelected ? AppColors.darkPrimary : AppColors.darkTextSecondary,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
