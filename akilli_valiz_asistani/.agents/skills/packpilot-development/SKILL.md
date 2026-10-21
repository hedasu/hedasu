---
name: packpilot-feature-scaffold
description: PackPilot Flutter projesinde yeni ekran veya işlev modülü oluştururken feature bazlı klasör yapısını, ValueNotifier state yönetimini, immutable veri modellerini, ayrılmış UI bileşenlerini, veri erişim katmanını ve birim test iskeletini proje standartlarına uygun biçimde oluşturur. Yeni seyahat planlama, hava durumu, öneri, eşya listesi, kontrol ekranı, ajanda veya profil modülü geliştirilirken kullanılmalıdır.
---

# PackPilot Flutter Feature Scaffold

Bu Skill, PackPilot projesinde yeni ekran veya işlev modülü oluşturulurken modüler mimari, reaktif state yönetimi ve UI ayrımı kurallarına uyulmasını sağlar.

Agent, yeni bir feature geliştirirken önce proje kökündeki `PROJECT.md` dosyasını okumalı ve ilgili ürün gereksinimlerini belirlemelidir.

## 1. Temel Kurallar

### 1.1. Asla Tek Dosyada Toplama

Aşağıdaki sorumluluklar ayrı dosyalarda bulunmalıdır:

- UI: `_view.dart`
- State Controller: `_controller.dart`
- Veri Modeli: `_model.dart`
- Küçük UI Bileşenleri: `_card.dart` veya ilgili widget dosyası
- Veri Erişimi: `_repository.dart`

### 1.2. State Yönetimi

Basit ve reaktif uygulama durumlarında:

- ValueNotifier
- ValueListenableBuilder

kullanılmalıdır.

Sayfa düzeyinde ağır `setState` kullanımından kaçınılmalıdır.

Controller nesnesinin yaşam döngüsü doğru yönetilmelidir.

### 1.3. Const Zorunluluğu

Mümkün olan bütün statik widgetlarda `const` kullanılmalıdır.

### 1.4. Clean UI

- UI içinde veritabanı sorgusu yazılmayacaktır.
- API istekleri widget build metotlarına eklenmeyecektir.
- İş mantığı Controller ve gerekli Service katmanlarında tutulacaktır.
- Karmaşık widgetlar küçük bileşenlere ayrılacaktır.

### 1.5. Veri Modelleri

Modeller immutable olmalıdır.

Gerekli modellerde:

- `copyWith`
- `fromJson`
- `toJson`

metotları bulunmalıdır.

### 1.6. Mevcut Projeyi Koruma

Yeni feature oluşturulurken mevcut navigasyon, tema, veri modelleri ve çalışan bileşenler bozulmamalıdır.

---

## 2. Adım Adım Uygulama Akışı

### Adım 1: PROJECT.md İncelemesi

Yeni kod oluşturmadan önce:

1. İstenen özelliği belirle.
2. PROJECT.md içindeki ilgili ekranı bul.
3. Kullanıcı akışını kontrol et.
4. Gerekli veri alanlarını belirle.
5. Diğer modüllerle bağlantıları incele.
6. Var olan kodları tekrar kullanma imkânını değerlendir.

Özellikle seyahat oluşturma adımlarının sırası korunmalıdır.

### Adım 2: Feature Klasör Yapısını Oluşturma

Hedef modül adını belirle.

Örnek:

`trip_planner`

Aşağıdaki yapıyı oluştur:

```text
lib/features/trip_planner/
│
├── controllers/
│   └── trip_planner_controller.dart
│
├── models/
│   └── trip_planner_model.dart
│
├── view/
│   └── trip_planner_view.dart
│
├── widgets/
│   └── trip_planner_card.dart
│
└── repositories/
    └── trip_planner_repository.dart
```

Repository yalnızca veri erişimi gerekiyorsa oluşturulmalıdır.

### Adım 3: Controller Dosyasını Yaz

Controller, durum yönetimi ve kullanıcı işlemlerinden sorumludur.

Örnek:

`lib/features/trip_planner/controllers/trip_planner_controller.dart`

```dart
import 'package:flutter/foundation.dart';

class TripPlannerController {
  final ValueNotifier<DateTime?> startDate =
      ValueNotifier<DateTime?>(null);

  final ValueNotifier<DateTime?> endDate =
      ValueNotifier<DateTime?>(null);

  final ValueNotifier<String> destination =
      ValueNotifier<String>('');

  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  void setDestination(String value) {
    destination.value = value;
  }

  bool validateTrip() {
    final start = startDate.value;
    final end = endDate.value;

    if (start == null || end == null) {
      return false;
    }

    if (destination.value.trim().isEmpty) {
      return false;
    }

    return !end.isBefore(start);
  }

  void dispose() {
    startDate.dispose();
    endDate.dispose();
    destination.dispose();
  }
}
```

### Controller Kuralları

1. ValueNotifier kullan.
2. UI kodu ekleme.
3. Veri doğrulamasını Controller veya uygun iş mantığı katmanında yap.
4. Asenkron işlemlerde hata yönetimi uygula.
5. Oluşturulan notifier nesnelerini dispose et.
6. Controller'ı widgetların her yeniden oluşturulmasında tekrar üretme.

Bu örnek seyahat formunun başlangıç iskeletidir. Varış ve ayrılış bilgileri, kalıcı veri işlemleri ve hata durumları gerçek modülde ayrıca tamamlanmalıdır.

### Adım 4: Model Dosyasını Oluştur

Model immutable olacaktır.

Örnek:

`lib/features/trip_planner/models/trip_planner_model.dart`

```dart
class TripPlannerModel {
  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String? tripType;
  final String? tripSubType;

  const TripPlannerModel({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.tripType,
    this.tripSubType,
  });

  TripPlannerModel copyWith({
    String? id,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    String? tripType,
    String? tripSubType,
  }) {
    return TripPlannerModel(
      id: id ?? this.id,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      tripType: tripType ?? this.tripType,
      tripSubType: tripSubType ?? this.tripSubType,
    );
  }

  factory TripPlannerModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TripPlannerModel(
      id: json['id'] as String,
      destination: json['destination'] as String,
      startDate: DateTime.parse(
        json['startDate'] as String,
      ),
      endDate: DateTime.parse(
        json['endDate'] as String,
      ),
      tripType: json['tripType'] as String?,
      tripSubType: json['tripSubType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'tripType': tripType,
      'tripSubType': tripSubType,
    };
  }
}
```

### Model Kuralları

- Alanlar mümkün olduğunda final olmalıdır.
- Veri tipleri açık tanımlanmalıdır.
- Zorunlu alanlarda required kullanılmalıdır.
- JSON dönüşümleri güvenilir biçimde yapılmalıdır.
- Sunucu veri şemasıyla uyum korunmalıdır.
- Nullable alanların silinmesi veya sıfırlanması gerektiğinde copyWith tasarımı bunu desteklemelidir.
- Tarih ve saat dilimi bilgileri kaybolmamalıdır.

Bu model temel iskelettir; gerçek seyahat modelinde varış ve ayrılış zamanları da bulunmalıdır.

### Adım 5: View Dosyasını Yaz

View yalnızca kullanıcı arayüzünü oluşturmalıdır.

Örnek:

`lib/features/trip_planner/view/trip_planner_view.dart`

```dart
import 'package:flutter/material.dart';

import '../controllers/trip_planner_controller.dart';

class TripPlannerView extends StatefulWidget {
  const TripPlannerView({super.key});

  @override
  State<TripPlannerView> createState() =>
      _TripPlannerViewState();
}

class _TripPlannerViewState
    extends State<TripPlannerView> {
  late final TripPlannerController controller;

  @override
  void initState() {
    super.initState();
    controller = TripPlannerController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Seyahat'),
      ),
      body: ValueListenableBuilder<String>(
        valueListenable: controller.destination,
        builder: (context, destination, child) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  destination.isEmpty
                      ? 'Lokasyon seçilmedi'
                      : destination,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.setDestination(
                      'İstanbul',
                    );
                  },
                  child: const Text('Örnek Lokasyon'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### View Kuralları

- Görsel bileşenler mümkün olduğunca küçük tutulmalıdır.
- Controller build içinde oluşturulmamalıdır.
- Controller dispose işlemi unutulmamalıdır.
- Veri değişimleri ValueListenableBuilder ile izlenmelidir.
- Tasarım renkleri tema üzerinden kullanılmalıdır.
- Gerçek lokasyon seçimi için sabit örnek değerler yerine kullanıcı girişi ve arama bileşenleri geliştirilmelidir.

### Adım 6: Widget Dosyasını Oluştur

Örnek:

`lib/features/trip_planner/widgets/trip_planner_card.dart`

```dart
import 'package:flutter/material.dart';

class TripPlannerCard extends StatelessWidget {
  final String destination;
  final String dateRange;
  final VoidCallback onTap;

  const TripPlannerCard({
    super.key,
    required this.destination,
    required this.dateRange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.luggage_outlined,
        ),
        title: Text(destination),
        subtitle: Text(dateRange),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: onTap,
      ),
    );
  }
}
```

### Widget Kuralları

- Yeniden kullanılabilir olmalıdır.
- İş mantığı içermemelidir.
- Gerekli verileri constructor üzerinden almalıdır.
- Tema sistemine uyumlu olmalıdır.
- Sabit arayüz elemanlarında const kullanılmalıdır.

### Adım 7: Repository Dosyası

Repository, Supabase işlemlerini yönetecektir.

Örnek dosya:

`lib/features/trip_planner/repositories/trip_planner_repository.dart`

Sorumluluklar:

- Seyahat kaydı oluşturma
- Seyahat kaydı okuma
- Seyahat kaydı güncelleme
- Seyahat kaydı silme
- Kullanıcıya ait seyahatleri listeleme

Kurallar:

1. Supabase sorguları View içine yazılmayacaktır.
2. Kullanıcı kimliği ve erişim kontrolleri dikkate alınacaktır.
3. Hatalar uygun biçimde yönetilecektir.
4. Repository test edilebilir olmalıdır.
5. Gerçek veritabanı işlemleri tanımlanan tablo şemasına göre uygulanmalıdır.

### Adım 8: Test Dosyalarını Oluştur

Feature için uygun test klasörünü kullan:

```text
test/
├── unit/
│   └── trip_planner_controller_test.dart
│
└── widget/
    └── trip_planner_view_test.dart
```

Minimum testler:

- Başlangıç tarihi doğrulaması
- Bitiş tarihi doğrulaması
- Boş lokasyon kontrolü
- Geçerli seyahat oluşturma
- Controller durum güncellemesi
- Widgetların doğru veriyi göstermesi

---

## 3. PackPilot Modül Geliştirme Standartları

### 3.1. Trip Planner

Seyahat oluşturma modülü aşağıdaki sırayı izlemelidir:

1. Tarih seçimi
2. Lokasyon seçimi
3. Varış ve ayrılış bilgileri
4. Seyahat ajandasına geçiş

Kullanıcının girdiği veriler ekran geçişlerinde korunmalıdır.

### 3.2. Weather

Hava durumu modülü:

- Open-Meteo üzerinden veri alır.
- Günlük ve saatlik verileri işler.
- Varış ve ayrılış saatlerini dikkate alır.
- Seyahat ajandasını besler.
- Eksik API verisini yönetir.

Gerçek hava durumu verileri bulunamadığında sistem tahmin uydurmaz.

### 3.3. Trip Type

Seyahat türleri merkezi bir veri yapısında tanımlanmalıdır.

Desteklenen türler:

- İş Gezisi
- Kamp
- Tatil
- Kültürel Gezi

Alt türler:

- Konferans
- Sempozyum
- Toplantı
- Yaz Tatili
- Kış Tatili

Tür seçimi dinamik eşya kategorilerini etkiler.

### 3.4. Recommendations

Öneri sistemi aşağıdaki girdileri kullanır:

- Tarih
- Lokasyon
- Sıcaklık
- Yağış
- Seyahat türü
- Seyahat süresi

Çıktı:

- Kıyafet önerileri
- Seyahat hazırlık bilgileri
- Hava koşullarına ilişkin uyarılar

Öneri motoru kullanıcı listesine kendiliğinden eşya eklemez.

### 3.5. Packing List

Standart kategoriler:

- Sağlık
- Giyim
- Aksesuarlar
- Teknolojik Ürünler
- Kişisel Bakım & İhtiyaçlar

Dinamik kategoriler:

- İş Belgeleri ve Ekipmanları
- Kamp Ekipmanları
- Yüzme ve Plaj Malzemeleri
- Kayak ve Kış Sporları Malzemeleri

Kullanıcı kategorileri kendisi doldurur.

### 3.6. Luggage Analysis

Ağırlık ve hacim hesaplamaları UI katmanında yapılmayacaktır.

Hesaplama mantığı ayrı bir servis veya yardımcı sınıfta bulunacaktır.

Eksik veri olduğunda kesin sonuç verilmez.

### 3.7. Checklist

Kontrol ekranında iki temel durum bulunur:

- Hazırlanacaklar
- Alınanlar

Eşya işaretlendiğinde `isPacked` değeri güncellenir.

İşaret kaldırıldığında eşya önceki durumuna döner.

"Ekle Aktivite" işlemi kullanıcıyı eşya ekleme ekranına götürür.

"Bitti" işlemi mevcut durumu saklar ve ana ekrana döner.

### 3.8. Agenda

Ajanda:

- Geçmiş seyahatleri
- Güncel seyahatleri
- Gelecek seyahatleri
- Alışveriş listelerini

göstermelidir.

Seyahat sınıflandırmaları tarih bilgisine göre yapılmalıdır.

### 3.9. Notifications

Bildirim sistemi:

- Kullanıcı iznini kontrol eder.
- Önemli hava durumu değişikliklerini belirler.
- Tekrarlayan bildirimleri engeller.
- FCM üzerinden bildirim gönderimini destekler.

Arka planda hava durumu kontrolü gereken işlemler yalnızca Flutter istemcisine bağlı olmamalıdır.

### 3.10. Cycle Tracking

Adet döngüsü takibi isteğe bağlıdır.

Veriler hassas sağlık bilgisi olarak değerlendirilmelidir.

Kullanıcının döngü tarihleri seyahat tarihleriyle karşılaştırılabilir.

Kesin tıbbi tahmin yapılmaz.

Kullanıcının onayı olmadan veriler işlenmez veya paylaşılmaz.

---

## 4. Clean Architecture Kuralları

### 4.1. Separation of Concerns

Her katmanın belirli bir sorumluluğu bulunmalıdır.

UI, Controller, Model ve Repository birbirinden ayrılmalıdır.

### 4.2. Reusability

Ortak widgetlar ve servisler yeniden kullanılabilir tasarlanmalıdır.

### 4.3. Testability

İş mantığı widgetlardan bağımsız test edilebilmelidir.

### 4.4. Dependency Injection

Controller ve Repository bağımlılıkları gerektiğinde constructor üzerinden aktarılmalıdır.

Harici dependency injection paketi zorunlu değildir.

### 4.5. Navigation

Navigasyon için projede belirlenen `go_router` yapısı kullanılmalıdır.

Sayfa geçişleri merkezi olarak yönetilmelidir.

### 4.6. Error Handling

Aşağıdaki durumlar ele alınmalıdır:

- İnternet bağlantısı yok
- API yanıt vermiyor
- Veritabanı hatası
- Geçersiz tarih
- Geçersiz lokasyon
- Boş liste
- Yetkisiz veri erişimi
- Bildirim izni reddedildi

Hata oluştuğunda mümkün olduğunca kullanıcı verileri korunmalıdır.

---

## 5. Geliştirme Analiz ve Test Komutları

Her feature geliştirmesinden sonra uygun doğrulama komutları çalıştırılmalıdır.

### Paket Kontrolü

```bash
flutter pub get
```

### Kod Biçimlendirme

```bash
dart format .
```

### Statik Analiz

```bash
flutter analyze
```

Hedef: 0 hata, 0 uyarı.

### Birim ve Widget Testleri

```bash
flutter test
```

### Uygulamayı Çalıştırma

```bash
flutter run
```

Test sonuçları raporlanmalıdır.

Başarısız testler gizlenmemelidir.

Test çalıştırılamadıysa nedeni açıklanmalıdır.

---

## 6. Kullanım Örnekleri

### Örnek 1: Yeni Seyahat Modülü Oluşturma

Kullanıcı isteği:

"PackPilot için seyahat tarih ve lokasyon seçimi ekranı oluştur."

Agent işlemleri:

1. PROJECT.md dosyasını inceler.
2. `trip_planner` feature yapısını kontrol eder.
3. Eksik klasör ve dosyaları oluşturur.
4. TripPlannerModel oluşturur.
5. TripPlannerController oluşturur.
6. TripPlannerView oluşturur.
7. Gerekli widgetları oluşturur.
8. Tarih ve lokasyon doğrulamasını ekler.
9. Testleri gerçekleştirir.

### Örnek 2: Hava Durumu Modülü

Kullanıcı isteği:

"Seyahat tarihlerine göre hava durumu raporlarını göster."

Agent işlemleri:

1. Weather feature yapısını oluşturur.
2. Open-Meteo servis bağlantısını hazırlar.
3. Saatlik ve günlük hava durumu modellerini oluşturur.
4. Varış ve ayrılış saati filtreleme kurallarını uygular.
5. Ajanda ekranında hava durumu bileşenleri oluşturur.
6. API hata durumlarını ele alır.
7. Birim ve widget testleri gerçekleştirir.

### Örnek 3: Valiz Kontrol Ekranı

Kullanıcı isteği:

"İşaretlenen eşyaları Alınanlar bölümüne taşı."

Agent işlemleri:

1. Checklist Controller'ı oluşturur veya mevcut Controller'ı inceler.
2. Eşya modelindeki `isPacked` alanını kullanır.
3. ValueNotifier ile liste durumunu yönetir.
4. İşaretlenen eşyaları Alınanlar bölümünde gösterir.
5. Geri alma işlemini destekler.
6. Veritabanındaki işaretleme durumunu günceller.
7. Gerekli testleri çalıştırır.

---

## 7. Ekstra İpuçları

### Modüler Geliştirme

Her feature bağımsız geliştirilip test edilebilecek şekilde hazırlanmalıdır.

### Controller Yaşam Döngüsü

Controller widget içinde oluşturuluyorsa doğru yaşam döngüsünde başlatılmalı ve dispose edilmelidir.

### API Entegrasyonu

Open-Meteo ve Supabase işlemleri doğrudan UI katmanında gerçekleştirilmemelidir.

### Navigasyon

Sayfa geçişleri mevcut kullanıcı akışına uygun olmalıdır.

### Tema

Renk ve tipografi bilgileri merkezi tema dosyalarından kullanılmalıdır.

### Veri Kaybını Önleme

Seyahat güncelleme ve ekran geçişlerinde kullanıcının oluşturduğu listeler korunmalıdır.

### Test

Yeni bir modül oluşturulduğunda yalnızca görünümü değil, veri doğrulama ve iş mantığı da test edilmelidir.

---

## 8. Sık Sorulan Sorular (SSS)

### Soru 1: Bu Skill ne zaman kullanılmalıdır?

**Cevap:** PackPilot projesinde yeni bir ekran, feature veya bağımsız işlev modülü oluşturulurken kullanılmalıdır.

### Soru 2: Bu Skill ne zaman kullanılmamalıdır?

**Cevap:** Yalnızca mevcut bir ekrandaki küçük bir metin, ikon veya renk düzeltmesinde sıfırdan feature iskeleti oluşturmak için kullanılmamalıdır.

Mevcut mimari korunarak yalnızca ilgili dosya düzenlenmelidir.

### Soru 3: Her yeni modül için Controller gerekli midir?

**Cevap:** Durum veya iş mantığı içeren modüllerde Controller kullanılmalıdır.

Sadece statik görüntüleme yapan küçük widgetlar için gereksiz Controller oluşturulmayabilir.

### Soru 4: Repository her feature için zorunlu mudur?

**Cevap:** Hayır. Veri erişimi gerektirmeyen modüllerde Repository oluşturulması zorunlu değildir.

### Soru 5: Yeni bir state yönetimi paketi eklenebilir mi?

**Cevap:** Kullanıcı onayı olmadan eklenemez.

Projede öncelikli standart ValueNotifier ve ValueListenableBuilder'dır.

### Soru 6: Backend kodları nereye yazılmalıdır?

**Cevap:** Flutter istemci kodları `lib/` içinde; TypeScript Supabase Edge Functions kodları `supabase/functions/` altında bulunmalıdır.

### Soru 7: Skill, PROJECT.md gereksinimlerini değiştirebilir mi?

**Cevap:** Hayır. Skill modül oluşturma yöntemini tanımlar. Ürün gereksinimleri PROJECT.md içinde tanımlanır.

---

## 9. Agent Çıktı Standartları

Her geliştirme görevi tamamlandığında aşağıdaki bilgiler Türkçe olarak sunulmalıdır:

### Yapılan İşlem

Hangi özellik veya modül geliştirildi?

### Oluşturulan veya Değiştirilen Dosyalar

Dosyaların proje içindeki tam göreli yolları belirtilmelidir.

### Uygulanan Mimari

Kullanılan Controller, Model, View, Widget ve Repository bileşenleri açıklanmalıdır.

### Test Sonuçları

Çalıştırılan analiz ve test komutlarının sonuçları belirtilmelidir.

### Sonraki Adım

Geliştirmenin devamında yapılması gereken işlem açıklanmalıdır.

Mevcut dosyada küçük değişiklikler yapıldıysa bütün dosyayı yeniden yazdırmak yerine değişen bölümler gösterilmelidir.

---

## 10. Nihai İlke

PackPilot projesinde geliştirilen bütün yeni feature modülleri:

- PROJECT.md gereksinimlerine uygun
- Feature-Based mimariyle düzenlenmiş
- ValueNotifier ile reaktif
- UI ve iş mantığı birbirinden ayrılmış
- Güvenli veri erişimine sahip
- Test edilebilir
- Modüler
- Yeniden kullanılabilir
- Sürdürülebilir

olmalıdır.

Agent'ın temel görevi yalnızca çalışan kod üretmek değil, PackPilot projesinin mimarisini ve kullanıcı akışını koruyarak geliştirme yapmaktır.
