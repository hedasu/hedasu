// -bu kod bloğunda uygulamanın Material 3 tabanlı Koyu (darkTheme) ve Aydınlık (lightTheme) ThemeData yapılandırmaları anlatılıyor.-
// ThemeData: Bir Flutter uygulamasının tüm görsel kimliğini (renk şeması, kart tasarımları, buton stilleri, yazı tipleri) tek merkezden belirleyen yapılandırma sınıfı.
// ColorScheme: Material 3 tasarım sisteminde birincil (primary), ikincil (secondary), yüzey (surface) ve hata (error) renklerini birbiriyle uyumlu şekilde gruplayan renk paleti.
// WidgetStateProperty: Bir bileşenin durumuna göre (seçili, basılı, devre dışı vb.) farklı stil veya renk döndürmeyi sağlayan dinamik yapı.

import 'package:flutter/material.dart'; // ThemeData ve alt tema sınıfları için gerekli paket.
import '../constants/app_colors.dart'; // Renk sabitlerimizi içeren dosya.

/// Material 3 Dinamik Koyu ve Aydınlık Tema Yapılandırması
class AppTheme {
  const AppTheme._(); // Bu sınıftan nesne üretilmesini engelleyen private kurucu.

  /// Koyu Tema (Dark Obsidian & Neon)
  static ThemeData get darkTheme { // get darkTheme: AppTheme.darkTheme çağrıldığında koyu tema ayarlarını içeren ThemeData nesnesini döndürür.
    return ThemeData(
      useMaterial3: true, // Google'ın en güncel Material 3 tasarım dilini aktif eder.
      brightness: Brightness.dark, // Temanın genel parlaklık modunu karanlık olarak işaretler (sistem ikonları ve varsayılan metinler buna göre şekillenir).
      scaffoldBackgroundColor: AppColors.darkBackground, // Tüm Scaffold'ların varsayılan arka plan rengi.
      colorScheme: const ColorScheme.dark( // Karanlık mod için ana renk şeması.
        surface: AppColors.darkSurface, // Kartların ve panellerin varsayılan yüzey rengi.
        primary: AppColors.neonCyan, // Ana vurgu rengi (Su mavisi).
        secondary: AppColors.neonGreen, // İkincil vurgu rengi (Egzersiz yeşili).
        tertiary: AppColors.neonGold, // Üçüncül vurgu rengi (Rozet altını).
        error: AppColors.error, // Hata durumlarında kullanılacak kırmızı renk.
        outline: AppColors.darkSurfaceBorder, // Çerçeve ve ayırıcı çizgilerin rengi.
      ),
      appBarTheme: const AppBarTheme( // Uygulamadaki tüm AppBar'ların varsayılan görünümü.
        backgroundColor: AppColors.darkBackground, // AppBar arka plan rengi.
        elevation: 0, // Gölgeyi sıfırlar (düz ve modern görünüm).
        centerTitle: false, // Başlığı sola hizalar.
        scrolledUnderElevation: 0, // Sayfa aşağı kaydırıldığında AppBar'ın renginin değişmesini/gölgelenmesini engeller.
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5, // Harfler arası 0.5 piksellik ferah boşluk.
        ),
        iconTheme: IconThemeData(color: AppColors.neonCyan), // AppBar içindeki ikonların varsayılan rengi.
      ),
      cardTheme: CardThemeData( // Tüm Card widget'larının varsayılan stili.
        color: AppColors.darkSurface,
        elevation: 4, // Kartın zeminden yüksekliği (gölge derinliği).
        shadowColor: Colors.black54, // Gölge rengi (%54 opak siyah).
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // 16 piksel yuvarlatılmış köşeler.
          side: const BorderSide(color: AppColors.darkSurfaceBorder, width: 1), // 1 piksel kalınlığında kenarlık.
        ),
      ),
      navigationBarTheme: NavigationBarThemeData( // Alt menü (NavigationBar) varsayılan stili.
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.darkSurfaceLight, // Seçili sekme vurgu rengi.
        labelTextStyle: WidgetStateProperty.resolveWith((states) { // resolveWith(): Sekmenin o anki durumuna (states) bakarak farklı yazı stili döndürür.
          if (states.contains(WidgetState.selected)) { // Eğer sekme SEÇİLİ ise (WidgetState.selected):
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold, // Kalın ve beyaz yazı.
              color: AppColors.darkTextPrimary,
            );
          }
          return const TextStyle( // Seçili DEĞİLSE:
            fontSize: 12,
            color: AppColors.darkTextSecondary, // Normal kalınlıkta ve soluk gri yazı.
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData( // Dolgulu ana butonların (ElevatedButton) varsayılan stili.
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonCyan, // Butonun iç dolgu rengi.
          foregroundColor: AppColors.darkBackground, // Butonun üzerindeki yazı ve ikon rengi (kontrast için koyu renk).
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData( // Çerçeveli butonların (OutlinedButton) varsayılan stili.
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neonCyan, // Yazı ve ikon rengi.
          side: const BorderSide(color: AppColors.neonCyan, width: 1.5), // Çerçeve rengi ve kalınlığı.
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData( // Ekranın altında çıkan bildirim çubuklarının (SnackBar) varsayılan stili.
        backgroundColor: AppColors.darkSurfaceLight,
        contentTextStyle: const TextStyle(color: AppColors.darkTextPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating, // Bildirimi ekranın alt kenarından hafif yukarıda (yüzer şekilde) gösterir.
      ),
    );
  }

  /// Aydınlık Tema (Clean Minimalist Gym)
  static ThemeData get lightTheme { // get lightTheme: AppTheme.lightTheme çağrıldığında aydınlık tema ayarlarını döndürür.
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light, // Parlaklık modunu aydınlık olarak ayarlar.
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light( // Aydınlık mod için optimize edilmiş renk şeması.
        surface: AppColors.lightSurface,
        primary: AppColors.neonCyanDarker, // Beyaz zeminde parlamaması için koyulaştırılmış neon renkler kullanılır.
        secondary: AppColors.neonGreenDarker,
        tertiary: AppColors.neonGoldDarker,
        error: AppColors.error,
        outline: AppColors.lightSurfaceBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.neonCyanDarker),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        shadowColor: const Color(0x1A000000), // 0x1A (%10 opaklık): Aydınlık mod için çok yumuşak siyah gölge.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightSurfaceBorder, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.lightSurfaceLight,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.lightTextPrimary,
            );
          }
          return const TextStyle(
            fontSize: 12,
            color: AppColors.lightTextSecondary,
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonCyanDarker,
          foregroundColor: Colors.white, // Koyu mavi buton üzerinde beyaz yazı.
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neonCyanDarker,
          side: const BorderSide(color: AppColors.neonCyanDarker, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightSurface,
        contentTextStyle: const TextStyle(color: AppColors.lightTextPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// MaterialApp başlarken theme: AppTheme.lightTheme ve darkTheme: AppTheme.darkTheme parametrelerini alır
// -> ThemeController hangi modu (light/dark) seçerse Flutter otomatik olarak ilgili ThemeData'yı devreye sokar
// -> Uygulamadaki tüm AppBar, Card, Button ve SnackBar'lar ekstra stil koduna gerek kalmadan yeni temaya bürünür.

// YEREL (INLINE) STİL TANIMLAMA : Her butona ve karta tek tek renk/şekil yazılır, kod tekrarı artar ve tasarım değişikliği yapmak zorlaşır
//  VS
// MERKEZİ THEMEDATA (AppTheme) : Tüm bileşenlerin stili tek dosyada tanımlanır, uygulama genelinde tasarım tutarlılığı ve kolay bakım sağlanır
