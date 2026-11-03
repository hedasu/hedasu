// -bu kod bloğunda uygulamanın karanlık (dark) ve aydınlık (light) tema durumunu ValueNotifier ile reaktif olarak yöneten ThemeController sınıfı anlatılıyor.-
// ThemeMode: Flutter'ın tema görünümünü belirleyen numaralandırma (enum) tipi. Üç değeri vardır: ThemeMode.dark, ThemeMode.light ve ThemeMode.system (cihaz ayarına göre).
// ValueNotifier<ThemeMode>: İçindeki ThemeMode değeri değiştiğinde onu dinleyen ValueListenableBuilder'ı (main.dart içindeki MaterialApp'i) otomatik tetikleyen yapı.

import 'package:flutter/material.dart'; // ThemeMode ve ValueNotifier sınıfları için gerekli paket.

/// Tema Durum Kontrolcüsü (ValueNotifier Tabanlı - Clean State)
class ThemeController { // Tema durumunu tutan ve değiştiren kontrolcü sınıfı.
  final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.dark); // Başlangıç değeri olarak karanlık temayı (ThemeMode.dark) seçer. | final: themeMode referansı değiştirilemez, sadece içindeki .value değiştirilir.

  bool get isDarkMode => themeMode.value == ThemeMode.dark; // get: Şu anki mod karanlık mı? (Karanlıksa true, aydınlıksa false döner). () kullanmadan özellik gibi erişilir.

  /// Koyu ve Açık mod arasında geçiş yapar
  void toggleTheme() { // toggleTheme(): Mevcut temayı tersine çevirir.
    themeMode.value =
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark; // Ternary operatörü: Şu an dark ise light yap, değilse dark yap. (.value değiştiği anda dinleyicilere haber gider).
  }

  /// Belirli bir tema modunu ayarlar
  void setThemeMode(ThemeMode mode) { // Doğrudan dışarıdan verilen bir modu (Örn: ThemeMode.system) atamak için kullanılır.
    themeMode.value = mode; // Yeni modu atar ve dinleyicileri uyarır.
  }

  void dispose() { // Kontrolcüyle işimiz bittiğinde bellekteki dinleyicileri temizler.
    themeMode.dispose(); // Bellek sızıntısını (memory leak) önlemek için ValueNotifier kapatılır.
  }
}

// ÇALIŞMA MANTIĞI:
// Kullanıcı AppBar'daki tema butonuna basar -> toggleTheme() çağrılır -> themeMode.value değişir (dark <-> light)
// -> main.dart içindeki ValueListenableBuilder bu değişimi yakalar -> MaterialApp yeni themeMode ile yeniden çizilir.

// VALUENOTIFIER (themeMode.value = ...) : Sadece tek bir değişkenin değişimini dinleyen hafif ve hızlı reaktif yapı
//  VS
// CHANGENOTIFIER : Birden fazla değişkeni bir arada tutup her değişimde manuel olarak notifyListeners() çağırmayı gerektiren daha geniş kapsamlı yapı
