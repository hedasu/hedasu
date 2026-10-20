# otoVia Araç Kiralama Uygulaması
Bu doküman flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılşım geliştiriciler için bağlayıcı bir kılavuzdur.Projede yazılan her kod satırı buradaki kurallara UYMAK ZORUNDADIR

## 1. Proje Özeti ve Teknolojiler
-**Uygulama Adı:** otoVia (araç kiralama uygulaması)
-**Hedef Platformlar:** İos ve android öncelikli ardından web ve masaüstü platformları
- **Flutter SDK:**  3.29.0
- **Dart SDK:** 3.0.0

- **Tasarım Dili:** Material Design 3, Monochrome Luxury & Editorial Layout, Dinamik Tema Desteği: Koyu tema (Obsidian Luxury; derin obsidyen siyahı, grafit yüzeyler, yumuşak beyaz metinler ve zarif şampanya vurguları) ve Aydınlık tema (Ivory White; kırık beyaz arka plan, temiz beyaz kartlar, antrasit metinler ve minimal şampanya detayları). Arayüz, lüks otomobil kataloglarından ilham alan büyük araç fotoğrafları, tek sütunlu geniş kartlar, ince ayırıcı çizgiler, dengeli boşluklar, sade tipografi ve minimal butonlarla tasarlanacaktır. Kullanıcı AppBar üzerindeki tema değiştirme butonuyla karanlık ve aydınlık tema arasında tek dokunuşla reaktif geçiş yapabilir. Seçilen tema uygulama yeniden açıldığında korunur. Tüm ekranlar ve Material 3 bileşenleri ortak tasarım sistemine uygun olacaktır. Ayrıntılı tasarım kuralları `stil.md` dosyasında tanımlanacaktır.

-**Eklenen Özellikler:** # otoVia — Araç Kiralama Mobil Uygulaması

## 1. Proje Tanımı

otoVia, kullanıcıların farklı kategorilerdeki araçları saatlik veya günlük olarak kiralayabildiği, araçları karşılaştırabildiği, rezervasyonlarını ve ödemelerini yönetebildiği bir mobil araç kiralama uygulamasıdır.

Uygulama Flutter kullanılarak Material Design 3 altyapısıyla geliştirilecektir. Aydınlık (Light) ve karanlık (Dark) tema desteğine sahip olacak; kullanıcılar AppBar üzerinden temalar arasında anlık geçiş yapabilecektir.

## 2. Kullanıcı Girişi ve Üyelik Sistemi

**Karşılama Ekranı:**
- Üye Girişi ve Üye Ol olmak üzere iki ana aksiyon butonu bulunur.

**Üye Ol:**
- Ad
- Soyad
- Telefon numarası
- E-posta adresi
- Şifre oluşturma
- Şifre tekrar alanı

**Üye Girişi:**
- Telefon numarası veya e-posta adresi
- Şifre
- Şifremi unuttum seçeneği

Tüm giriş ve kayıt alanlarında form validasyonu bulunur. Eksik, geçersiz veya hatalı bilgiler kullanıcıya gösterilir.

## 3. Ana Sayfa ve Araç Keşfetme

Giriş yapan kullanıcı araç kiralama ana sayfasına yönlendirilir.

**Kiralama seçenekleri:**
- Saatlik kiralama
- Günlük kiralama

Her araç için hangi kiralama türlerinin desteklendiği sistem tarafından belirlenir.

**Araç kategorileri:**
- Motosikletler
- Binek otomobiller
- SUV araçlar
- Kalabalık gruplar için geniş araçlar
- Nakliye ve ticari amaçlı araçlar

**Ana sayfa özellikleri:**
- Araç arama
- Araç kategorileri
- Saatlik/günlük kiralama seçimi
- Araç listeleme
- Favorilere ekleme
- Kiralama amacına göre araç önerileri
- Aktif kiralama varsa güncel araç bilgisi
- Aktif kiralamada canlı desteğe erişim

**Kiralama amacına göre öneriler:**

Kullanıcı şehir içi ulaşım, aile seyahati, uzun yol, grup yolculuğu veya eşya taşıma gibi amaçlardan birini seçerek uygun araçları görüntüleyebilir.

## 4. Araç İlanları ve Detayları

**Araç listeleme kartları:**
- Araç fotoğrafı
- Marka ve model
- Araç kategorisi
- Saatlik veya günlük başlangıç fiyatı
- Kullanıcı puanı
- Favorilere ekleme butonu

**Araç detay ekranı:**
- Araç fotoğrafları
- Marka ve model
- Model yılı
- Yakıt türü
- Vites türü
- Araç özellikleri ve donanımları
- Yolcu ve bagaj kapasitesi
- Saatlik/günlük kiralama tarifesi
- Gerekli ehliyet sınıfı
- Kullanıcı yorumları ve puanları
- Müsaitlik bilgisi
- Rezervasyon butonu

**Araç filtreleme:**

Kullanıcılar araçları marka, model, fiyat, kategori, yakıt türü, vites, model yılı, araç özellikleri, ehliyet sınıfı ve kiralama türüne göre filtreleyebilir.

**Gelişmiş sıralama:**
- En düşük fiyat
- En yüksek fiyat
- En yüksek kullanıcı puanı
- En yeni model

**Ehliyetime Uygun Araçlar:**

Kullanıcı, doğrulanmış ehliyet sınıfına ve ilgili kiralama şartlarına uygun araçları filtreleyebilir. Uygun olmayan araçların neden kiralanamadığı açıklanır.

## 5. Favoriler ve Araç Karşılaştırma

- Kullanıcılar araçları favorilerine ekleyebilir.
- Favoriler alt navigasyon çubuğundan ve profil ekranından görüntülenebilir.
- Favorilerdeki araçlar kullanıcı tarafından seçilerek karşılaştırılabilir.
- Karşılaştırma ekranında seçili araçların teknik özellikleri, fiyatları, kullanıcı puanları ve kiralama koşulları yan yana gösterilir.
- Favorilerden çıkarma işleminde Snackbar aracılığıyla **Geri Al** seçeneği sunulur.

## 6. Rezervasyon Sistemi

**Rezervasyon adımları:**

1. Araç seçimi
2. Saatlik veya günlük kiralama türünün seçilmesi
3. Teslim alma ve bırakma tarihi/saatinin belirlenmesi
4. Aracın müsaitlik kontrolü
5. Ehliyet ve kiralama uygunluk kontrolü
6. Kiralama koşulları ve taahhütlerin kabul edilmesi
7. Fiyat dökümü ve kupon uygulama
8. Kullanıcı onayı ve ödeme
9. Rezervasyonun kesinleştirilmesi

Rezervasyon sürecinde bir adım göstergesi bulunur.

**Müsaitlik takvimi:**

Daha önce rezerve edilmiş veya kullanıma kapalı tarih ve saat aralıkları seçilemez. Aynı araç için çakışan rezervasyon oluşturulması engellenir.

**Ehliyet doğrulama:**

Kullanıcıdan gerekli ehliyet bilgileri alınır. Araç sınıfı ve geçerli kiralama koşulları açısından uygunluk kontrolü yapılır.

**Kiralama sözleşmesi:**

Kullanıcı, rezervasyonu tamamlamadan önce kiralama sözleşmesini, sorumlulukları ve gerekli taahhütleri inceleyerek kabul eder.

**Şeffaf fiyatlandırma:**

Ödeme öncesinde:
- Saatlik/günlük birim fiyat
- Toplam kiralama süresi
- Kiralama bedeli
- Varsa ek hizmet ve güvence ücretleri
- Varsa depozito
- Kupon indirimi
- Nihai ödeme tutarı

ayrı ayrı gösterilir.

Ödeme sonucunda rezervasyonun durumu güncellenir. Başarısız ödemelerde rezervasyon kesinleşmiş olarak gösterilmez.

## 7. Rezervasyonlarım

Rezervasyonlarım ekranı hem alt navigasyon çubuğunda hem de profil içerisinde bulunur. İki erişim noktası aynı rezervasyon bilgilerini gösterir.

**Rezervasyon kategorileri:**
- Gelecek rezervasyonlar
- Güncel/aktif kiralamalar
- Geçmiş kiralamalar
- İptal edilen rezervasyonlar

**Rezervasyon işlemleri:**
- Rezervasyon detaylarını görüntüleme
- İptal koşullarına uygun rezervasyonu iptal etme
- Müsaitlik durumuna göre kiralama süresini uzatma
- Aktif kiralamada canlı desteğe bağlanma
- Tamamlanan kiralamada yorum ve puanlama yapma
- Araç teslim kayıtlarını inceleme

İptal ve süre uzatma işlemlerinde kullanıcının onayı alınır. Süre uzatımı için yeni ücret hesaplanır ve ödeme gerekiyorsa tahsil edilir.

## 8. Araç Teslim Alma ve Teslim Etme

**Teslim alma:**
- Aracın mevcut durumu kontrol edilir.
- Araç fotoğrafları eklenebilir.
- Önceden bulunan hasarlar kayıt altına alınabilir.
- Teslim alma işlemi onaylanır.

**Teslim etme:**
- Araç teslim durumu kaydedilir.
- Güncel araç fotoğrafları eklenebilir.
- Teslim işlemi tamamlanır.
- Kiralama geçmiş rezervasyonlar bölümüne aktarılır.

Fotoğraflı teslim kayıtları, olası anlaşmazlıklarda incelenebilmesi için rezervasyonla ilişkilendirilir.

## 9. Yorum ve Puanlama Sistemi

Kullanıcı yalnızca tamamladığı kiralamalar için yorum ve değerlendirme oluşturabilir.

**Değerlendirme kriterleri:**
- Araç belirtilen özelliklerle uyumlu muydu?
- Araç kiralama amacına uygun muydu?
- Kiralama sırasında sorun yaşandı mı?
- Destek hizmeti yeterli miydi?
- Genel memnuniyet puanı
- Yazılı kullanıcı yorumu

Puanlar ve yorumlar ilgili aracın detay sayfasında görüntülenir.

## 10. Yardım ve Canlı Destek

**Yardım & Destek ekranı:**
- Sıkça Sorulan Sorular (SSS)
- Firma müşteri hizmetleri
- Destek talebi oluşturma
- Destek taleplerini görüntüleme

**Aktif kiralama desteği:**

Kullanıcı aracı teslim aldıktan sonra kiralama tamamlanana kadar canlı araç desteğine erişebilir.

Canlı destek butonu:
- Ana sayfadaki güncel araç kartında
- Profildeki Rezervasyonlarım bölümünde
- Aktif rezervasyon detayında

bulunur.

Firma kaynaklı teknik kusur, ilanla uyuşmazlık, teslim sorunu ve benzeri konularda destek talebi oluşturulabilir.

**Destek Taleplerim:**

Kullanıcılar geçmiş ve güncel destek taleplerini görüntüler.

Talep durumları:
- Beklemede
- İnceleniyor
- Yanıtlandı
- Çözüldü

Durum değişiklikleri bildirimlerle kullanıcıya iletilir.

## 11. İndirim ve Kupon Sistemi

**Kupon kazanma koşulları:**
- İlk kiralamada %20 indirim kuponu
- Başarıyla tamamlanan her 3 kiralama için yeni %20 indirim kuponu

İptal edilen veya tamamlanmayan kiralamalar üç kiralama sayacına eklenmez.

**Kuponlarım ekranı:**
- Kullanılabilir kuponlar
- Kullanılmış kuponlar
- Süresi dolmuş kuponlar
- Kupon açıklaması
- Varsa son kullanım tarihi
- Kullan butonu

Kullanılmış veya geçersiz kuponların Kullan butonu pasif durumda olur.

**Kupon ilerleme göstergesi:**

Kullanıcı, yeni kupon kazanmak için kaç kiralama daha tamamlaması gerektiğini görebilir.

Kupon kullanıldığında indirim, ödeme öncesi fiyat özetine yansıtılır.

## 12. Bildirim Sistemi

Bildirimler ekranında:
- Rezervasyon onayları
- Rezervasyon iptal bildirimleri
- Araç teslim alma hatırlatmaları
- Araç teslim etme hatırlatmaları
- Favorilerdeki araçların yeniden müsait olması
- Yeni indirim kuponları
- Kampanya duyuruları
- Destek talebi onayları
- Destek talebine gelen yanıtlar
- Kiralama süresi uzatma sonuçları

gösterilir.

Bildirimler okundu/okunmadı olarak takip edilebilir.

## 13. Profil Ekranı

**Kullanıcı Bilgileri:**
- Ad ve soyad
- Telefon numarası
- E-posta adresi
- Bilgi düzenleme butonu

**Profil menüsü:**
- Rezervasyonlarım
- Favorilerim
- Kuponlarım
- Destek Taleplerim
- Yardım & Destek
- Kiralama İstatistiklerim
- Çıkış Yap

**Kiralama istatistikleri:**
- Toplam tamamlanan kiralama
- Toplam kiralama günü/saati
- Kullanılan kupon sayısı
- Kazanılan kupon sayısı

## 14. Arayüz ve Etkileşim Gereksinimleri

**Material Design 3:**
- Material 3 bileşenleri kullanılacaktır.
- Ekranların tamamında ortak tema yönetimi bulunacaktır.

**Tema yönetimi:**
- Light Mode
- Dark Mode
- AppBar üzerinde tema değiştirme aksiyon butonu
- Uygulama yeniden başlatıldığında seçilen temanın korunması

**Form yönetimi:**
- Zorunlu alan kontrolleri
- E-posta/telefon formatı doğrulama
- Şifre kontrolleri
- Tarih ve saat doğrulamaları
- Ehliyet ve kiralama uygunluğu kontrolleri

**Dialoglar:**
- Rezervasyon onayı
- Rezervasyon iptal onayı
- Ödeme öncesi onay
- Kiralama süresi uzatma onayı
- Çıkış yapma onayı

**Snackbar bildirimleri:**
- Başarılı işlemler
- Hatalı işlemler
- Favorilere ekleme/çıkarma
- Geri Al aksiyonu
- Form hata mesajları

## 15. Uygulamanın Genel Hedefi

otoVia'nın hedefi, kullanıcıların ihtiyaçlarına ve ehliyet uygunluklarına göre araç bulmalarını; fiyatları şeffaf biçimde karşılaştırmalarını; güvenilir, anlaşılır ve kolay yönetilebilir bir kiralama süreci gerçekleştirmelerini sağlamaktır.

## Mimari Yapı: Feature-Based Architecture (Özellik Bazlı Mimari)

otoVia araç kiralama uygulaması Flutter ile **Feature-Based Architecture** yaklaşımına uygun geliştirilecektir.

**Kodlar kesinlikle tek bir dosyada veya klasörde toplanmayacaktır.** Her modül kendi `features` klasöründe bulunacak ve modüller birbirinden bağımsız, düzenli ve geliştirilebilir şekilde yapılandırılacaktır.

### Proje Klasör Yapısı

```text
lib/
│
├── main.dart
│
├── app/
│   ├── app.dart
│   └── router/
│       └── app_router.dart
│
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── theme_controller.dart
│   │
│   ├── extensions/
│   │
│   ├── services/
│   │
│   └── widgets/
│
└── features/
    │
    ├── auth/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    ├── home/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    ├── vehicles/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    ├── favorites/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    ├── comparison/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    ├── reservations/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    ├── payments/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    ├── delivery/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    ├── reviews/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    ├── notifications/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    ├── coupons/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    ├── support/
    │   ├── controller/
    │   ├── models/
    │   ├── view/
    │   └── widgets/
    │
    └── profile/
        ├── controller/
        ├── models/
        ├── view/
        └── widgets/
```

### Klasörlerin Görevleri

**core/:** Uygulamanın genelinde kullanılan ortak yapıları barındırır. Renk tanımları, tema yönetimi, ortak servisler, yardımcı fonksiyonlar ve tekrar kullanılabilir bileşenler burada bulunur.

**app/:** Uygulamanın genel yapılandırılması, MaterialApp tanımı ve ekranlar arası yönlendirme sistemi burada yönetilir.

**features/:** Uygulamanın bütün işlevsel modüllerini içerir.

- `auth/`: Üyelik, giriş ve kullanıcı doğrulama işlemleri.
- `home/`: Ana sayfa, araç keşfetme ve aktif kiralama özeti.
- `vehicles/`: Araç listeleme, detaylar, filtreleme, sıralama ve ehliyet uygunluğu.
- `favorites/`: Favori araçları yönetme.
- `comparison/`: Seçilen araçların karşılaştırılması.
- `reservations/`: Saatlik/günlük kiralama, takvim, rezervasyon, iptal ve süre uzatma işlemleri.
- `payments/`: Ödeme süreci ve şeffaf fiyatlandırma.
- `delivery/`: Araç teslim alma, teslim etme ve fotoğraflı kontrol.
- `reviews/`: Araç yorumları ve puanlama.
- `notifications/`: Kullanıcı bildirimleri.
- `coupons/`: İndirim kuponları ve kupon kazanma sistemi.
- `support/`: Canlı destek, yardım, SSS ve destek talepleri.
- `profile/`: Kullanıcı bilgileri, profil düzenleme ve kiralama istatistikleri.

### Modül İçi Kod Düzeni

Her feature kendi içerisinde aşağıdaki sorumluluklara ayrılacaktır:

- **controller/:** Ekran durumları, kullanıcı etkileşimleri ve iş mantığı.
- **models/:** Modüle ait veri modelleri.
- **view/:** Kullanıcıya gösterilen sayfalar.
- **widgets/:** Sadece ilgili modülde kullanılan arayüz bileşenleri.

Gerekli modüllerde veri erişimi için ayrıca `repositories/` klasörü oluşturulabilir.

### main.dart Kuralı

`main.dart` dosyası yalnızca uygulamanın başlatılması ve gerekli başlangıç yapılandırmalarından sorumlu olacaktır.

Tema sisteminin başlatılması dışında iş mantığı, araç listeleri, rezervasyon işlemleri, kullanıcı formları veya ekran tasarımları bu dosyaya yazılmayacaktır.

- Tema tanımları `core/theme/app_theme.dart` dosyasında tutulacaktır.
- Tema durum yönetimi `core/theme/theme_controller.dart` üzerinden yapılacaktır.
- Uygulamanın MaterialApp yapılandırması `app/app.dart` içerisinde bulunacaktır.
- Light/Dark tema geçişi uygulama genelinde reaktif çalışacaktır.
- Tema tercihi kalıcı olarak saklanacaktır.
- Tüm görsel bileşenler proje kökündeki `stil.md` tasarım kurallarına uygun oluşturulacaktır.

### Mimari Kurallar

1. Tek bir dosyada bütün uygulama kodları birleştirilmeyecektir.
2. Her modül yalnızca kendi sorumluluğundaki işlemleri yönetecektir.
3. Ortak kullanılan bileşenler `core/widgets/` içerisinde tutulacaktır.
4. Genel renk ve tema tanımları merkezi olarak yönetilecektir.
5. Aynı kod farklı ekranlarda gereksiz yere tekrar edilmeyecektir.
6. Rezervasyonlarım ve Favorilerim gibi birden fazla noktadan erişilen ekranlar ayrı ayrı oluşturulmayacak, aynı modüle yönlendirilecektir.
7. Kullanıcı arayüzü ve iş mantığı birbirinden ayrılacaktır.
8. Material Design 3 kullanılacak ve `stil.md` dosyasına bağlı kalınacaktır.
9. Modüller geliştikçe mevcut klasör yapısı korunacak ve gerektiğinde genişletilecektir.
10. Henüz geliştirilmeyen modüller için gereksiz boş dosyalar oluşturulmayacaktır.


## 3. Kırmızı Çizgiler Kod Kalite Standartları

**1- State Yönetim Standartları:**

Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.

Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) `StatefulWidget` kabul edilir.

Uygulamanın durum yönetiminde Flutter'ın yerel `ChangeNotifier`, `ValueNotifier` ve `ListenableBuilder` yapıları kullanılacaktır.

Rezervasyon, favoriler, kuponlar, kullanıcı girişi ve araç karşılaştırma işlemlerinin iş mantığı ilgili feature klasöründeki `controller/` altında yönetilecektir.

Aydınlık/Karanlık tema geçişleri merkezi `theme_controller.dart` üzerinden reaktif olarak yönetilecektir.

**2- UI ve Performans Kuralları:**

Statik tüm widget'larda `const` zorunludur.

Renk ve metin stilleri kesinlikle merkezi tema dosyalarında tanımlanacaktır.

Büyük `build` metotları YASAKTIR. 40 satırı geçen `build` metotları özel widget'lara bölünecektir.

Tüm arayüzlerde Material Design 3 ve `stil.md` dosyasında belirlenen Monochrome Luxury & Editorial Layout tasarım kuralları uygulanacaktır.

Uzun araç listelerinde `ListView.builder` kullanılacak, gereksiz widget yeniden oluşturma işlemlerinden kaçınılacaktır.

Kullanıcı girişi, üyelik, ehliyet ve rezervasyon formlarında `Form`, `TextFormField` ve `validator` yapıları kullanılacaktır.

Rezervasyon onayı, iptal ve kritik işlemlerde `AlertDialog`; başarılı/hatalı işlemlerde ve Geri Al etkileşimlerinde `SnackBar` kullanılacaktır.

**3- Yasaklı Paketler:**

Projeye onay almadan harici ağır state yönetim paketleri EKLENMEYECEKTİR.

Dart'ın ve Flutter'ın yerel çekirdek API'lerini kullanmak esastır.

Provider, Riverpod, Bloc ve benzeri harici state yönetim paketleri kullanıcı onayı olmadan kullanılmayacaktır.

Gereksiz üçüncü taraf UI, animasyon ve yardımcı paketler projeye eklenmeyecektir.

Harici paket kullanılması zorunlu olduğunda öncelikle kullanım amacı açıklanacak ve kullanıcıdan onay alınacaktır.

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
