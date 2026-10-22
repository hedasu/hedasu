# Alışkanlık Takip Uygulaması
Bu doküman flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılşım geliştiriciler için bağlayıcı bir kılavuzdur.Projede yazılan her kod satırı buradaki kurallara UYMAK ZORUNDADIR

##1. Proje Özeti ve Teknolojiler

-**Uygulama Adı:** habiPEt (sanal evcil hayvan edinme ve alışkanlık takip uygulaması)

-**Hedef Platformlar:** ios ve android öncelikli ardından web ve masaüstü platformları

-**Flutter SDK:** 3.29.0

-**Dart SDK:** 3.10.2

-**Tasarım Dili:** Tasarım Dili: Material 3, Dinamik Tema Desteği: Koyu tema (gece ormanı konsepti, dark navy & mint yeşili vurgular) ve Aydınlık tema (ferah doğa konsepti, temiz beyaz & pastel mint yeşili tonları). Modern, minimal, sevimli ve yuvarlatılmış kartlardan oluşan bir arayüz. Kullanıcı tek dokunuşla aydınlık ve koyu tema arasında geçiş yapabilir.

-**Eklenen Özellikler:** - **Eklenen Özellikler:** **habiPEt Evcil Hayvan Sistemi:** Kullanıcı, sunulan seçenekler arasından bir evcil hayvan seçer ,isimlendirir.hayvanı veya ismi istediği zaman değiştirebilir. Hayvan değiştirildiğinde önceki hayvanın tüm gelişimi yeni hayvana aktarılır. Evcil hayvanın yaşı, kullanıcının uygulamadaki kullanım süresine göre ilerler (uygulamanın 3. ayında 3 aylık bir evcil hayvan). Hayvanın yaşı ve seviyesi gösterilir; seviyesi beslendikçe artar. **Alışkanlık Sistemi:** Su içme, spor, yoga/meditasyon, sigara bırakma ve kitap okuma alışkanlıkları sunulur. Kullanıcı istediği kadar özel alışkanlık ekleyebilir. Her alışkanlığın başlangıç tarihi, gün sayacı ve rozet ilerlemesi ayrı takip edilir. İkinci, üçüncü ve sonraki alışkanlıklar eklendiğinde bunlara özel ekstra rozetler kazanılır. **Rozet ve Ödül Sistemi:** Alışkanlıklar tamamlandıkça günlük, haftalık, aylık ve yıllık rozetler kazanılır. İlk üç gün kazanılan rozet ödülü kademeli olarak artar; üçüncü günden sonra günlük kazanım sabitlenir. İlk aya kadar haftalık ödüller kademeli artar, sonrasında aylık dönemlere göre artış uygulanır. Rozetlerin değer sıralaması **Yıllık > Aylık > Haftalık > Günlük** şeklindedir. Aynı kategorideki rozetler ortak bir görsel tasarıma sahiptir. Alışkanlığa başlama, 1. gün, 3. gün, ilk hafta, 21. gün (bilimsel alışkanlık kazanma temalı özel ödül), ilk ay, 3. ay, 6. ay ve 1. yıl için özel isimlendirilmiş başarı rozetleri bulunur. **Market ve Beslenme Sistemi:** Kullanıcı, alışkanlıklarından kazandığı rozetleri markette harcayarak evcil hayvanı için yiyecek satın alır. Satın alınan yiyecekler dolaba eklenir ve hayvan bu yiyeceklerle beslenir. Ana sayfada evcil hayvanın altında yatay kaydırılabilir bir yiyecek dolabı alanı bulunur. Dolap simgesine basıldığında dolap açılır; dolap içerisindeki aktif **+** butonu kullanıcıyı markete yönlendirir. **Ana Sayfa:** Bildirimler, evcil hayvan ekleme/değiştirme, market ve rozet göstergesi için aktif butonlar bulunur. Evcil hayvanın yaşı, seviyesi ve yiyecek dolabı gösterilir. **Takvim Modülü:** Standart takvim görünümünde kullanıcıların alışkanlıkları, isimleri ve kazanılan rozetleri ilgili tarihlerde gösterilir. Kullanıcı, alışkanlık ekleme aşamasında alışkanlığın adını, takvimde görünecek yazı rengini ve diğer görünüm tercihlerini Apple Takvim benzeri şekilde özelleştirebilir. Birden fazla alışkanlık takvimde ayrı ayrı görüntülenir. **Başarı Rozetleri Modülü:** Kazanılmış rozetler belirgin, henüz kazanılmamış rozetler daha silik görüntülenir. Kilitli rozetlerin altında hedef ilerlemesi gösterilir (örneğin 21. gün rozetine ilerleyen kullanıcı için **16/21**). Günlük, haftalık, aylık, yıllık ve özel başarı rozetleri kategorilerine göre görüntülenir. **Karşılama Diyaloğu:** Kullanıcı uygulamayı her açtığında güncel ilerlemesini belirten motivasyon mesajı gösterilir (örneğin "Hoş geldiniz! Bugün 16. gününüz, harika ilerliyorsunuz!"). Özel rozet kazanılan günlerde karşılama mesajında bu başarı ayrıca belirtilir. **Profil ve Hesap Yönetimi:** Profil sayfası, ayarlar, yardım ve destek, hesabı kapatma seçenekleri ve kullanıcı giriş arayüzü bulunur. Mevcut **Material 3 tasarım dili ve reaktif aydınlık/karanlık tema desteği** korunur.

## Mimari Yapı : Özellik Bazlı

````
lib/
│
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── theme_controller.dart
│   │
│   ├── router/
│   │   └── app_router.dart
│   │
│   ├── extensions/
│   │
│   └── widgets/
│       └── app_bottom_navigation.dart
│
└── features/
    │
    ├── auth/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   │   └── login_view.dart
    │   └── widgets/
    │
    ├── home/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   │   └── home_view.dart
    │   └── widgets/
    │       ├── welcome_dialog.dart
    │       ├── pet_preview_card.dart
    │       └── habit_summary_card.dart
    │
    ├── pets/
    │   ├── controller/
    │   │   └── pet_controller.dart
    │   ├── models/
    │   │   └── pet_model.dart
    │   ├── repository/
    │   ├── view/
    │   │   ├── pet_selection_view.dart
    │   │   └── pet_detail_view.dart
    │   └── widgets/
    │       ├── pet_character.dart
    │       ├── pet_level_indicator.dart
    │       └── pet_age_indicator.dart
    │
    ├── habits/
    │   ├── controller/
    │   │   └── habit_controller.dart
    │   ├── models/
    │   │   └── habit_model.dart
    │   ├── repository/
    │   ├── view/
    │   │   ├── habits_view.dart
    │   │   └── add_habit_view.dart
    │   └── widgets/
    │       ├── habit_card.dart
    │       ├── habit_progress.dart
    │       └── habit_color_picker.dart
    │
    ├── badges/
    │   ├── controller/
    │   │   └── badge_controller.dart
    │   ├── models/
    │   │   └── badge_model.dart
    │   ├── repository/
    │   ├── view/
    │   │   └── badges_view.dart
    │   └── widgets/
    │       ├── badge_card.dart
    │       ├── badge_progress.dart
    │       └── special_badge.dart
    │
    ├── market/
    │   ├── controller/
    │   │   └── market_controller.dart
    │   ├── models/
    │   │   └── food_model.dart
    │   ├── repository/
    │   ├── view/
    │   │   └── market_view.dart
    │   └── widgets/
    │       ├── food_card.dart
    │       └── purchase_button.dart
    │
    ├── cupboard/
    │   ├── controller/
    │   │   └── cupboard_controller.dart
    │   ├── models/
    │   │   └── cupboard_item_model.dart
    │   ├── repository/
    │   ├── view/
    │   │   └── cupboard_view.dart
    │   └── widgets/
    │       ├── food_inventory_card.dart
    │       └── feeding_button.dart
    │
    ├── calendar/
    │   ├── controller/
    │   │   └── calendar_controller.dart
    │   ├── models/
    │   ├── view/
    │   │   └── calendar_view.dart
    │   └── widgets/
    │       ├── calendar_day.dart
    │       └── calendar_habit_item.dart
    │
    ├── notifications/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   │   └── notifications_view.dart
    │   └── widgets/
    │
    └── profile/
        ├── controller/
        ├── models/
        ├── view/
        │   ├── profile_view.dart
        │   ├── settings_view.dart
        │   └── help_support_view.dart
        └── widgets/
```

## 3. Kırmızı Çizgiler Kod Kalite Standartları
1- **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2- **UI ve Performans Kuralları:**
Statik tüm widget'larda `const` zorunludur.
Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır.
Büyük build methodları yasaktır 40 satırı geçen build methodları özel widgetlara yazılacaktır.

3- **Yasaklı Paketler:**
Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.

## 4. Geliştirme Analiz ve Test Komutları
Ajan yaptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

* **Statik Kod Analizi(0 uyarı ve 0 hata şart):**
```bash
flutter analyze
```

* **Bİrim ve Widget testleri:**
```bash
flutter test
```

* **Projeyi Çalıştırma:**
```bash
flutter run
```


## 5. Ajanın Çıktı ve Yanıt Verme Standartları

**Açıklamalar:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
**Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster
**Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye tıklanabilir link ver.
**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.



