// -bu kod bloğunda uygulamanın Karanlık (Dark Obsidian) ve Aydınlık (Clean Minimalist Gym) temaları için renk paleti ve dinamik tema yardımcı metotları anlatılıyor.-
// static const: Sınıfın nesnesini oluşturmadan (AppColors() yazmadan) doğrudan AppColors.neonCyan şeklinde erişilebilen ve derleme zamanında bellekte tek bir kez oluşturulan sabitler.
// const AppColors._(): Gizli (private) kurucu metot. Bu sınıftan yanlışlıkla nesne üretilmesini (new AppColors()) engeller, çünkü bu sınıf sadece sabitleri ve yardımcı metotları tutan bir araç kutusudur.
// Hex Renk Kodu (0xFF...): İlk iki hane (FF) opaklık (alfa) değerini (%100 görünür), sonraki 6 hane ise RGB (Kırmızı, Yeşil, Mavi) renk kodunu temsil eder (0x33 ise ~%20 saydam parlama/glow rengidir).

import 'package:flutter/material.dart'; // Color, BuildContext, Theme ve Brightness sınıfları için gerekli paket.

/// Dark Obsidian & Fresh Neon Spor Salonu Renk Paleti (Karanlık ve Aydınlık Uyumlu)
class AppColors {
  const AppColors._(); // _: Private isimlendirilmiş kurucu. Dışarıdan bu sınıfın örneğinin (instance) oluşturulmasını tamamen kapatır.

  // Koyu Tema Renkleri (Dark Obsidian)
  static const Color darkBackground = Color(0xFF0D0F14); // Koyu mod ana sayfa arka plan rengi (çok koyu lacivert/siyah).
  static const Color darkSurface = Color(0xFF161A23); // Koyu mod kart ve bar yüzey rengi.
  static const Color darkSurfaceLight = Color(0xFF1F2533); // Koyu mod ikincil/vurgulu yüzey rengi.
  static const Color darkSurfaceBorder = Color(0xFF2C3549); // Koyu mod kart çerçeve (border) rengi.
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // Koyu mod ana metin rengi (tam beyaz).
  static const Color darkTextSecondary = Color(0xFF90A4AE); // Koyu mod alt başlık ve açıklama metni rengi (açık gri-mavi).
  static const Color darkTextMuted = Color(0xFF546E7A); // Koyu mod pasif/kilitli öğe metin rengi (soluk gri).

  // Aydınlık Tema Renkleri (Clean Minimalist Gym)
  static const Color lightBackground = Color(0xFFF6F8FC); // Aydınlık mod ana arka plan rengi (kırık beyaz / buz grisi).
  static const Color lightSurface = Color(0xFFFFFFFF); // Aydınlık mod kart yüzey rengi (saf beyaz).
  static const Color lightSurfaceLight = Color(0xFFEEF2F6); // Aydınlık mod ikincil yüzey rengi.
  static const Color lightSurfaceBorder = Color(0xFFD7DFE9); // Aydınlık mod kart çerçeve rengi.
  static const Color lightTextPrimary = Color(0xFF0F172A); // Aydınlık mod ana metin rengi (çok koyu arduvaz).
  static const Color lightTextSecondary = Color(0xFF475569); // Aydınlık mod ikincil metin rengi.
  static const Color lightTextMuted = Color(0xFF94A3B8); // Aydınlık mod pasif/soluk metin rengi.

  // Sabit Geriye Uyumluluk Değerleri (Varsayılan Koyu)
  // NOT: Dinamik context kullanmayan eski veya sabit bileşenlerin hata vermemesi için varsayılan koyu renkleri referans alır.
  static const Color background = darkBackground;
  static const Color surface = darkSurface;
  static const Color surfaceLight = darkSurfaceLight;
  static const Color surfaceBorder = darkSurfaceBorder;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textMuted = darkTextMuted;

  // Neon Vurgu Renkleri (Her iki temada da canlı ve dinamik)
  static const Color neonCyan = Color(0xFF00E5FF);       // Su & Hidrasyon ana neon mavi rengi.
  static const Color neonCyanDarker = Color(0xFF0091EA); // Aydınlık modda beyaz zemin üzerinde okunabilirliği (kontrastı) artırmak için koyulaştırılmış mavi.
  static const Color neonCyanGlow = Color(0x3300E5FF);   // 0x33 (%20 opaklık): Kartların altına verilen mavi neon parlama (boxShadow) rengi.
  
  static const Color neonGreen = Color(0xFF00E676);      // Fitness & Egzersiz ana neon yeşil rengi.
  static const Color neonGreenDarker = Color(0xFF00C853); // Aydınlık mod için koyulaştırılmış yeşil.
  static const Color neonGreenGlow = Color(0x3300E676);   // Yeşil neon parlama (glow) rengi.
  
  static const Color neonGold = Color(0xFFFFD700);       // Rozet & Başarı ana altın sarısı rengi.
  static const Color neonGoldDarker = Color(0xFFFFB300); // Aydınlık modda parlamayı önleyen kehribar/koyu altın rengi.
  static const Color neonGoldGlow = Color(0x33FFD700);   // Altın sarısı neon parlama rengi.
  
  static const Color neonOrange = Color(0xFFFF6D00);     // Kalori & Yoğunluk ve Geri Al (Undo) vurgu rengi.
  static const Color neonOrangeGlow = Color(0x33FF6D00); // Turuncu parlama/çerçeve rengi.

  static const Color error = Color(0xFFFF5252);   // Hata bildirim rengi (kırmızı).
  static const Color success = Color(0xFF00E676); // Başarı bildirim rengi (yeşil).

  // Dinamik Context Yardımcıları
  // ÖNEMLİ: Widget'ların içinde 'isDark ? darkSurface : lightSurface' şeklinde uzun koşullar yazmak yerine,
  // doğrudan 'AppColors.surfaceOf(context)' çağrılarak aktif temaya uygun renk tek satırda alınır.
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark; // Theme.of(context): Widget ağacındaki aktif temayı bulur ve karanlık modda olup olmadığını (true/false) döndürür.

  static Color backgroundOf(BuildContext context) =>
      isDark(context) ? darkBackground : lightBackground; // Karanlıksa darkBackground, aydınlıksa lightBackground döner.

  static Color surfaceOf(BuildContext context) =>
      isDark(context) ? darkSurface : lightSurface; // Aktif temaya göre kart yüzey rengini döner.

  static Color surfaceLightOf(BuildContext context) =>
      isDark(context) ? darkSurfaceLight : lightSurfaceLight; // Aktif temaya göre açık yüzey rengini döner.

  static Color surfaceBorderOf(BuildContext context) =>
      isDark(context) ? darkSurfaceBorder : lightSurfaceBorder; // Aktif temaya göre kenarlık rengini döner.

  static Color textPrimaryOf(BuildContext context) =>
      isDark(context) ? darkTextPrimary : lightTextPrimary; // Aktif temaya göre ana yazı rengini döner.

  static Color textSecondaryOf(BuildContext context) =>
      isDark(context) ? darkTextSecondary : lightTextSecondary; // Aktif temaya göre ikincil yazı rengini döner.

  static Color textMutedOf(BuildContext context) =>
      isDark(context) ? darkTextMuted : lightTextMuted; // Aktif temaya göre soluk yazı rengini döner.

  static Color cyanOf(BuildContext context) =>
      isDark(context) ? neonCyan : neonCyanDarker; // Aydınlık modda gözü yormayan koyu mavi, karanlıkta parlak neon mavi döner.

  static Color greenOf(BuildContext context) =>
      isDark(context) ? neonGreen : neonGreenDarker; // Aktif temaya göre kontrastı optimize edilmiş yeşil döner.

  static Color goldOf(BuildContext context) =>
      isDark(context) ? neonGold : neonGoldDarker; // Aktif temaya göre kontrastı optimize edilmiş altın rengi döner.
}

// ÇALIŞMA MANTIĞI:
// Bir widget kendi build(context) metodunda AppColors.surfaceOf(context) çağırır -> surfaceOf() içeride isDark(context) metodunu çalıştırır
// -> Theme.of(context).brightness kontrol edilir -> Tema karanlıksa darkSurface, aydınlıksa lightSurface rengi widget'a teslim edilir.

// SABİT RENK KULLANIMI (AppColors.darkSurface) : Tema değişse bile widget hep koyu renkte kalır, aydınlık modda tasarım bozulur
//  VS
// DİNAMİK CONTEXT YARDIMCISI (AppColors.surfaceOf(context)) : Aktif temayı otomatik algılar, tek bir kodla hem karanlık hem aydınlık modda kusursuz görünüm sağlar
