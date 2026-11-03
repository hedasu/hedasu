// -bu dosyada uygulamanın "Gece Spor Salonu (Dark Obsidian & Neon)" konseptine ait tüm renk sabitleri merkezi bir sınıfta toplanarak anlatılıyor.-
// abstract final class : Hem soyut (`abstract` - doğrudan `AppColors()` şeklinde nesnesi üretilemez) hem de son (`final` - başka bir sınıf tarafından `extends` veya `implements` edilemez) bir sabitler konteyneridir.
// static const : Değişkenin sınıfa ait olduğunu (`static` - nesne üretmeden `AppColors.neonCyan` şeklinde doğrudan erişilebildiğini) ve derleme zamanında sabitlendiğini (`const` - bellekte tek bir kopya olarak tutulduğunu) belirtir.
// Color(0xFF......) : 16'lık (Hexadecimal) sayı sisteminde ARGB (Alpha, Red, Green, Blue) renk kodunu tanımlar. Başındaki `0xFF` tam görünürlüğü (%100 opaklık / Alpha = 255), sonraki 6 hane ise RGB renk kodunu ifade eder.

import 'package:flutter/material.dart'; // material.dart : Color sınıfını kullanabilmek için içe aktarılır.

/// Gece Spor Salonu (Dark Obsidian & Neon) konseptine ait renk sabitleri.
abstract final class AppColors { // abstract final class : Sadece static sabitleri gruplamak (namespace oluşturmak) için en güvenli Dart 3 sınıf tanımıdır.
  // Arka Plan ve Yüzeyler (Dark Obsidian)
  static const Color background = Color(0xFF0F0F12); // background : Sayfaların (Scaffold) en alt zemininde kullanılan en koyu obsidyen siyahı.
  static const Color surface = Color(0xFF18181D); // surface : Kartların (Card, Container) ve alt navigasyon barının ana yüzey rengi (zeminden bir ton açık).
  static const Color surfaceVariant = Color(0xFF22222A); // surfaceVariant : İlerleme çubuğu (ProgressIndicator) arka planları ve ikincil/pasif kutuların rengi.
  static const Color cardBorder = Color(0xFF2E2E38); // cardBorder : Kartların etrafını saran ince çerçeve (border) ve ayırıcı çizgi rengi.

  // Neon Vurgu Renkleri
  static const Color neonCyan = Color(0xFF00E5FF);       // Su takibi vurgusu | Ana etkileşim, su damlası ve birincil buton rengi.
  static const Color neonLime = Color(0xFF76FF03);       // Egzersiz & Tamamlanma vurgusu | Hedefe ulaşıldığında veya rozet açıldığında parlayan fosforlu yeşil.
  static const Color neonOrange = Color(0xFFFF6D00);     // Kalori & Efor vurgusu | Yakılan kalori, ateş ikonu ve azaltma/geri alma uyarı rengi.
  static const Color neonPurple = Color(0xFFD500F9);     // Hedef & Başarı vurgusu | HIIT egzersizi ve özel vurgu alanları için neon mor.

  // Metin Renkleri
  static const Color textPrimary = Color(0xFFF5F5F7); // textPrimary : Ana başlıklar ve önemli rakamlar için göz yormayan kırık beyaz.
  static const Color textSecondary = Color(0xFFA0A0B2); // textSecondary : Alt başlıklar ve açıklama metinleri için açık gri-eflatun tonu.
  static const Color textMuted = Color(0xFF6B6B7E); // textMuted : Pasif butonlar, kilitli rozetler ve saat/birim gibi düşük öncelikli yazılar için soluk gri.

  // Durum Renkleri
  static const Color success = Color(0xFF00E676); // success : Başarılı işlemler için standart onay yeşili.
  static const Color error = Color(0xFFFF1744); // error : Silme, hata veya kritik uyarı durumları için neon kırmızı.
  static const Color warning = Color(0xFFFFAB00); // warning : Dikkat gerektiren durumlar için kehribar sarısı.
}

// ÇALIŞMA MANTIĞI: Tasarımda bir renk gerektiğinde doğrudan hex kodu (0xFF...) yazılmaz -> AppColors.neonCyan çağrılır -> Tüm uygulama tek merkezden tutarlı renklerle boyanır (İleride renk değişirse sadece bu dosya güncellenir).

// CONST (Compile-Time Constant) : Değeri kod derlenirken (uygulama daha çalışmadan önce) kesin olarak bilinen ve bellekte dondurulan sabitlerdir.
//  VS
// FINAL (Runtime Constant) : Değeri uygulama çalışırken (runtime) hesaplanıp bir kez atanan ve sonrasında değiştirilemeyen değişkenlerdir.
