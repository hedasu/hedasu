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
  static const Color badgeSpecial = Color(0xFFF0AA3C); // Özel 21. Gün (Sıcak Amber/Gold)

  // ==========================================
  // BAŞARI ROZETLERİ ÖZEL TEMA SABİTLERİ (Warm Gold / Cream / Deep Sage)
  // ==========================================

  // 1. 21 Gün: Bilimsel Alışkanlık Kartı
  static const Color specialCardBackground = Color(0xFFFFF9F0);
  static const Color specialCardBorder = Color(0xFFF1C98D);
  static const Color specialIconCircle = Color(0xFFF0AA3C);
  static const Color specialIconColor = Color(0xFFFFFFFF);
  static const Color specialTagBackground = Color(0xFFFCE6C4);
  static const Color specialTagText = Color(0xFF996018);
  static const Color specialTitleText = Color(0xFF29443B);
  static const Color specialDescText = Color(0xFF47534E);
  static const Color specialProgressActive = Color(0xFFEAA02D);
  static const Color specialProgressInactive = Color(0xFFE8E9E8);
  static const Color specialProgressText = Color(0xFFA76B13);

  // 2. Kazanılmış Rozetler (Unlocked Badges)
  static const Color badgeUnlockedIconBg = Color(0xFFFFE3B7);
  static const Color badgeUnlockedIconBorder = Color(0xFFB97716);
  static const Color badgeUnlockedIconColor = Color(0xFF95570C);
  static const Color badgeUnlockedGlow = Color(0xFFE7B86A);
  static const Color badgeCardBackground = Color(0xFFFFFFFF);
  static const Color badgeCardBorder = Color(0xFFD7E5DF);
  static const Color badgeUnlockedTitle = Color(0xFF29443B);
  static const Color badgeRewardTagBg = Color(0xFFFFF0D9);
  static const Color badgeRewardTagText = Color(0xFFB97213);

  // 3. Kilitli Rozetler (Locked Badges)
  static const Color badgeLockedIconBg = Color(0xFFF0F2F1);
  static const Color badgeLockedIconBorder = Color(0xFFD2D7D5);
  static const Color badgeLockedIconColor = Color(0xFFA0A5A3);
  static const Color badgeLockedTitle = Color(0xFF354A42);
  static const Color badgeProgressActive = Color(0xFFEAA02D);
  static const Color badgeProgressInactive = Color(0xFFE9ECEA);
  static const Color badgeProgressCount = Color(0xFF354A42);

  // 4. Başarı Rozetleri Karanlık Mod Renkleri (Dark Mode Badges)
  static const Color badgeCardBackgroundDark = Color(0xFF1A221E);
  static const Color badgeCardBorderDark = Color(0xFF2E3D34);
  static const Color badgeUnlockedIconBgDark = Color(0xFF2D2313);
  static const Color badgeUnlockedIconBorderDark = Color(0xFFB88226);
  static const Color badgeUnlockedIconColorDark = Color(0xFFF5BE53);
  static const Color badgeUnlockedGlowDark = Color(0xFFF5BE53);
  static const Color badgeUnlockedTitleDark = Color(0xFFE8EDE6);
  static const Color badgeRewardTagBgDark = Color(0xFF2A2214);
  static const Color badgeRewardTagTextDark = Color(0xFFE5A83E);

  static const Color badgeLockedIconBgDark = Color(0xFF202A24);
  static const Color badgeLockedIconBorderDark = Color(0xFF2D3B33);
  static const Color badgeLockedIconColorDark = Color(0xFF6E7D75);
  static const Color badgeLockedTitleDark = Color(0xFFA8B5AC);
  static const Color badgeProgressInactiveDark = Color(0xFF28342D);
  static const Color badgeProgressCountDark = Color(0xFFA8B5AC);

  static const Color specialCardBackgroundDark = Color(0xFF1E2621);
  static const Color specialCardBorderDark = Color(0xFF4A3A22);
  static const Color specialIconCircleDark = Color(0xFFD68F24);
  static const Color specialTagBackgroundDark = Color(0xFF332715);
  static const Color specialTagTextDark = Color(0xFFF0BD68);
  static const Color specialTitleTextDark = Color(0xFFE8EDE6);
  static const Color specialDescTextDark = Color(0xFFA8B5AC);

  // Alışkanlıkların Kendilerine Özgü Renkleri (Modern, pastel ve göz yormayan tonlar)
  // - Su İçme: Yumuşak Okyanus Mavisi #88BEE8
  // - Spor & Antrenman: Yumuşatılmış Sıcak Pişmiş Toprak / Turuncu #DF8D5B
  // - Yoga & Meditasyon: Dumanlı Lavanta #BDB0D2
  // - Sigara Bırakma: Yumuşatılmış Adaçayı / Nane #82C4A2
  // - Kitap Okuma: Yumuşatılmış Ilık Kehribar / Altın #DDB966
  static const Color habitWater = Color(0xFF88BEE8);
  static const Color habitSport = Color(0xFFDF8D5B);
  static const Color habitYoga = Color(0xFFBDB0D2);
  static const Color habitSmoking = Color(0xFF82C4A2);
  static const Color habitReading = Color(0xFFDDB966);

  // Yoga & Meditasyon Özel Renkleri
  static const Color yogaTextIcon = Color(0xFFBDB0D2);
  static const Color yogaCardBackground = Color(0xFF252430);
  static const Color yogaTagBackground = Color(0xFF393447);

  // Spor & Antrenman Özel Renkleri
  static const Color sportTextIcon = Color(0xFFDF8D5B);
  static const Color sportCardBackground = Color(0xFF2B231D);
  static const Color sportTagBackground = Color(0xFF3E2F26);

  // Kitap Okuma Özel Renkleri
  static const Color readingTextIcon = Color(0xFFDDB966);
  static const Color readingCardBackground = Color(0xFF2B271C);
  static const Color readingTagBackground = Color(0xFF3E3725);

  // Su İçme Özel Renkleri
  static const Color waterTextIcon = Color(0xFF88BEE8);
  static const Color waterCardBackground = Color(0xFF1B242D);
  static const Color waterTagBackground = Color(0xFF263645);

  // Sigara Bırakma Özel Renkleri
  static const Color smokingTextIcon = Color(0xFF82C4A2);
  static const Color smokingCardBackground = Color(0xFF192520);
  static const Color smokingTagBackground = Color(0xFF24372F);

  static Color getHabitCardBackground(String habitId, Color fallbackColor) {
    switch (habitId) {
      case 'habit_yoga':
        return yogaCardBackground;
      case 'habit_sport':
        return sportCardBackground;
      case 'habit_reading':
        return readingCardBackground;
      case 'habit_water':
        return waterCardBackground;
      case 'habit_smoking':
        return smokingCardBackground;
      default:
        return fallbackColor.withValues(alpha: 0.12);
    }
  }

  static Color getHabitTagBackground(String habitId, Color fallbackColor) {
    switch (habitId) {
      case 'habit_yoga':
        return yogaTagBackground;
      case 'habit_sport':
        return sportTagBackground;
      case 'habit_reading':
        return readingTagBackground;
      case 'habit_water':
        return waterTagBackground;
      case 'habit_smoking':
        return smokingTagBackground;
      default:
        return fallbackColor.withValues(alpha: 0.18);
    }
  }

  static Color getHabitTextAndIconColor(String habitId, Color fallbackColor) {
    switch (habitId) {
      case 'habit_yoga':
        return yogaTextIcon;
      case 'habit_sport':
        return sportTextIcon;
      case 'habit_reading':
        return readingTextIcon;
      case 'habit_water':
        return waterTextIcon;
      case 'habit_smoking':
        return smokingTextIcon;
      default:
        return fallbackColor;
    }
  }

  static const List<Color> habitColors = [
    habitSmoking, // #82C4A2 - Sigara Bırakma
    habitWater,   // #88BEE8 - Su İçme
    habitYoga,    // #BDB0D2 - Yoga (Dumanlı Lavanta)
    habitSport,   // #DF8D5B - Spor (Yumuşatılmış Turuncu)
    Color(0xFFE292A8), // Soft Rose
    habitReading, // #DDB966 - Kitap Okuma (Yumuşatılmış Kehribar/Altın)
    Color(0xFF6EC0CC), // Soft Pastel Cyan
    Color(0xFF6EA286), // Sage Green
  ];
}
