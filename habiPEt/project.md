# Alışkanlık Takip Uygulaması
Bu doküman flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılşım geliştiriciler için bağlayıcı bir kılavuzdur.Projede yazılan her kod satırı buradaki kurallara UYMAK ZORUNDADIR

##1. Proje Özeti ve Teknolojiler

-**Uygulama Adı:** habiPEt (sanal evcil hayvan edinme ve alışkanlık takip uygulaması)

-**Hedef Platformlar:** ios ve android öncelikli ardından web ve masaüstü platformları

-**Flutter SDK:** 3.29.0

-**Dart SDK:** 3.10.2

-**Tasarım Dili:** **Sage & Cream** Renk Paleti ve Material 3 Mimarisi. Hem **Açık Tema (Light Mode)** hem de **Koyu Tema (Dark Mode)** desteklenir:
  - **Light Mode – Sage & Cream:**
    - Primary (Ana renk): `#557C6B`
    - Secondary (İkincil renk): `#BBD2C0`
    - Background (Arka plan): `#FAF8F1`
    - Surface (Kart arka planı): `#FFFFFF`
    - Surface Variant (İkincil kart): `#F0F5F2`
    - Accent (Vurgu/Ödül): `#D6A85B` (Altın sarısı)
    - Text Primary (Ana yazı): `#273B34`
    - Text Secondary (İkincil yazı): `#64756D`
    - Border (Kart kenarlıkları): `#DCE8DF`
  - **Dark Mode – Sage & Cream:**
    - Primary (Ana renk): `#6EA286`
    - Secondary (İkincil renk): `#3A5B4F`
    - Background (Arka plan): `#0F1412` (Göz yormayan koyu yeşil-antrasit)
    - Surface (Kart arka planı): `#1A221E`
    - Surface Variant (İkincil kart): `#232E28`
    - Accent (Vurgu/Ödül): `#D6A85B` (Altın sarısı)
    - Text Primary (Ana yazı): `#E8EDE6`
    - Text Secondary (İkincil yazı): `#A8B5AC`
    - Border (Kart kenarlıkları): `#34463C`
  - **Kalıcı Tema Sistemi:** Profil ve Ayarlar sayfalarındaki anahtar (switch) ile anında geçiş yapılır. Tercih `ThemeStorage` ile yerel olarak kalıcı saklanır (Web `localStorage` ve Desktop/Native dosya depolama, sıfır harici bağımlılık kuralına uygun).
  - **Alışkanlık Renk Kimliği:** Su (`#0EA5E9`), Spor (`#F97316`), Yoga (`#8B5CF6`), Sigara Bırakma (`#34D399`), Kitap (`#EAB308`) renk kimlikleri her iki temada da korunur; kart zeminleri ve metin kontrastları seçili temaya göre otomatik uyarlanır.

-**Eklenen Özellikler:** 
  - **habiPEt Evcil Hayvan Sistemi:** Kullanıcı, sunulan seçenekler arasından bir evcil hayvan seçer, isimlendirir; hayvanı veya ismi istediği zaman değiştirebilir. Hayvan değiştirildiğinde önceki hayvanın tüm gelişimi yeni hayvana aktarılır. Evcil hayvanın yaşı, kullanıcının uygulamadaki kullanım süresine göre ilerler (uygulamanın 3. ayında 3 aylık bir evcil hayvan). Hayvanın yaşı ve seviyesi gösterilir; seviyesi beslendikçe artar.
  - **Alışkanlık Sistemi ve Ayrık Gün Takibi:** Su içme, spor, yoga/meditasyon, sigara bırakma ve kitap okuma alışkanlıkları sunulur. Kullanıcı istediği kadar özel alışkanlık ekleyebilir. **Her bir alışkanlığın başlangıç tarihi, gün sayacı (16. Gün, 14. Gün, 12. Gün vb.), kesintisiz serisi ve 21 günlük bilimsel alışkanlık hedefi (X/21 Gün) birbirinden tamamen bağımsız olarak ayrı ayrı takip edilir.** Alışkanlık kartlarında ve ana sayfada her alışkanlığın kendi gün göstergesi bağımsız yer alır.
  - **Çoklu Alışkanlık ve Rozet Ödül Sistemi:** 1'den fazla alışkanlığa sahip olmak ve bunları sürdürmek kullanıcıya doğrudan ekstra rozetler ve jeton kazandırır.
    - *2. Alışkanlık:* **Çifte Güç** (+25 Rozet)
    - *3. Alışkanlık:* **Denge Ustası** (+40 Rozet)
    - *4. Alışkanlık:* **Dört Dörtlük** (+60 Rozet)
    - *5. Alışkanlık:* **Süper İrade** (+80 Rozet)
    - *6. Alışkanlık:* **Altın Ritim** (+100 Rozet)
    - *7. Alışkanlık:* **Yedili Dönüşüm** (+125 Rozet)
    - *8. Alışkanlık:* **Sekizinci Boyut** (+150 Rozet)
    - *9. Alışkanlık:* **Zirve Ustası** (+175 Rozet)
    - *10. Alışkanlık:* **Alışkanlık Efendisi (10 Numara)** (+200 Rozet)
    - *Çoklu Disiplin:* Aynı gün içerisinde 2 veya daha fazla alışkanlığı tamamlama (+35 Rozet)
    - *Günün Şampiyonu:* Tüm aktif alışkanlıkları aynı gün eksiksiz tamamlama (+50 Rozet)
    - Alışkanlıklar tamamlandıkça günlük, haftalık, aylık ve yıllık rozetler kazanılır. İlk üç gün kazanılan rozet ödülü kademeli olarak artar (5, 10, 15); üçüncü günden sonra günlük kazanım sabitlenir. İlk aya kadar haftalık ödüller kademeli artar, sonrasında aylık dönemlere göre artış uygulanır. Rozetlerin değer sıralaması **Yıllık > Aylık > Haftalık > Günlük > Çoklu Alışkanlık > Özel** şeklindedir.
    - **Başarı Rozetleri Modülünde Ayrık Alışkanlık Filtreleme:** Rozetler sayfasında kullanıcı "Tüm Alışkanlıklar" genel görünümünün yanında tek dokunuşla dilediği alışkanlığı (ör. *Su İçme - 16. Gün*, *Yoga - 12. Gün*) seçebilir; 21. Gün Bilimsel Hedef kartı ve kilit durumları o alışkanlığın kendi gün sayısına göre ayrık olarak dinamik güncellenir.
  - **Market ve Beslenme Sistemi:** Kullanıcı, alışkanlıklarından ve çoklu alışkanlık başarılarından kazandığı rozetleri markette harcayarak evcil hayvanı için yiyecek satın alır. Satın alınan yiyecekler dolaba eklenir ve hayvan bu yiyeceklerle beslenir. Ana sayfada evcil hayvanın altında yatay kaydırılabilir bir yiyecek dolabı alanı bulunur. Dolap simgesine basıldığında dolap açılır; dolap içerisindeki aktif **+** butonu kullanıcıyı markete yönlendirir.
  - **Ana Sayfa:** Bildirimler, evcil hayvan ekleme/değiştirme, market ve rozet göstergesi için aktif butonlar bulunur. Evcil hayvanın yaşı, seviyesi ve yiyecek dolabı gösterilir. Günlük görev listesinde her alışkanlığın gün sayısı rozet olarak belirtilir.
  - **Takvim Modülü:** Standart takvim görünümünde kullanıcıların alışkanlıkları, isimleri, gün sayıları ve kazanılan rozetleri ilgili tarihlerde gösterilir. Kullanıcı, alışkanlık ekleme aşamasında alışkanlığın adını, takvimde görünecek yazı rengini ve diğer görünüm tercihlerini Apple Takvim benzeri şekilde özelleştirebilir. Birden fazla alışkanlık takvimde ayrı ayrı görüntülenir.
  - **Karşılama Diyaloğu:** Kullanıcı uygulamayı her açtığında güncel ilerlemesini belirten motivasyon mesajı gösterilir (örneğin "Hoş geldiniz! Bugün 16. gününüz, harika ilerliyorsunuz!"). Özel rozet kazanılan günlerde karşılama mesajında bu başarı ayrıca belirtilir.
  - **Profil ve Hesap Yönetimi:** Profil sayfası, ayarlar, yardım ve destek, hesabı kapatma seçenekleri ve kullanıcı giriş arayüzü bulunur. Mevcut **Material 3 tasarım dili ve reaktif aydınlık/karanlık tema desteği** korunur.

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
│   │   ├── theme_controller.dart
│   │   └── theme_storage.dart
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



