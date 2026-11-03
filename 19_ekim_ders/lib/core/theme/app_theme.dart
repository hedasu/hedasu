// -bu dosyada uygulamanın Material 3 tasarım sistemine uygun Koyu Tema (ThemeData) yapılandırması ve tüm standart widget'ların (AppBar, Card, Button, NavigationBar, Text) merkezi stil kuralları anlatılıyor.-
// ThemeData : Flutter uygulamasının genel görünümünü (renk şeması, yazı tipleri, buton ve kart stilleri) tek bir çatı altında tutan yapılandırma sınıfıdır.
// ColorScheme : Material 3 bileşenlerinin hangi durumda hangi rengi (primary, secondary, surface, error vb.) kullanacağını belirleyen renk paletidir.
// WidgetStateProperty.resolveWith : Bir bileşenin o anki etkileşim durumuna (seçili mi, basılı mı, devre dışı mı - `WidgetState`) bakarak dinamik stil/renk döndürmeyi sağlar.

import 'package:flutter/material.dart'; // material.dart : ThemeData, ColorScheme ve tüm alt tema sınıflarını içerir.
import '../constants/app_colors.dart'; // app_colors.dart : Tema içinde kullanacağımız özel neon ve obsidyen renk sabitleri.

/// Susadım uygulaması Material 3 Koyu Tema (Night Gym / Dark Obsidian & Neon) yapılandırması.
abstract final class AppTheme { // abstract final class : Nesnesi üretilemeyen ve miras alınamayan, sadece tema ayarlarını barındıran sınıf.
  static ThemeData get darkTheme { // get darkTheme : Çağrıldığında (`AppTheme.darkTheme`) yapılandırılmış bir ThemeData nesnesi döndüren statik getter.
    final colorScheme = ColorScheme( // ColorScheme : Material 3 renk rollerini bizim özel AppColors renklerimizle eşleştirir.
      brightness: Brightness.dark, // Brightness.dark : Temanın koyu modda olduğunu sisteme bildirir (durum çubuğu ikonlarını açık renk yapar).
      primary: AppColors.neonCyan, // primary : Uygulamanın ana vurgu rengi (Su mavisi / Neon Cyan).
      onPrimary: AppColors.background, // onPrimary : Primary rengin (neonCyan) ÜZERİNE yazılacak metin/ikon rengi (okunabilirlik için koyu arka plan rengi).
      primaryContainer: AppColors.surfaceVariant, // primaryContainer : Birincil vurgu kutularının arka plan rengi.
      onPrimaryContainer: AppColors.neonCyan, // onPrimaryContainer : PrimaryContainer üzerine gelecek içerik rengi.
      secondary: AppColors.neonLime, // secondary : İkincil vurgu rengi (Egzersiz ve başarılar için Neon Lime).
      onSecondary: AppColors.background, // onSecondary : Neon Lime zemin üzerindeki yazı/ikon rengi.
      secondaryContainer: AppColors.surfaceVariant, // secondaryContainer : İkincil kapsayıcıların arka planı.
      onSecondaryContainer: AppColors.neonLime, // onSecondaryContainer : İkincil kapsayıcı üzerindeki vurgu rengi.
      tertiary: AppColors.neonOrange, // tertiary : Üçüncül vurgu rengi (Kalori ve efor için Neon Turuncu).
      onTertiary: AppColors.background, // onTertiary : Turuncu zemin üzerindeki yazı/ikon rengi.
      error: AppColors.error, // error : Hata durumlarında kullanılacak ana renk.
      onError: AppColors.textPrimary, // onError : Hata rengi üzerindeki yazı rengi.
      surface: AppColors.surface, // surface : Kart, diyalog ve menü gibi yüzeylerin varsayılan arka plan rengi.
      onSurface: AppColors.textPrimary, // onSurface : Yüzeylerin üzerindeki varsayılan metin rengi.
      surfaceContainerHighest: AppColors.surfaceVariant, // surfaceContainerHighest : En üst katman yüzey varyantı rengi.
      outline: AppColors.cardBorder, // outline : Çerçeve ve kenarlıkların varsayılan rengi.
    );

    return ThemeData( // ThemeData : Tüm alt bileşen temalarını birleştirip MaterialApp'e teslim eden ana nesne.
      useMaterial3: true, // useMaterial3: true : En güncel Material Design 3 tasarım dilini aktif eder.
      brightness: Brightness.dark, // Genel parlaklık modunu koyu olarak ayarlar.
      scaffoldBackgroundColor: AppColors.background, // scaffoldBackgroundColor : Uygulamadaki tüm Scaffold sayfalarının varsayılan zemin rengi.
      colorScheme: colorScheme, // Yukarıda hazırladığımız özel renk şemasını temaya bağlar.

      // AppBar Teması
      appBarTheme: const AppBarTheme( // AppBarTheme : Uygulamadaki tüm üst başlık çubuklarının (AppBar) ortak görünümü.
        backgroundColor: AppColors.background, // Arka planı sayfa zeminiyle aynı yaparak bütünlük sağlar.
        foregroundColor: AppColors.textPrimary, // Başlık ve ikonların varsayılan rengi.
        elevation: 0, // elevation: 0 : AppBar'ın altındaki gölgeyi kaldırır (düz/modern görünüm).
        scrolledUnderElevation: 0, // ÖNEMLİ: Sayfa aşağı kaydırıldığında Material 3'ün AppBar rengini otomatik değiştirmesini/gölge eklemesini engeller.
        centerTitle: false, // centerTitle: false : Başlığı ortalamak yerine sola yaslar.
        titleTextStyle: TextStyle( // titleTextStyle : AppBar başlık metninin yazı stili.
          color: AppColors.textPrimary, // Metin rengi : Kırık beyaz.
          fontSize: 20, // Yazı boyutu : 20 birim.
          fontWeight: FontWeight.bold, // Kalınlık : Kalın (bold).
          letterSpacing: 0.5, // Harfler arası boşluk : 0.5 birim.
        ),
      ),

      // Kart Teması
      cardTheme: CardThemeData( // CardThemeData : Card widget'larının varsayılan şekil ve renk kuralları.
        color: AppColors.surface, // Kart içi yüzey rengi.
        elevation: 0, // Gölge yerine neon/çerçeve kullanıldığı için yüksekliği sıfırlanır.
        margin: EdgeInsets.zero, // Dış boşluğu sıfırlar (boşluklar sayfa düzeninde SizedBox/padding ile kontrol edilir).
        shape: RoundedRectangleBorder( // RoundedRectangleBorder : Köşeleri yuvarlatılmış dikdörtgen form.
          borderRadius: BorderRadius.circular(20), // 20 birim köşe yuvarlatma.
          side: const BorderSide( // BorderSide : Kartın dış çerçeve çizgisi.
            color: AppColors.cardBorder, // Çerçeve rengi.
            width: 1, // Çerçeve kalınlığı : 1 piksel.
          ),
        ),
      ),

      // Buton Temaları
      elevatedButtonTheme: ElevatedButtonThemeData( // ElevatedButtonThemeData : Dolgulu ana aksiyon butonlarının (ElevatedButton) stili.
        style: ElevatedButton.styleFrom( // styleFrom : Buton stilini hızlıca oluşturmak için yardımcı fabrika metodu.
          backgroundColor: AppColors.neonCyan, // Butonun dolgu rengi : Neon Cyan.
          foregroundColor: AppColors.background, // Butonun içindeki yazı ve ikon rengi : Koyu arka plan rengi.
          elevation: 0, // Kabartma gölgesini kapatır.
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), // İç boşluk : Yatayda 20, dikeyde 14 birim.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14), // Köşeleri 14 birim yuvarlatır.
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700, // w700 : Bold kalınlık.
            letterSpacing: 0.3,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData( // OutlinedButtonThemeData : İçi boş, etrafı çizgili butonların (OutlinedButton) stili.
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neonCyan, // Yazı ve tıklama dalgası (ripple) rengi.
          side: const BorderSide(color: AppColors.neonCyan, width: 1.2), // Dış çerçeve rengi ve 1.2 piksel kalınlığı.
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600, // w600 : Semi-bold (yarı kalın).
          ),
        ),
      ),

      // Alt Navigasyon Barı
      navigationBarTheme: NavigationBarThemeData( // NavigationBarThemeData : Alt menü çubuğunun (NavigationBar) merkezi görünüm ayarları.
        backgroundColor: AppColors.surface, // Alt barın zemin rengi.
        indicatorColor: AppColors.neonCyan.withValues(alpha: 0.2), // indicatorColor : Seçili sekme ikonunun arkasındaki hap şeklindeki vurgu rengi (%20 opaklıkta Neon Cyan).
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) { // states : Sekmenin o anki durum kümesini (Set<WidgetState>) verir.
          if (states.contains(WidgetState.selected)) { // Eğer bu sekme şu an SEÇİLİ ise:
            return const TextStyle(
              color: AppColors.neonCyan, // Yazıyı parlak Neon Cyan yap.
              fontSize: 12,
              fontWeight: FontWeight.w700, // Kalınlaştır.
            );
          }
          return const TextStyle( // Seçili DEĞİLSE (varsayılan durum):
            color: AppColors.textMuted, // Yazıyı soluk gri yap.
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) { // Sekme ikonlarının seçili olma durumuna göre rengini belirler.
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.neonCyan, size: 24); // Seçiliyse Neon Cyan ikon.
          }
          return const IconThemeData(color: AppColors.textMuted, size: 24); // Seçili değilse soluk gri ikon.
        }),
      ),

      // SnackBar Teması
      snackBarTheme: SnackBarThemeData( // SnackBarThemeData : Ekranın altından çıkan bilgilendirme mesajlarının (SnackBar) stili.
        backgroundColor: AppColors.surfaceVariant, // Bildirim kutusu arka plan rengi.
        contentTextStyle: const TextStyle(color: AppColors.textPrimary), // Bildirim metni rengi.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        behavior: SnackBarBehavior.floating, // SnackBarBehavior.floating : Bildirimin ekranın en altına yapışmak yerine kenarlardan boşluk bırakarak havada durmasını sağlar.
      ),

      // Tipografi
      textTheme: const TextTheme( // TextTheme : Uygulama genelindeki standart metin boyut ve kalınlık hiyerarşisi.
        headlineMedium: TextStyle( // Büyük ekran/bölüm başlıkları için stil.
          color: AppColors.textPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w800, // Extra-bold.
          letterSpacing: -0.5, // Harfleri hafifçe birbirine yaklaştırır (modern başlık görünümü).
        ),
        titleLarge: TextStyle( // Kart ve alt bölüm başlıkları için stil.
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle( // Ana içerik metinleri için stil.
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w400, // Normal kalınlık.
        ),
        bodyMedium: TextStyle( // İkincil açıklama metinleri için stil.
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        labelSmall: TextStyle( // Küçük bilgi etiketleri için stil.
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI: AppTheme.darkTheme çağrılır -> ColorScheme renk rolleri atanır -> Alt widget temaları (AppBar, Card, NavigationBar vb.) bu şemayla birleştirilir -> MaterialApp tüm alt ağaca bu stili otomatik uygular.

// MERKEZİ TEMA (ThemeData) : Tüm buton, kart ve yazı stillerini tek bir dosyada tanımlayıp uygulama genelinde otomatik kullanmaktır; bakımı çok kolaydır.
//  VS
// SATIR İÇİ STİL (Inline Styling) : Her widget'ın içine tek tek renk ve boyut yazmaktır; tasarım değiştiğinde yüzlerce dosyayı tek tek düzeltmek gerekir.
