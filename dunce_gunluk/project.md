# Anı & Duygu Günlüğü
Bu doküman flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılşım geliştiriciler için bağlayıcı bir kılavuzdur.Projede yazılan her kod satırı buradaki kurallara UYMAK ZORUNDADIR

##1. Proje Özeti ve Teknolojiler
-**Uygulama Adı:** Dünce (geçmiş anlamına gelen dün ve düşünce kelimelerinin birleşiminden ilham alan, duygu günlüğü anlamına gelen bir kısaltmadır)
-**Hedef Platformlar:** İos ve android öncelikli ardından web ve masaüstü platformları
-**Flutter Versiyon:** 3.34.3
-**Dart Versiyon:** 3.8.3
- **Tasarım Dili:** Material 3, Vintage Scrapbook (Nostaljik Anı Defteri) tasarım anlayışı ve Dinamik Tema Desteği: Koyu tema (eski kitap atmosferi, koyu kahverengi, antrasit, sepya ve soluk altın vurgular) ve Aydınlık tema (nostaljik defter atmosferi, krem, bej, pastel kahverengi ve pudra tonları). Arayüzde kâğıt dokuları, el yazısı tarzı başlıklar, polaroid çerçeveler, dekoratif bantlar (washi tape) ve dijital çıkartmalar kullanılır. Takvim ekranı nostaljik bir ajanda, günlük sayfası ise kişiselleştirilebilir bir anı defteri görünümünde tasarlanır. Kullanıcı tek dokunuşla aydınlık ve koyu tema arasında geçiş yapabilir.
-**Eklenen Özellikler:** Kullanıcı izni ile galeri (fotoğraf) erişimi sayesinde polaroid tarzı fotoğraf ekleme, uygulamanın kendisinden gelen ve kullanıcı tarafından eklenebilen çıkartma sekmesi ile istenilen şekilde düzenleme, takvimde ay ve yıla dokunulduğunda açılan hızlı ay/yıl seçici menüsü, 'Bugün' butonu ile doğrudan bugünün tarihine ve ayına gitme, ajanda ile anı defterinin aynı sayfada bütünleşik yer alması, takvimde gün hücrelerinde ve seçili gün özetinde günün başlığının doğrudan gösterilmesi, takvimden seçilen/dokunulan güne tıklandığında doğrudan defteri doldurma (anı yazma/düzenleme) ekranına yönlendirme, uygulama açılış ekranında uygulamanın adının anlamına yer verme, özel vintage scrapbook uygulama logosu entegrasyonu (açılış ekranı, AppBar, ayarlar ekranı ve web faviconu), klavye ile anı ve duygu yazma desteği.
**Karanlık ve Aydınlık mod geçişi** (AppBar üzerinden reaktif geçiş; karanlık modda yüksek kontrastlı ve belirgin tipografi).
---

## Mimari Yapı: Özellik Bazlı (Feature-Based Architecture)

Dünce uygulaması, **Feature-Based Architecture** (Özellik Bazlı Mimari) kullanılarak geliştirilecektir. Kodlar kesinlikle tek bir yerde toplanmayacak, her modül kendi `features` klasöründe bağımsız olarak yönetilecektir.

Uygulamanın temel modülleri; **takvim, günlük kayıtları, dijital çıkartmalar ve tema yönetimi** olacaktır.

```text
lib/
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   │
│   └── theme/
│       └── app_theme.dart
│
├── features/
│   │
│   ├── calendar/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── diary/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── stickers/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   └── settings/
│       ├── controller/
│       ├── models/
│       ├── view/
│       └── widgets/
│
└── main.dart
```

### Modüllerin Görevleri

- **Core:** Uygulama genelinde kullanılacak sabitler, renk paletleri ve Material 3 tabanlı aydınlık/koyu tema yapılandırması.
- **Calendar:** Geçmiş ve gelecek tarihler arasında gezinme, tarih seçme ve günlük kaydı bulunan günleri işaretleme.
- **Diary:** Seçilen tarihe ait anı ve düşünceleri yazma, kaydetme, görüntüleme, düzenleme ve silme.
- **Stickers:** Günlük sayfalarına Vintage Scrapbook tarzında dijital çıkartmalar ekleme ve seçilen çıkartmaları yönetme.
- **Settings:** Kullanıcının aydınlık ve koyu tema arasında geçiş yapabilmesini sağlayan ayarlar.
- **Main.dart:** Uygulamanın başlangıç noktası ve ana yapılandırması.

Her modül kendi içerisinde `controller`, `models`, `view` ve `widgets` klasörlerine ayrılarak kodun okunabilirliği, sürdürülebilirliği ve geliştirilebilirliği sağlanacaktır.


## 3. Kırmızı Çizgiler: Kod Kalite Standartları

1- **State Yönetim Standartları:**

Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.

Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

Takvimde tarih seçimi, günlük kayıtlarının yönetimi, dijital çıkartmaların eklenmesi ve tema değişiklikleri ilgili feature klasörlerindeki controller yapıları üzerinden yönetilecektir.

2- **UI ve Performans Kuralları:**

Statik tüm widget'larda `const` zorunludur.

Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır.

Büyük build methodları yasaktır. 40 satırı geçen build methodları özel widgetlara yazılacaktır.

Vintage Scrapbook tasarımına ait kâğıt dokuları, dekoratif bantlar, dijital çıkartmalar ve diğer arayüz bileşenleri tekrar kullanılabilir widgetlar olarak oluşturulacaktır.

3- **Yasaklı Paketler:**

Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR.

Dart'ın ve Flutter'ın yerel çekirdek API'lerini kullanmak esastır.
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
