# PackPilot — Akıllı Seyahat ve Valiz Asistanı

Bu doküman, PackPilot Flutter projesinde geliştirme yapacak olan Google Antigravity Agent ve yazılım geliştiricileri için bağlayıcı bir proje kılavuzudur.

Projede geliştirilen tüm modüller, kullanıcı arayüzleri, veri modelleri ve iş mantıkları bu dokümanda belirtilen gereksinimlere uygun olmak zorundadır.

Agent, kullanıcı onayı olmadan temel uygulama akışını, seçilen teknolojileri veya mimari standartları değiştiremez.

---

## 1. Proje Özeti ve Teknolojiler

- **Uygulama Adı:** PackPilot
- **Uygulama Açıklaması:** Akıllı Seyahat Planlama ve Valiz Hazırlama Asistanı
- **Hedef Platformlar:** Öncelikli iOS ve Android; sonraki aşamalarda Web ve Masaüstü
- **Frontend:** Flutter
- **Programlama Dili:** Dart
- **Flutter SDK:** 3.29.0 (proje için seçilen başlangıç sürümü)
- **Dart SDK:** Flutter SDK ile birlikte gelen uyumlu Dart sürümü
- **Backend:** Supabase
- **Backend Programlama Dili:** TypeScript
- **Backend Çalışma Ortamı:** Deno / Supabase Edge Functions
- **Veritabanı:** Supabase PostgreSQL
- **Kimlik Doğrulama:** Supabase Authentication
- **Hava Durumu API:** Open-Meteo Forecast API
- **Lokasyon Servisi:** Open-Meteo Geocoding API
- **Bildirim Sistemi:** Firebase Cloud Messaging (FCM)
- **Yerel Bildirimler:** flutter_local_notifications
- **Zamanlanmış İşlemler:** Supabase Cron
- **Öneri Motoru:** Dart tabanlı kural motoru
- **Geliştirme Ortamı:** Google Antigravity
- **Tasarım Dili:** Material 3
- **Tema Desteği:** Karanlık ve Aydınlık Mod
- **State Yönetimi:** ValueNotifier + ValueListenableBuilder
- **Navigasyon:** go_router
- **HTTP İstekleri:** dio
- **Takvim Arayüzü:** table_calendar
- **Tarih ve Saat İşlemleri:** intl

### 1.1. Projenin Amacı

PackPilot, kullanıcıların seyahat hazırlıklarını kolaylaştırmak amacıyla geliştirilen akıllı bir mobil uygulamadır.

Uygulama aşağıdaki bilgileri kullanarak seyahat hazırlık sürecini yönetir:

- Seyahat lokasyonu
- Seyahat başlangıç ve bitiş tarihleri
- Varış ve ayrılış saatleri
- Seyahat süresi
- Günlük ve saatlik hava durumu
- Seyahat türü ve alt türü
- Kullanıcının oluşturduğu eşya listesi

PackPilot kullanıcıya seyahat koşullarına uygun kıyafet ve hazırlık önerileri sunar.

Kullanıcı kendi eşya listesini oluşturur, tahmini valiz ağırlığı ve hacmi hakkında bilgi alır ve hazırladığı eşyaları kontrol ekranından işaretleyebilir.

### 1.2. Temel Özellikler

1. Kullanıcı kayıt ve giriş sistemi
2. Seyahat takvimi ve lokasyon seçimi
3. İsteğe bağlı varış ve ayrılış saati belirleme
4. Seyahat süresinin otomatik hesaplanması
5. Günlük seyahat ajandası
6. Saatlik ve günlük hava durumu analizi
7. Hava durumu değişiklik bildirimleri
8. Seyahat türü seçimi
9. Akıllı kıyafet ve hazırlık önerileri
10. Kategori bazlı eşya listesi oluşturma
11. Seyahat türüne özel eşya kategorileri
12. Tahmini ağırlık ve hacim hesaplama
13. Valiz hazırlama kontrol sistemi
14. Güncel Valizim ekranı
15. Seyahat düzenleme ve silme
16. Geçmiş, güncel ve gelecek seyahat ajandası
17. Alışveriş listeleri
18. İsteğe bağlı adet döngüsü takibi
19. Profil ve hesap yönetimi
20. Bildirim ve uygulama ayarları
21. Hesap silme

---

## 2. Mimari Yapı: Özellik Bazlı (Feature-Based)

Kodlar kesinlikle tek bir dosyada veya tek bir klasörde toplanmayacaktır.

Her uygulama modülü kendi `features` klasöründe bulunmalıdır.

UI, State Controller, Model ve Repository/Service sorumlulukları birbirinden ayrılmalıdır.

### 2.1. Proje Klasör Hiyerarşisi

```text
packpilot/
│
├── PROJECT.md
├── pubspec.yaml
│
├── .agents/
│   └── skills/
│       └── packpilot-feature-scaffold/
│           └── SKILL.md
│
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   └── app_constants.dart
│   │   │
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   │
│   │   ├── router/
│   │   │   └── app_router.dart
│   │   │
│   │   ├── services/
│   │   │   ├── supabase_service.dart
│   │   │   ├── weather_service.dart
│   │   │   └── notification_service.dart
│   │   │
│   │   ├── utils/
│   │   │   ├── date_utils.dart
│   │   │   └── luggage_calculator.dart
│   │   │
│   │   └── widgets/
│   │       ├── app_button.dart
│   │       ├── app_loading.dart
│   │       └── app_error.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── trip_planner/
│   │   ├── weather/
│   │   ├── trip_type/
│   │   ├── recommendations/
│   │   ├── packing_list/
│   │   ├── luggage_analysis/
│   │   ├── checklist/
│   │   ├── agenda/
│   │   ├── shopping/
│   │   ├── profile/
│   │   ├── cycle_tracking/
│   │   └── notifications/
│   │
│   └── main.dart
│
├── supabase/
│   ├── functions/
│   │   ├── weather-alerts/
│   │   ├── send-notification/
│   │   └── delete-account/
│   │
│   ├── migrations/
│   └── config.toml
│
└── test/
    ├── unit/
    ├── widget/
    └── integration/
```

### 2.2. Her Feature İçin Zorunlu Yapı

```text
lib/features/<feature_name>/
│
├── controllers/
│   └── <feature_name>_controller.dart
│
├── models/
│   └── <feature_name>_model.dart
│
├── view/
│   └── <feature_name>_view.dart
│
├── widgets/
│   └── <feature_name>_card.dart
│
└── repositories/
    └── <feature_name>_repository.dart
```

`repositories` klasörü, yalnızca veri erişimi gerektiren modüllerde oluşturulmalıdır.

### 2.3. Mimari Sorumluluklar

**View**
- Kullanıcı arayüzünü oluşturur.
- Kullanıcı etkileşimlerini Controller'a iletir.
- İş mantığı içermez.

**Controller**
- Uygulamanın durumunu yönetir.
- ValueNotifier kullanır.
- İş kurallarını uygular.
- Repository veya Service katmanlarını çağırır.

**Model**
- Veri yapılarını tanımlar.
- Immutable olmalıdır.
- Gerekli olduğunda `copyWith`, `fromJson` ve `toJson` metotlarını içerir.

**Widget**
- Yeniden kullanılabilir küçük arayüz bileşenleri içerir.

**Repository**
- Veritabanı işlemlerini yönetir.
- UI katmanından bağımsız çalışır.

**Service**
- Harici servis ve API bağlantılarını yönetir.

### 2.4. main.dart Kuralları

`main.dart` yalnızca aşağıdaki görevlerden sorumludur:

- Flutter başlatma
- Gerekli servisleri başlatma
- Uygulama teması
- Uygulama router bağlantısı
- Uygulama giriş noktası

Büyük ekranlar, iş mantığı veya API işlemleri `main.dart` içerisinde yazılmayacaktır.

---

## 3. Kırmızı Çizgiler — Kod Kalite Standartları

### 3.1. State Yönetim Standartları

Sayfa düzeyindeki iş mantığı için ağır `setState` kullanılmayacaktır.

Temel durum yönetimi:

- ValueNotifier
- ValueListenableBuilder

kullanılarak gerçekleştirilecektir.

`StatefulWidget`, animasyon, form yaşam döngüsü, Controller başlatma ve dispose gibi yerel arayüz ihtiyaçlarında kullanılabilir.

Yeni bir state yönetimi paketi kullanıcı onayı olmadan eklenmeyecektir.

### 3.2. UI ve Performans Kuralları

1. Mümkün olan bütün statik widgetlarda `const` kullanılacaktır.
2. Renkler merkezi tema dosyalarında tanımlanacaktır.
3. Metin stilleri tema üzerinden yönetilecektir.
4. Büyük `build()` metotlarından kaçınılacaktır.
5. Yaklaşık 40 satırı aşan karmaşık build bölümleri küçük widgetlara ayrılacaktır.
6. API istekleri doğrudan build metotlarında yapılmayacaktır.
7. Gereksiz widget yeniden oluşturulması önlenecektir.
8. Liste ekranlarında uygun liste bileşenleri kullanılacaktır.
9. Yükleme, boş veri ve hata durumları ele alınacaktır.
10. Controller yaşam döngüsü doğru yönetilecek ve gerekli `dispose()` işlemleri yapılacaktır.

### 3.3. Yasaklı Yaklaşımlar

- Bütün uygulamayı tek dosyada yazmak
- UI ve veritabanı işlemlerini aynı sınıfta toplamak
- API anahtarlarını kaynak koda gömmek
- Kullanıcı verilerini onaysız silmek
- Sahte hava durumu verisini gerçek veri olarak göstermek
- Test edilmemiş kodu doğrulanmış olarak raporlamak
- Gereksiz paket ve bağımlılık eklemek
- Büyük uygulama durumunu kontrolsüz `setState` ile yönetmek
- Kullanıcının oluşturduğu eşya listesini otomatik değiştirmek

### 3.4. Veri Güvenliği

- Supabase Row Level Security kullanılacaktır.
- Kullanıcı yalnızca yetkili olduğu kayıtlara erişebilecektir.
- Gizli servis anahtarları istemciye eklenmeyecektir.
- Hassas sağlık verileri özel güvenlik kurallarına tabi olacaktır.
- Kullanıcı verileri gereksiz yere loglanmayacaktır.
- Silme işlemlerinde doğrulama uygulanacaktır.

---

## 4. Uygulama Akışı ve Ekran Hiyerarşisi

### 4.1. Ana Kullanıcı Akışı

```text
Uygulama Açılışı
       |
       v
Kayıt Ol / Giriş Yap
       |
       v
Ana Ekran
       |
       v
Yeni Seyahat Oluştur
       |
       v
Tarih ve Lokasyon Seçimi
       |
       v
Varış / Ayrılış Bilgileri
(İsteğe Bağlı)
       |
       v
Seyahat Ajandası
ve Hava Durumu
       |
       v
Seyahat Türü Seçimi
       |
       v
Kıyafet ve Hazırlık
Önerileri
       |
       v
Eşya Kategorileri
ve Liste Oluşturma
       |
       v
Listeyi Onayla
       |
       v
Tahmini Ağırlık
ve Hacim Uyarısı
       |
       v
Valiz Kontrol Ekranı
       |
       v
Bitti
       |
       v
Ana Ekran
(Güncel Valizim)
```

### 4.2. Profil Akışı

```text
Profil
  |
  ├── Hesap Bilgileri
  |
  ├── Ajandam
  |    ├── Geçmiş Seyahatler
  |    ├── Güncel Seyahatler
  |    ├── Gelecek Seyahatler
  |    └── Alışveriş Listeleri
  |
  ├── Adet Döngüsü Takibi
  |
  ├── Yardım & Destek
  |
  ├── Ayarlar
  |
  └── Hesabı Sil
```

### 4.3. Navigasyon Kuralları

- Kullanıcı önceki adıma dönebilmelidir.
- Ekran geçişlerinde girilen bilgiler korunmalıdır.
- Oluşturma sırasında kullanılan geçici seyahat verileri yönetilmelidir.
- Yarım kalan planların saklanması gerektiğinde taslak durumu kullanılabilir.
- Kullanıcının mevcut seyahatleri yeni plan oluşturulurken silinmemelidir.

---

## 5. Seyahat Planı Oluşturma

### 5.1. Adım 1 — Seyahat Takvimi

Kullanıcı **"Yeni Seyahat Oluştur"** butonuna basar.

Açılan takvim ekranında:

- Seyahat başlangıç tarihi
- Seyahat bitiş tarihi
- Seyahat lokasyonu

seçilir.

### İş Kuralları

1. Başlangıç ve bitiş tarihleri zorunludur.
2. Lokasyon seçimi zorunludur.
3. Bitiş tarihi başlangıç tarihinden önce olamaz.
4. Seyahat süresi otomatik hesaplanır.
5. Her seyahat benzersiz bir ID ile saklanır.

### 5.2. Adım 2 — Varış ve Ayrılış Bilgileri

Kullanıcıya aşağıdaki soru gösterilir:

**"Size daha doğru öneriler sunabilmemiz için varış ve ayrılış saatlerinizi girmek ister misiniz?"**

Butonlar:

- Evet
- Hayır, Devam Et

Evet seçilirse:

- Varış tarihi
- Varış saati
- Ayrılış tarihi
- Ayrılış saati

bilgileri alınır.

Hayır seçilirse yalnızca seçilen tarihler kullanılır.

### 5.3. Adım 3 — Seyahat Ajandası

Uygulama seyahat süresini günlük ajanda biçiminde gösterir.

Her gün için:

- Tarih
- Gün adı
- Lokasyon
- Hava durumu açıklaması
- Minimum sıcaklık
- Maksimum sıcaklık
- Yağış bilgileri
- Gerekli olduğunda saatlik hava durumu

gösterilir.

### Hava Durumu Filtreleme

- Varış gününde varış saatinden sonraki veriler kullanılır.
- Ayrılış gününde ayrılış saatine kadar olan veriler kullanılır.
- Ara günlerde günlük veya tam saatlik veriler değerlendirilir.
- Aynı gün varış ve ayrılış varsa belirtilen iki saat arasındaki veri kullanılır.
- Saat bilgisi yoksa günlük veriler kullanılır.

### 5.4. Hava Durumu Değişiklik Bildirimleri

Kullanıcının kayıtlı seyahatleri için hava durumu tahminleri belirli aralıklarla güncellenir.

Aşağıdaki önemli değişiklikler bildirim oluşturabilir:

- Yağış ihtimalinin artması
- Sıcaklığın belirgin düşmesi
- Sıcaklığın belirgin yükselmesi
- Kar beklentisi
- Şiddetli rüzgâr veya fırtına

Örnek:

**"PackPilot: İstanbul seyahatinizin ikinci gününde yağmur bekleniyor. Valiz listenizi kontrol etmek isteyebilirsiniz."**

### Bildirim Kuralları

- Kullanıcı izni zorunludur.
- Aynı değişiklik için tekrar tekrar bildirim gönderilmez.
- Bildirimler ilgili seyahat tarihleriyle sınırlandırılır.
- Hava durumu API'sinin tahmin süresi dışındaki tarihler için kesin hava tahmini gösterilmez.
- Yeni tahminler mevcut olduğunda seyahat verileri güncellenir.

---

## 6. Seyahat Türü Seçimi

Hava durumu ajandası tamamlandıktan sonra kullanıcı seyahat türünü seçer.

### 6.1. İş Gezisi

Alt türler:

- Konferans
- Sempozyum
- Toplantı

### 6.2. Kamp

- Kamp Gezisi

### 6.3. Tatil

Alt türler:

- Yaz Tatili
- Kış Tatili

### 6.4. Kültürel Gezi

- Kültürel Gezi

### Tür Seçimi Kuralları

1. Seyahat türü seçimi zorunludur.
2. Alt tür içeren seçeneklerde ilgili alt tür seçilir.
3. Seçilen tür öneri motoruna aktarılır.
4. Seçilen tür dinamik eşya kategorilerini belirler.
5. Seyahat türü daha sonra değiştirilebilir.

---

## 7. Akıllı Kıyafet ve Hazırlık Önerileri

Seyahat türü seçildikten sonra hazırlık önerileri ekranı açılır.

### 7.1. Değerlendirilecek Veriler

- Seyahat lokasyonu
- Seyahat süresi
- Günlük hava durumu
- Sıcaklık
- Yağış
- Rüzgâr
- Seyahat türü
- Seyahat alt türü
- Varış ve ayrılış saatleri

### 7.2. Hava Durumuna Göre Öneriler

**Sıcak Hava**
- Hafif kıyafetler
- Nefes alabilen kumaşlar
- Şapka
- Güneş koruyucu ürünler

**Soğuk Hava**
- Kalın mont
- Katmanlı giyim
- Termal kıyafet
- Eldiven ve bere

**Yağışlı Hava**
- Yağmurluk
- Su geçirmez ayakkabı
- Şemsiye

### 7.3. Seyahat Türüne Göre Öneriler

**İş Gezisi**
- Etkinliğe uygun kıyafetler
- İş belgeleri
- Sunum dosyaları
- Teknolojik cihazlar

**Kamp**
- Gece sıcaklığına uygun kıyafetler
- Açık hava ekipmanları
- Kamp güvenliği ihtiyaçları

**Yaz Tatili**
- Yazlık kıyafetler
- Yüzme malzemeleri
- Güneşten korunma ürünleri

**Kış Tatili**
- Soğuk hava kıyafetleri
- Kayak ekipmanları
- Kış sporları malzemeleri

**Kültürel Gezi**
- Rahat yürüyüş ayakkabıları
- Günlük hava durumuna uygun kıyafetler
- Gezi sırasında kullanılabilecek aksesuarlar

### Öneri Motorunun Kırmızı Çizgisi

Uygulama kullanıcıya öneriler sunar ancak kullanıcının eşya listesini otomatik doldurmaz.

**Eşya ekleme yetkisi kullanıcıya aittir.**

---

## 8. Eşya Kategorileri ve Liste Oluşturma

### 8.1. Standart Kategoriler

Bütün seyahat türlerinde aşağıdaki kategoriler bulunur:

1. Sağlık
2. Giyim
3. Aksesuarlar
4. Teknolojik Ürünler
5. Kişisel Bakım & İhtiyaçlar

### 8.2. Dinamik Kategoriler

Seçilen seyahat türüne göre ek kategoriler gösterilir.

| Seyahat Türü | Özel Kategori |
|---|---|
| İş Gezisi | İş Belgeleri ve Ekipmanları |
| Kamp | Kamp Ekipmanları |
| Yaz Tatili | Yüzme ve Plaj Malzemeleri |
| Kış Tatili | Kayak ve Kış Sporları Malzemeleri |
| Kültürel Gezi | Standart kategoriler |

### 8.3. Eşya Listesi Yönetimi

Kullanıcı her kategorinin içine alınacak eşyaları kendisi ekler.

Desteklenen işlemler:

- Eşya ekleme
- Eşya düzenleme
- Eşya silme
- Miktar belirleme
- Kategoriye göre listeleme
- Liste onaylama

### 8.4. Listeyi Onayla

Kullanıcı liste oluşturmayı bitirdiğinde **"Listeyi Onayla"** butonuna basar.

Ardından tahmini ağırlık ve hacim bilgilendirmesi gösterilir.

---

## 9. Tahmini Valiz Ağırlığı ve Hacmi

### 9.1. Gösterilecek Bilgiler

- Tahmini toplam ağırlık
- Tahmini toplam hacim
- Gerekli olduğunda kapasite uyarısı

### 9.2. Hesaplama

Tahmini Toplam Ağırlık:

`Σ (Eşya Miktarı × Birim Ağırlık)`

Tahmini Toplam Hacim:

`Σ (Eşya Miktarı × Birim Hacim)`

### İş Kuralları

1. Ürün ölçüleri mümkün olduğunda güvenilir referans verilerinden alınır.
2. Ölçüler bilinmiyorsa uydurulmaz.
3. Hesaplama sonuçlarının tahmini olduğu belirtilir.
4. Eksik veriler kullanıcıya bildirilir.
5. Kullanıcının girdiği miktar değerleri dikkate alınır.
6. Hacim değerlerinin gerçek valiz yerleşimine göre değişebileceği belirtilir.

Bu ekranın ardından kullanıcı valiz kontrol ekranına yönlendirilir.

---

## 10. Valiz Hazırlama Kontrol Ekranı

### 10.1. Hazırlanacak Eşyalar

Kullanıcının oluşturduğu eşyalar kategorilere göre listelenir.

Örnek:

**Giyim**
- [ ] Tişört
- [ ] Pantolon
- [ ] Mont

**Teknolojik Ürünler**
- [ ] Şarj Aleti
- [ ] Powerbank

### 10.2. Alınanlar Bölümü

Kullanıcı eşyayı işaretlediğinde eşya ekranın altındaki **"Alınanlar"** bölümüne geçer.

- İşaretlenen eşya hazırlanmış kabul edilir.
- Eşyanın kategori bilgisi korunur.
- İşaret kaldırılırsa eşya eski listeye döner.
- Kontrol durumu veritabanında saklanır.

### 10.3. Ekle Aktivite Butonu

Kontrol ekranında **"Ekle Aktivite"** butonu bulunur.

Bu buton kullanıcıyı önceki eşya kategorileri ve liste oluşturma ekranına yönlendirir.

Kullanıcı yeni eşya ekledikten sonra kontrol ekranına geri dönebilir.

### 10.4. Bitti Butonu

Kullanıcı **"Bitti"** butonuna bastığında:

1. Mevcut liste durumu kaydedilir.
2. Seyahat planı saklanır.
3. Kullanıcı ana ekrana yönlendirilir.
4. Güncel Valizim alanı güncellenir.

Bitti butonu bütün eşyaların işaretlenmesini zorunlu kılmaz.

---

## 11. Ana Ekran — Güncel Valizim

Ana ekranda **"Güncel Valizim"** bölümü bulunur.

### 11.1. Seyahat Bilgileri

- Lokasyon
- Seyahat tarihleri
- Seyahat türü
- Hazırlanan eşyaların durumu

### 11.2. Düzenle Butonu

Düzenle seçeneği dört alt işlem içerir:

1. Tarihi / Lokasyonu Değiştir
2. Türü Değiştir
3. Eşya Ekle
4. Kontrol Ekranı

### Tarih ve Lokasyon Değiştirme

- Seyahat bilgileri güncellenir.
- Hava durumu verileri yenilenir.
- Hazırlık önerileri yeniden değerlendirilir.
- Mevcut eşya listesi korunur.

### Seyahat Türü Değiştirme

- Yeni seyahat türü kaydedilir.
- Dinamik eşya kategorileri güncellenir.
- Mevcut eşyalar otomatik silinmez.

### Eşya Ekleme

Kullanıcı kategori ekranına yönlendirilir.

### Kontrol Ekranı

Mevcut hazırlanacak ve alınan eşya listeleri görüntülenir.

### 11.3. Aktiviteyi Sil

Kullanıcı oluşturduğu seyahat planını silebilir.

Silme işleminden önce onay penceresi gösterilmelidir.

---

## 12. Profil ve Ajandam

### 12.1. Profil Bilgileri

Kullanıcının kayıt olurken oluşturduğu hesap bilgileri görüntülenir.

### 12.2. Ajandam

Ajandam bölümünde:

- Geçmiş Seyahatler
- Güncel Seyahatler
- Gelecek Seyahatler
- Alışveriş Listeleri

bulunur.

Kullanıcı kayıtlı seyahatlerin detaylarına ve ilişkili eşya listelerine erişebilir.

### 12.3. Alışveriş Listeleri

Kullanıcı seyahatleriyle bağlantılı alışveriş listelerine erişebilir.

Alışveriş listesi öğeleri kullanıcı tarafından oluşturulur ve işaretlenebilir.

### 12.4. Adet Döngüsü Takibi

Kayıt sırasında kadın cinsiyetini seçen kullanıcılara isteğe bağlı adet döngüsü takibi sunulması planlanmaktadır.

Özelliğin ihtiyaç duyan diğer kullanıcılar tarafından da isteğe bağlı etkinleştirilebilmesi desteklenmelidir.

Temel özellikler:

- Adet başlangıç tarihi kaydı
- Döngü takibi
- Tahmini dönem hesaplama
- Seyahat tarihleriyle karşılaştırma
- Olası çakışma uyarıları

### Sağlık Verisi Güvenliği

- Kullanıcı onayı olmadan veri toplanmaz.
- Hassas veriler yetkisiz kişilerle paylaşılmaz.
- Kullanıcı bilgilerini silebilir.
- Döngü tahminleri tıbbi kesinlik taşımaz.
- Sağlık bilgileri varsayılan olarak üçüncü taraf yapay zekâ servislerine gönderilmez.

### 12.5. Yardım & Destek

Kullanıcının uygulama kullanımı hakkında yardım alacağı bölüm.

### 12.6. Ayarlar

- Tema ayarları
- Bildirim tercihleri
- Hesap tercihleri
- Gizlilik ayarları

### 12.7. Hesabı Sil

Kullanıcı hesabını ve ilgili kişisel verilerini silme işlemini başlatabilir.

Silme öncesinde kimlik doğrulama ve onay uygulanmalıdır.

---

## 13. Backend ve Veritabanı Standartları

### 13.1. Backend

**Supabase + TypeScript + Deno**

Temel veri işlemlerinde Supabase istemcisi kullanılabilir.

Aşağıdaki işlemler gerektiğinde Edge Functions üzerinden yürütülür:

- Hava durumu değişikliği kontrolü
- Bildirim gönderme
- Yetki gerektiren özel sunucu işlemleri
- Hesap silme
- Gizli anahtar gerektiren dış servis bağlantıları

### 13.2. PostgreSQL Tabloları

```text
profiles
trips
trip_weather
packing_categories
packing_items
shopping_lists
shopping_items
cycle_records
notifications
device_tokens
```

### 13.3. Veritabanı Kuralları

1. Her kullanıcı verisi ilgili kullanıcı kimliğine bağlıdır.
2. Seyahatler kullanıcıyla ilişkilendirilir.
3. Eşyalar seyahatle ilişkilendirilir.
4. Eşyaların hazırlanma durumu saklanır.
5. RLS kullanılır.
6. Kullanıcının başka kullanıcıların verilerine erişmesi engellenir.
7. Hassas sağlık verileri için ek güvenlik önlemleri uygulanır.

### 13.4. API Yönetimi

**Open-Meteo**

- Lokasyon koordinatlarını kullanır.
- Saatlik ve günlük tahminleri getirir.
- Tahmin süresi dışındaki verileri uydurmaz.
- Verileri seyahat tarihine göre filtreler.

**Firebase Cloud Messaging**

- Bildirim izni kontrolü
- Cihaz token yönetimi
- Hava durumu değişikliği bildirimleri
- Seyahat hatırlatmaları

**Supabase Cron**

- Zamanlanmış kontroller
- Hava durumu değişikliği analizi
- Bildirim fonksiyonlarının tetiklenmesi

Open-Meteo'nun ücretsiz kullanım koşulları incelenmeli; ticari kullanıma geçilirse uygun lisans seçilmelidir.

---

## 14. Geliştirme Analiz ve Test Komutları

Agent, herhangi bir kod değişikliğinden sonra ilgili doğrulama işlemlerini gerçekleştirmelidir.

### 14.1. Bağımlılık Kontrolü

```bash
flutter pub get
```

### 14.2. Kod Biçimlendirme

```bash
dart format .
```

### 14.3. Statik Kod Analizi

```bash
flutter analyze
```

**Hedef:** 0 hata ve 0 uyarı.

### 14.4. Birim ve Widget Testleri

```bash
flutter test
```

### 14.5. Projeyi Çalıştırma

```bash
flutter run
```

### 14.6. Test Gereksinimleri

Aşağıdaki senaryolar özellikle test edilmelidir:

- Geçerli ve geçersiz seyahat tarihleri
- İsteğe bağlı varış ve ayrılış saatleri
- Saat bazlı hava durumu filtreleme
- Hava durumu servis hataları
- Seyahat türü değişikliği
- Dinamik kategori oluşturma
- Eşya ekleme ve silme
- Eşya işaretleme ve geri alma
- Liste durumunun saklanması
- Ağırlık ve hacim tahminleri
- Seyahat düzenleme
- Seyahat silme
- Ajanda sınıflandırması
- Bildirim tekrarlarının önlenmesi
- Hassas verilerin güvenliği

Test edilemeyen işlemler kullanıcıya açıkça belirtilmelidir.

---

## 15. Ajanın Çıktı ve Yanıt Verme Standartları

### 15.1. Açıklamalar

Bütün açıklamalar Türkçe hazırlanacaktır.

Teknik terimler gerektiğinde İngilizce kullanılabilir.

Anlatım açık, doğrudan ve anlaşılır olacaktır.

### 15.2. Değişiklik Sunumları

Mevcut dosyada küçük bir değişiklik yapılmışsa bütün dosya gereksiz yere tekrar yazdırılmayacaktır.

Yalnızca değiştirilen bölümler veya diff gösterilecektir.

### 15.3. Dosya Yolları

Bahsedilen dosyaların proje içindeki tam göreli yolları belirtilecektir.

Antigravity ortamının desteklediği durumlarda tıklanabilir dosya bağlantıları kullanılacaktır.

### 15.4. Doğrulama

Agent geliştirme sonrasında:

1. Değiştirilen dosyaları belirtir.
2. Yapılan işlemleri açıklar.
3. Çalıştırılan testleri raporlar.
4. Hata varsa belirtir.
5. Kullanıcıya gerekli doğrulama adımlarını verir.

### 15.5. Kullanıcı Onayı

Aşağıdaki işlemlerden önce kullanıcı onayı alınmalıdır:

- Proje mimarisini değiştirmek
- Ana teknoloji setini değiştirmek
- Mevcut özellikleri kaldırmak
- Kullanıcı verilerini silmek
- Ağır harici paketler eklemek
- Ücretli servis entegrasyonu yapmak
- Temel uygulama akışını değiştirmek

### 15.6. Nihai Geliştirme İlkesi

PackPilot uygulaması:

- Modüler
- Sürdürülebilir
- Test edilebilir
- Güvenli
- Kullanıcı dostu
- Genişletilebilir

olmalıdır.

Agent, geliştirdiği her özellikte bu PROJECT.md dokümanını temel referans olarak kullanmalıdır.
