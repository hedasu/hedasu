# StartPath – Girişimcilik ve Mentor Eşleştirme Platformu

Bu doküman, StartPath Flutter projesinde geliştirme yapacak olan yapay zeka ajanları (Antigravity) ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede yazılan her kod satırı buradaki kurallara **UYMAK ZORUNDADIR.**

## 1. Proje Özeti ve Teknolojiler

- **Uygulama Adı:** StartPath (İngilizcede başlangıç anlamına gelen *Start* ve yol anlamına gelen *Path* kelimelerinin birleşiminden oluşur. Girişimcilerin fikir aşamasından şirket kuruluşuna ve büyüme sürecine kadar izledikleri yolu temsil eder.)
- **Uygulamanın Amacı:** Girişimcilerin iş fikirlerini hayata geçirirken karşılaştıkları hukuki ve bürokratik süreçlerde rehberlik sağlamak, ihtiyaç duydukları bilgilere kolayca ulaşmalarını desteklemek ve faaliyet göstermek istedikleri sektörlere uygun mentorlarla eşleşmelerini sağlamak.
- **Hedef Kitle:** Girişimcilik yolculuğuna yeni başlayan bireyler, iş fikrini hayata geçirmek isteyen girişimci adayları, erken aşama girişimler ve mevcut işini geliştirmek isteyen girişimciler.
- **Temel Özellikler:** Girişimcilik yol haritası, hukuki süreç rehberi, sektöre ve ihtiyaca göre mentor eşleştirme, girişimci profili ve süreç takibi.
- **Hedef Platformlar:** iOS ve Android öncelikli, ardından web ve masaüstü platformları.
- **Flutter Versiyonu:** 3.34.3
- **Dart Versiyonu:** 3.8.3

## 2. Projenin Temel Vizyonu

StartPath, girişimcilerin fikirlerini hayata geçirirken ihtiyaç duydukları bilgiye, yönlendirmeye ve deneyimli kişilere tek bir platform üzerinden ulaşmalarını hedefler.

Uygulama, girişimcilik süreçlerini daha anlaşılır, erişilebilir ve yönetilebilir hâle getirerek kullanıcıların doğru adımları atmalarına yardımcı olmayı amaçlar.

**Proje Sloganı:** Girişiminin yolunu birlikte çizelim.

- **Tasarım Dili:** Material 3, Modern Professional (Modern Profesyonel) tasarım anlayışı ve Dinamik Tema Desteği: Koyu tema (premium ve profesyonel atmosfer, koyu petrol yeşili, antrasit, derin orman yeşili ve şampanya altını vurgular) ve Aydınlık tema (modern, ferah ve güvenilir girişimcilik platformu atmosferi, fildişi, krem, adaçayı yeşili, petrol yeşili ve zarif altın detaylar). Arayüzde yuvarlatılmış modern kartlar, minimalist ikonlar, okunabilir tipografi, yumuşak gölgeler ve sade geçiş animasyonları kullanılır. Kullanıcı tek dokunuşla aydınlık ve koyu tema arasında geçiş yapabilir.

- **Eklenen Özellikler:** Kullanıcıların uygulamaya kayıt olduktan sonra **"Fikrim Var", "Fikrim Yok" ve "Mentor Olmak İstiyorum"** seçenekleriyle ihtiyaçlarına uygun kayıt ve yönlendirme süreçlerine dahil edilmesi; "Fikrim Var" seçeneğini seçen kullanıcıların girişim fikrinin adı, sektörü, faaliyet alanı, açıklaması, amacı, hedefleri, hedef kitlesi, mevcut gelişim aşaması ve ihtiyaç duyduğu destekleri belirtebileceği kapsamlı bir girişimcilik formunun sunulması; kullanıcıların projelerini bireysel olarak mı geliştireceklerini, mevcut bir ekibe sahip olup olmadıklarını veya ekip arkadaşı arayıp aramadıklarını belirleyebilmesi; "Fikrim Yok" seçeneğini seçen kullanıcıların ilgi duydukları sektörleri, çalışmak istedikleri alanları, sahip oldukları becerileri ve projelerde üstlenmek istedikleri rolleri belirleyebileceği bir formu doldurarak ekip arkadaşı arayan mevcut girişim ve projeleri inceleyebilmesi; "Mentor Olmak İstiyorum" seçeneğini seçen kullanıcıların mesleki deneyimlerini, uzmanlık alanlarını, faaliyet gösterdikleri sektörleri, geçmiş çalışmalarını ve girişimcilere hangi konularda mentorluk sunabileceklerini belirterek profesyonel mentor profili oluşturabilmesi; kullanıcıların birden fazla role sahip olabilmesini destekleyen esnek profil yapısı; kullanıcıların sektörleri, girişimlerinin gelişim aşamaları, hedefleri ve ihtiyaçlarına göre uygun mentorlarla eşleştirilmesini sağlayan **akıllı mentor eşleştirme sistemi**; uygulamanın alt navigasyon çubuğunda Ana Sayfa, Ekip Bul, Mentorlar, Fırsatlar ve Profil bölümlerinin bulunması; Mentorlar bölümünde platforma kayıtlı mentorların uzmanlık alanları, deneyimleri, hitap ettikleri girişimci kitlesi, kullanıcı değerlendirmeleri, puanları ve profesyonel profil bilgilerinin listelenmesi; mentorların uzmanlık ve deneyim bilgilerinin incelenmesine dayalı **mentor doğrulama sistemi** ve doğrulanmış mentor rozeti; Ekip Bul bölümünde ekip arkadaşı arayan girişimlerin projelerini, ihtiyaç duydukları pozisyonları, aradıkları yetkinlikleri ve ekip yapılarını paylaşabilmesi; kullanıcıların becerileri, ilgi alanları, çalışma tercihleri ve projelerin ihtiyaçlarına göre öneriler sunan **ekip arkadaşı uyumluluk sistemi**; kullanıcıların mevcut projelere ekip üyeliği başvurusu yapabilmesi ve başvurularının gönderildi, inceleniyor, kabul edildi veya reddedildi gibi durumlarını platform üzerinden takip edebilmesi; mentorlarla ve ekip üyeleriyle uygulama içinden mesajlaşma, iletişim kurma ve görüşme talebi gönderme imkânı; girişim ekiplerinin görev dağılımı, proje hedefleri, kilometre taşları ve ilerleme durumlarını yönetebileceği **proje çalışma alanı**; Fırsatlar bölümünde TÜBİTAK, KOSGEB ve benzeri girişimcilik destekleri, hibe programları, yarışmalar, hızlandırma programları ve proje başvuru platformlarının listelenmesi; bu fırsatların sektör, uygunluk koşulları, destek türü ve son başvuru tarihine göre filtrelenebilmesi; girişimcilerin şirket türü seçimi, şirket kuruluşu, gerekli belgeler, vergi yükümlülükleri, marka tescili, izinler ve diğer temel hukuki süreçler hakkında bilgilendirici içeriklere ulaşabileceği, tamamlanan ve bekleyen adımları takip edebileceği **kişiselleştirilmiş hukuki süreç yol haritası**; hukuki bilgilendirmelerin profesyonel hukuki danışmanlık yerine geçmediğinin kullanıcıya açıkça belirtilmesi; kullanıcıların profil ekranında kişisel bilgilerini, uzmanlıklarını, ilgi alanlarını, katıldıkları ekipleri, oluşturdukları projeleri, geçmiş ve güncel proje başvurularını, kaydettikleri fırsatları ve girişimcilik faaliyetlerini görüntüleyebilmesi; **Mentorlarım** bölümünden bağlantı kurdukları mentorları ve mentorluk süreçlerini takip edebilmesi; profil ekranında Ayarlar, Bildirimler, Yardım ve Destek bölümlerinin bulunması; kullanıcıların isteğe bağlı olarak **kişilik ve çalışma tarzı testi** doldurabilmesi, testin tamamlanmasının profil doluluk oranına katkı sağlaması ve sonuçların kullanıcının tercihine bağlı olarak ekip arkadaşı uyumluluk önerilerinde destekleyici bilgi olarak değerlendirilmesi; kişilik testi sonuçlarının kullanıcıları kesin kategorilere ayırmak veya başvuruları otomatik olarak reddetmek amacıyla kullanılmaması; profil bilgilerinin tamamlanma yüzdesini gösteren **profil doluluk göstergesi**; ekip başvuruları, mentor görüşme talepleri, mesajlar, proje gelişmeleri, destek programlarının son başvuru tarihleri ve yaklaşan görevler için **uygulama içi bildirimler ve kullanıcı tercihine bağlı hatırlatıcılar**; tüm bu özelliklerin kullanıcı dostu, erişilebilir, modern ve mobil öncelikli bir arayüz üzerinden sunulması.

## 2. Mimari Yapı: Özellik Bazlı (Feature-Based Architecture)

StartPath uygulamasında **Feature-Based Architecture (Özellik Bazlı Mimari)** kullanılacaktır. Kodlar kesinlikle tek bir dosyada veya klasörde toplanmayacaktır. Her özellik kendi `features` klasörü altında bağımsız bir modül olarak geliştirilecektir.

Her modül kendi `controller`, `models`, `view` ve `widgets` klasörlerine sahip olacaktır. Uygulama genelinde ortak kullanılan tema, renk, sabit, yardımcı fonksiyon ve servisler `core` klasöründe tutulacaktır.

```text
lib/
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_constants.dart
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   ├── extensions/
│   │
│   ├── services/
│   │
│   ├── utils/
│   │
│   └── widgets/
│
├── features/
│   │
│   ├── auth/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── onboarding/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── home/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── startup/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── team_matching/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── mentor_matching/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── legal_roadmap/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── opportunities/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── applications/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── project_workspace/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── messaging/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── personality_test/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── notifications/
│   │   ├── controller/
│   │   ├── models/
│   │   ├── view/
│   │   └── widgets/
│   │
│   ├── profile/
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
# sadece uygulama başlatma ve tema bölümleri



### Mimari Kurallar

1. **Modüler yapı:** Her özellik yalnızca kendi `features` klasörü altında geliştirilecektir. Birbirinden bağımsız özellikler aynı dosyada birleştirilmeyecektir.
2. **Controller:** Kullanıcı etkileşimleri, iş mantığı ve ekran durumlarının yönetimi bu katmanda gerçekleştirilecektir.
3. **Models:** Kullanıcı, girişim, mentor, ekip, başvuru ve diğer veri modelleri ilgili modüllerin `models` klasörlerinde tanımlanacaktır.
4. **View:** Uygulama ekranları ilgili modülün `view` klasöründe tutulacaktır. Ekran dosyalarında gereksiz iş mantığı bulunmayacaktır.
5. **Widgets:** Tekrar kullanılabilir arayüz bileşenleri ilgili modülün `widgets` klasöründe oluşturulacaktır. Birden fazla modül tarafından kullanılan genel bileşenler `core/widgets` klasörüne taşınacaktır.
6. **Core:** Uygulama genelinde kullanılan renkler, temalar, sabitler, servisler, yardımcı fonksiyonlar ve ortak bileşenler `core` klasöründe yönetilecektir.
7. **Tema yönetimi:** Aydınlık ve koyu tema tanımlamaları `core/theme/app_theme.dart`, ortak renk sabitleri ise `core/constants/app_colors.dart` üzerinden yönetilecektir. Ekranlarda gereksiz sabit renk tanımlamalarından kaçınılacaktır.
8. **Kod tekrarının önlenmesi:** Aynı işlevi gerçekleştiren kodlar farklı modüllerde tekrar yazılmayacak, ihtiyaç durumunda ortak bileşen veya servislere dönüştürülecektir.
9. **Modüller arası iletişim:** Modüller birbirlerinin ekran veya controller yapılarına doğrudan bağımlı hâle getirilmeyecek; ortak veri ve işlemler tanımlanmış arayüzler ya da servisler üzerinden yönetilecektir.
10. **Sürdürülebilirlik:** Yeni özellikler mevcut mimariyi bozmadan eklenebilecek şekilde geliştirilecektir. Kodların okunabilir, test edilebilir, bakım yapılabilir ve SOLID prensiplerine uygun olmasına dikkat edilecektir.
11. **Main dosyası:** `main.dart` yalnızca uygulamanın başlatılması ve temel yapılandırmalar için kullanılacak; ekran tasarımları ve özelliklere ait iş mantıkları bu dosyada toplanmayacaktır.

## 3. Kırmızı Çizgiler: Kod Kalite Standartları

StartPath projesinde geliştirilen tüm kodlar aşağıdaki kalite, performans ve mimari kurallara **UYMAK ZORUNDADIR.** Yapay zeka ajanları (Antigravity) ve yazılım geliştiriciler bu kurallara aykırı kod oluşturamaz.

### 1. State Yönetim Standartları

- Sayfa düzeyinde ağır `setState` kullanımı **KESİNLİKLE YASAKTIR.**
- `StatefulWidget` yalnızca buton animasyonları, sekme seçimleri ve geçici görsel durumlar gibi basit, yerel arayüz işlemlerinde kullanılabilir.
- Kullanıcı oturumları, girişim bilgileri, mentor eşleştirmeleri, ekip başvuruları, mesajlaşma ve proje ilerleme durumları gibi uygulama verileri ilgili modüllerin `controller` katmanında yönetilecektir.
- İş mantığı ile kullanıcı arayüzü birbirinden ayrı tutulacaktır.
- Modüller arası veri tutarlılığı korunacak, aynı verinin farklı ekranlarda gereksiz şekilde tekrar yönetilmesi önlenecektir.
- Durum yönetiminde öncelikle Flutter'ın yerel çözümleri olan `ChangeNotifier`, `ValueNotifier`, `ListenableBuilder` ve `ValueListenableBuilder` gibi yapılar tercih edilecektir.
- Harici state management paketleri yalnızca ihtiyaç gerekçelendirilip proje sahibinden onay alındıktan sonra kullanılabilir.

### 2. UI ve Performans Kuralları

- Statik ve `const` kullanımına uygun tüm widget'larda `const` kullanımı **ZORUNLUDUR.**
- Uygulamanın renkleri ve metin stilleri merkezi tema dosyalarından yönetilecektir.
- Renk tanımlamaları `core/constants/app_colors.dart`, tema yapılandırmaları ve metin stilleri `core/theme/app_theme.dart` dosyasında tutulacaktır.
- Ekranlarda rastgele sabit renk ve metin stili tanımlamaları yapılmayacaktır.
- **40 satırı geçen `build()` metotları**, daha küçük ve anlamlı widget bileşenlerine ayrılacaktır.
- Her ekran, yalnızca kendi sorumluluğuyla ilgili arayüz bileşenlerini içerecektir.
- Tekrar kullanılan bileşenler ortak widget yapısına taşınacaktır.
- Uzun mentor listeleri, ekip ilanları, proje başvuruları ve destek programları gibi dinamik içeriklerde `ListView.builder` veya uygun tembel yükleme yöntemleri kullanılacaktır.
- Gereksiz widget yeniden oluşturulmaları önlenecek ve yalnızca değişen arayüz bölümleri güncellenecektir.
- Ağ istekleri, veri işleme ve eşleştirme hesaplamaları doğrudan `build()` metodu içerisinde gerçekleştirilmeyecektir.
- Uygulama arayüzü farklı ekran boyutlarına uyumlu, erişilebilir ve mobil öncelikli geliştirilecektir.
- Aydınlık ve koyu tema desteği merkezi tema yönetimi üzerinden sağlanacaktır.
- Yüklenme, boş liste, bağlantı hatası ve başarısız işlem durumları için tutarlı arayüz bileşenleri oluşturulacaktır.

### 3. Yasaklı Paketler ve Bağımlılık Yönetimi

- Projeye onay alınmadan harici ağır state management paketleri **EKLENMEYECEKTİR.**
- Dart ve Flutter'ın yerel çekirdek API'lerinin kullanılması esastır.
- Riverpod, Bloc, GetX ve benzeri harici durum yönetimi çözümleri proje sahibinin açık onayı olmadan kullanılmayacaktır.
- Yeni bir paket eklenmeden önce paketin gerçekten gerekli olup olmadığı, mevcut Flutter çözümleriyle aynı işlevin gerçekleştirilip gerçekleştirilemeyeceği ve projenin performansına etkisi değerlendirilecektir.
- Aynı işlevi gerçekleştiren birden fazla paket projeye eklenmeyecektir.
- Kullanılmayan paketler ve gereksiz bağımlılıklar projeden kaldırılacaktır.
- Yeni paketlerin Flutter 3.34.3 ve Dart 3.8.3 ile uyumluluğu kontrol edilecektir.
- Antigravity, yeni bir harici paket eklemeden önce paket adını, kullanım amacını ve neden gerekli olduğunu açıklayarak **kullanıcı onayı almak zorundadır.**

### 4. Kod Kalitesi ve Güvenlik Kuralları

- Kodlar okunabilir, modüler, sürdürülebilir ve SOLID prensiplerine uygun yazılacaktır.
- Değişken, sınıf, metot ve dosya isimleri açıklayıcı olacak; Dart isimlendirme kurallarına uyulacaktır.
- Gereksiz kod tekrarından kaçınılacaktır.
- Kullanıcıların kişisel bilgileri, mentor profilleri, mesajları ve girişim fikirleri güvenli şekilde işlenecektir.
- Şifreler, API anahtarları ve diğer gizli bilgiler kaynak kod içerisine doğrudan yazılmayacaktır.
- Mentor doğrulama ve ekip başvurularında gerekli yetkilendirme kontrolleri uygulanacaktır.
- Hukuki süreçlere ilişkin içerikler bilgilendirme amacıyla sunulacak ve profesyonel hukuki danışmanlığın yerine geçtiği iddia edilmeyecektir.
- Kullanıcı izni gerektiren işlemlerde açık izin alınacak ve yalnızca gerekli verilere erişilecektir.
- Hatalar kullanıcıya anlaşılır şekilde gösterilecek, teknik hata ayrıntıları doğrudan son kullanıcıya sunulmayacaktır.
- Yeni geliştirilen özellikler mevcut modüllerin çalışmasını bozmayacak şekilde uygulanacaktır.
- Geliştirme tamamlandığında `flutter analyze` çalıştırılacak, mevcut testler kontrol edilecek ve tespit edilen hatalar giderilecektir.

## 4. Geliştirme, Analiz ve Test Komutları

StartPath projesinde geliştirme yapan yapay zeka ajanı (Antigravity) ve yazılım geliştiriciler, gerçekleştirdikleri her kod değişikliğinin ardından aşağıdaki analiz ve test işlemlerini **MUTLAKA** uygulamak zorundadır.

Kod değişiklikleri analiz ve test süreçlerinden başarıyla geçmeden tamamlanmış kabul edilmeyecektir.

### 1. Statik Kod Analizi (0 Uyarı ve 0 Hata Şartı)

```bash
flutter analyze
```

- Kod değişikliklerinden sonra mutlaka çalıştırılacaktır.
- Analiz sonucunda **0 hata ve 0 uyarı** bulunmalıdır.
- Tespit edilen hatalar ve uyarılar giderilmeden geliştirme tamamlanmış sayılmayacaktır.
- Kullanılmayan değişkenler, gereksiz import işlemleri, tür uyumsuzlukları ve Dart kodlama standartlarına aykırı kullanımlar kontrol edilecektir.

### 2. Birim ve Widget Testleri

```bash
flutter test
```

- Yeni özellik geliştirildiğinde veya mevcut özellik değiştirildiğinde ilgili testler yazılacak ya da güncellenecektir.
- Kullanıcı kayıt ve yönlendirme, girişim oluşturma, mentor eşleştirme, ekip başvuruları, hukuki yol haritası ve profil yönetimi gibi modüllerin temel işlevleri test edilecektir.
- Widget testleriyle ekran bileşenlerinin doğru oluşturulması ve temel kullanıcı etkileşimlerinin beklenen şekilde çalışması doğrulanacaktır.
- Mevcut testlerin başarısız olmasına neden olan değişiklikler düzeltilmeden geliştirme tamamlanmış kabul edilmeyecektir.
- **Tüm testlerin başarıyla geçmesi zorunludur.**

### 3. Projeyi Çalıştırma

```bash
flutter run
```

- Uygulama, geliştirme ortamında uygun bir cihaz veya emülatör üzerinde çalıştırılarak kontrol edilecektir.
- Yeni geliştirilen ekranların açılması, sayfalar arası yönlendirmeler, form işlemleri ve temel kullanıcı etkileşimleri doğrulanacaktır.
- Aydınlık ve koyu tema geçişleri ile mobil ekran uyumluluğu ilgili değişikliklerde kontrol edilecektir.
- Çalışma sırasında oluşan hatalar giderilecektir.
- Birden fazla cihaz bağlıysa uygun hedef cihaz seçilerek çalıştırılacaktır.

### 4. Geliştirme Sonrası Zorunlu Kontrol

Antigravity, her kod değişikliğinin ardından aşağıdaki işlemleri sırasıyla gerçekleştirecektir:

1. Değiştirilen dosyaları ve etkilenen modülleri kontrol etmek.
2. `flutter analyze` komutunu çalıştırmak.
3. Tespit edilen hata ve uyarıları gidermek.
4. `flutter test` komutunu çalıştırmak ve tüm testlerin başarıyla geçtiğini doğrulamak.
5. Uygun geliştirme ortamında `flutter run` ile uygulamanın çalışmasını kontrol etmek.
6. Yapılan değişikliklerin mevcut özellikleri bozmadığını doğrulamak.
7. Gerçekleştirilen işlemleri ve test sonuçlarını kullanıcıya raporlamak.

**Önemli Kural:** Antigravity, analiz veya test komutlarını çalıştırmadığı hâlde başarılı olduklarını iddia edemez. Komutların çalıştırılamadığı durumlarda bunun nedenini açıkça belirtmek ve eksik doğrulamaları kullanıcıya bildirmek zorundadır.

## 5. Ajanın Çıktı ve Yanıt Verme Standartları

StartPath projesinde geliştirme yapan yapay zeka ajanı (Antigravity), gerçekleştirdiği tüm işlemleri kullanıcıya açık, anlaşılır, düzenli ve teknik doğruluğu korunmuş bir şekilde sunmak **ZORUNDADIR.**

### 1. Açıklama Standartları

- Tüm açıklamalar Türkçe, net, anlaşılır ve doğrudan olacaktır.
- Teknik terimlerin anlamı korunacak; gerektiğinde kısa ve anlaşılır açıklamalar yapılacaktır.
- Gereksiz uzun açıklamalardan ve tekrarlardan kaçınılacaktır.
- Kullanıcıya yapılan işlemin ne olduğu, neden yapıldığı ve uygulamanın hangi özelliğini etkilediği açıklanacaktır.
- Mentor eşleştirme, ekip yönetimi, hukuki süreç rehberi, proje başvuruları ve profil yönetimi gibi özelliklerde gerçekleştirilen değişiklikler ilgili modül üzerinden açıklanacaktır.
- Kullanıcının onayı gereken mimari değişiklikler, yeni paketler ve önemli teknik kararlar uygulanmadan önce açıkça belirtilecektir.

### 2. Kod Değişikliklerinin Sunulması

- Küçük değişikliklerde dosyanın tamamı **KESİNLİKLE** yeniden paylaşılmayacaktır.
- Örneğin 500 satırlık bir dosyada yalnızca 3 satır değiştirildiyse sadece ilgili kod bölümü gösterilecektir.
- Kod değişiklikleri mümkün olduğunda `diff` formatında sunulacaktır.
- Eklenen, silinen ve değiştirilen kodlar açıkça ayırt edilebilir olacaktır.
- Yeni oluşturulan dosyalar ve bunların görevleri kısaca açıklanacaktır.
- Değişiklikler ilgili `features` modülü ve dosya yolu belirtilerek sunulacaktır.
- Kullanıcı özellikle talep etmediği sürece gereksiz uzun kod blokları paylaşılmayacaktır.

### 3. Dosya Yolları ve Bağlantılar

- Bahsedilen, oluşturulan veya değiştirilen her dosyanın proje içerisindeki konumu açıkça belirtilecektir.
- Dosya yolları mümkün olduğunda geliştirme ortamının desteklediği tıklanabilir bağlantılarla sunulacaktır.
- Bağlantılar gerçek dosya konumlarını göstermeli, var olmayan dosyalar için bağlantı oluşturulmamalıdır.
- Dosya yollarında StartPath'in özellik bazlı klasör yapısı esas alınacaktır.
- Yeni dosyalar oluşturulduğunda hangi modül altında ve hangi amaçla oluşturulduğu açıklanacaktır.

### 4. Kod Doğrulama ve Test Sonuçları

- Her kod değişikliğinden sonra `flutter analyze` ve `flutter test` komutları çalıştırılarak sonuçları kontrol edilecektir.
- Uygun geliştirme ortamında `flutter run` komutuyla uygulamanın çalışması doğrulanacaktır.
- Analiz ve test sonuçları kullanıcıya açıkça bildirilecektir.
- Hata veya uyarı varsa bunlar gizlenmeyecek, nedenleri açıklanacak ve giderilecektir.
- Komutların çalıştırılamadığı durumlar açıkça belirtilecek, yapılmayan testler yapılmış gibi gösterilmeyecektir.
- Kod değişikliklerinden sonra kullanıcıya gerektiğinde şu doğrulama yönergeleri verilecektir:

```bash
flutter analyze
flutter test
flutter run
```

### 5. Değişiklik Sonrası Yanıt Formatı

Antigravity, tamamladığı geliştirmelerden sonra kullanıcıya aşağıdaki yapıda kısa bir rapor sunacaktır:

**Yapılan Değişiklikler:**
- Geliştirilen veya düzenlenen özellikler.
- Yapılan değişikliklerin kısa açıklaması.

**Etkilenen Dosyalar:**
- Oluşturulan veya değiştirilen dosyaların yolları ve varsa tıklanabilir bağlantıları.

**Analiz ve Test Sonuçları:**
- `flutter analyze`: Başarılı / Başarısız / Çalıştırılamadı
- `flutter test`: Başarılı / Başarısız / Çalıştırılamadı
- `flutter run`: Başarılı / Başarısız / Çalıştırılamadı

**Kullanıcı İçin Notlar:**
- Varsa gerekli manuel kontroller.
- Kullanıcı onayı gerektiren işlemler.
- Tamamlanmamış veya sonraki aşamada yapılması gereken çalışmalar.

**Önemli Kural:** Antigravity, gerçekleştirmediği işlemleri tamamlanmış gibi gösteremez; test edilmemiş kodları doğrulanmış olarak sunamaz ve kullanıcıdan onay almadan belirlenen proje mimarisini veya temel geliştirme standartlarını değiştiremez.