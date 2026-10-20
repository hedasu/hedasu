---
name: startpath-feature-scaffold
description: >-
  StartPath girişimcilik ve mentor eşleştirme platformunda Flutter 3.34.3 ve Dart 3.8.3 standartlarına uygun Feature-Based Architecture (15 temel modül ve core katmanı), reaktif durum yönetimi (ValueNotifier & ListenableBuilder), Material 3 Modern Professional dinamik teması, 40 satırı geçmeyen build kuralı, birim/widget testleri ve 0 hata/0 uyarı analiz protokolünü üretir ve denetler.
---

# StartPath Feature Scaffold (Modüler Özellik ve Mimari Kılavuzu)

Bu yetenek, **StartPath – Girişimcilik ve Mentor Eşleştirme Platformu** projesinde yeni bir özellik modülü, ekran, servis veya widget eklerken ya da mevcut kodu güncellerken [project.md](file:///Users/d1-23/Documents/GitHub/hedasu/StartPath/project.md) belgesindeki tüm mimari kurallara, kırmızı çizgilere, kalite standartlarına ve proje kısıtlarına tam uyulmasını garanti altına alır.

---

## 1. Temel Kurallar ve Kırmızı Çizgiler (Strict Rules)

StartPath projesinde geliştirme yapan yapay zeka ajanları (Antigravity) ve yazılım geliştiriciler aşağıdaki kurallara **tavizsiz uymak zorundadır**:

### 1.1 Proje Kimliği ve Teknoloji Yığını
- **Uygulama Adı:** StartPath (*Start* + *Path*)
- **Slogan:** "Girişiminin yolunu birlikte çizelim."
- **Flutter Sürümü:** `3.34.3` (Tüm paketler ve kodlar bu sürümle uyumlu olmak zorundadır)
- **Dart Sürümü:** `3.8.3`
- **Hedef Platformlar:** iOS ve Android öncelikli; ardından web ve masaüstü.
- **Alt Navigasyon:** 5 ana sekme üzerinden kurgulanır: **Ana Sayfa**, **Ekip Bul**, **Mentorlar**, **Fırsatlar**, **Profil**.

### 1.2 Özellik Bazlı Mimari (Feature-Based Architecture)
- Kodlar asla tek bir dosyada veya klasörde toplanmaz.
- Her modül bağımsız olarak `lib/features/<feature_name>/` dizininde geliştirilir.
- Her modül kendi içinde şu 4 temel alt klasöre sahip olmak zorundadır:
  - `controller/`: Ekran durumu, iş mantığı ve reaktif dinleyiciler (`*_controller.dart`).
  - `models/`: Değişmez (immutable) veri modelleri (`*_model.dart`).
  - `view/`: Ekran koordinasyonu ve saf layout (`*_view.dart`).
  - `widgets/`: Sadece ilgili modüle özel tekrar kullanılabilir UI bileşenleri (`*_card.dart`, `*_widget.dart`).
- Birden fazla modül tarafından kullanılan genel renk, tema, servis ve widget'lar `lib/core/` altında toplanır.
- `main.dart` yalnızca uygulama başlatma ve tema yapılandırması içindir; ekran tasarımları veya iş mantığı içermez.

### 1.3 Reaktif State Yönetimi ve Ağır `setState` Yasağı
- Sayfa düzeyinde büyük widget ağaçlarını yeniden çizen ağır `setState` kullanımı **KESİNLİKLE YASAKTIR.**
- `StatefulWidget` yalnızca buton animasyonları, sekme seçimleri ve geçici yerel görsel durumlar için kullanılabilir.
- Kullanıcı oturumları, girişim bilgileri, mentor eşleştirmeleri, ekip başvuruları, mesajlaşma ve proje ilerleme durumları gibi uygulama verileri `controller` katmanında yönetilir.
- Durum yönetiminde Flutter'ın yerel çekirdek API'leri esastır: `ValueNotifier`, `ValueListenableBuilder`, `ListenableBuilder` ve `ChangeNotifier`.
- Harici ağır durum paketleri (Riverpod, Bloc, GetX, MobX vb.) proje sahibinin açık onayı olmadan **KESİNLİKLE EKLENMEYECEKTİR.**

### 1.4 UI, Performans ve 40 Satır Kuralı
- Statik ve uygun olan tüm widget tanımlarında `const` kullanımı **ZORUNLUDUR.**
- **Tek bir `build()` metodu asla 40 satırı geçemez.** 40 satırı aşan yapılar özel alt widget bileşenlerine ayrılmalıdır.
- Renkler ve metin stilleri kod içine gömülmez (hardcoded yazılmaz); `core/constants/app_colors.dart` ve `core/theme/app_theme.dart` üzerinden yönetilir.
- Uzun mentor listeleri, ekip ilanları, proje başvuruları ve fırsatlar gibi dinamik içeriklerde `ListView.builder` veya uygun tembel yükleme (lazy loading) yöntemleri kullanılır.
- `build()` fonksiyonu içinde doğrudan ağ isteği, veritabanı okuması veya ağır eşleştirme hesaplamaları yapılamaz.
- **Yüklenme (Loading), Boş Liste (Empty) ve Bağlantı Hatası (Error) Durumları:** Her dinamik ekranda bu üç durum için tutarlı ve tema uyumlu arayüz bileşenleri oluşturulması zorunludur.

### 1.5 Tasarım Dili ve Çift Tema Desteği (Material 3 Modern Professional)
- Material 3 Modern Professional tasarım dili benimsenir. Yuvarlatılmış modern kartlar, minimalist ikonlar, okunabilir tipografi, yumuşak gölgeler ve sade geçişler kullanılır.
- **Koyu Tema (Dark Mode):** Premium ve profesyonel atmosfer; koyu petrol yeşili, antrasit, derin orman yeşili ve şampanya altını vurgular.
- **Aydınlık Tema (Light Mode):** Modern, ferah ve güvenilir girişimcilik platformu atmosferi; fildişi, krem, adaçayı yeşili, petrol yeşili ve zarif altın detaylar.
- Kullanıcı tek dokunuşla aydınlık ve koyu tema arasında geçiş yapabilmelidir.

### 1.6 Yasaklı Paketler ve Bağımlılık Yönetimi
- Yeni bir paket eklenmeden önce paketin gerçekten gerekli olup olmadığı ve Flutter 3.34.3 & Dart 3.8.3 uyumluluğu kontrol edilmelidir.
- Antigravity, yeni bir harici paket eklemeden önce paket adını, sürümünü, eklenme amacını ve gerekçesini açıklayarak **kullanıcı onayı almak zorundadır.**

### 1.7 Projeye Özgü Kritik Kırmızı Çizgiler ve Domain Standartları
1. **Hukuki Süreç Yol Haritası Feragat Şartı (`legal_roadmap`):** Şirket türü, kuruluş, vergi ve tescil süreçlerine dair tüm bilgilendirmeler yalnızca rehberlik niteliğindedir. **"Sunulan hukuki bilgilendirmeler profesyonel hukuki danışmanlık yerine geçmez"** uyarısı kullanıcıya açıkça gösterilmelidir.
2. **Kişilik ve Çalışma Tarzı Testi Etik Kuralı (`personality_test`):** Test isteğe bağlıdır ve profil doluluk oranına katkı sağlar. Sonuçlar ekip uyumluluğu için destekleyici öneri sunabilir; **asla kullanıcıları kesin kategorilere ayırmak veya başvuruları otomatik reddetmek amacıyla kullanılamaz.**
3. **Mentor Doğrulama ve Rozet Sistemi (`mentor_matching`):** Mentorlar uzmanlık ve deneyimlerine göre doğrulanır ve arayüzde doğrulanmış mentor rozetiyle (`isVerified: true`) ayırt edilir.
4. **Ekip Başvuru Durum Takibi (`applications` & `team_matching`):** Başvurular dört standart durum üzerinden takip edilir: `Gönderildi` (submitted), `İnceleniyor` (reviewing), `Kabul Edildi` (accepted), `Reddedildi` (rejected).
5. **Esnek Çoklu Rol Desteği (`auth`, `onboarding`, `profile`):** Kayıtta "Fikrim Var", "Fikrim Yok" ve "Mentor Olmak İstiyorum" akışları sunulur; kullanıcılar profillerinde birden fazla role aynı anda sahip olabilir.
6. **Profil Doluluk Göstergesi (`profile`):** Kullanıcının profil bilgilerini ne oranda tamamladığını gösteren dinamik yüzde göstergesi yer almalıdır.

---

## 2. Dizin Yapısı ve 15 Resmi Modül Haritası

StartPath uygulamasında [project.md](file:///Users/d1-23/Documents/GitHub/hedasu/StartPath/project.md) standardı gereğince aşağıdaki 15 özellik modülü ve `core` dizini esastır:

```text
lib/
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart        # Koyu petrol yeşili, fildişi, şampanya altını vb.
│   │   ├── app_strings.dart       # Uygulama metinleri, hata mesajları
│   │   └── app_constants.dart     # Süreler, limitler, regex tanımları
│   ├── theme/
│   │   └── app_theme.dart         # Material 3 Aydınlık & Koyu tema yapılandırması
│   ├── extensions/                # BuildContext, String, DateTime yardımcıları
│   ├── services/                  # Ağ, depolama, bildirim servisleri
│   ├── utils/                     # Formatlayıcılar, doğrulayıcılar
│   └── widgets/                   # Uygulama genelinde paylaşılan ortak widget'lar
│
├── features/
│   ├── auth/                      # Giriş, kayıt, şifre sıfırlama, oturum kontrolü
│   ├── onboarding/                # "Fikrim Var", "Fikrim Yok", "Mentor Olmak İstiyorum" akışı
│   ├── home/                      # 5 sekmeli ana kabuk (Shell), özet paneli ve akış
│   ├── startup/                   # Kapsamlı girişim formu, fikir aşaması ve ekip ihtiyacı
│   ├── team_matching/             # Ekip arayan girişimler, pozisyon ilanları, uyumluluk önerisi
│   ├── mentor_matching/           # Mentor listesi, filtreleme, doğrulama rozeti, randevu talebi
│   ├── legal_roadmap/             # Şirketleşme adımları, hukuki rehber ve yasal feragat
│   ├── opportunities/             # TÜBİTAK, KOSGEB, hibe, yarışma ve filtreleme
│   ├── applications/              # Ekip üyelik başvuruları ve 4 durumlu süreç takibi
│   ├── project_workspace/         # Görev dağılımı, kilometre taşları, proje ilerleme takibi
│   ├── messaging/                 # Mentor ve ekip içi anlık mesajlaşma
│   ├── personality_test/          # İsteğe bağlı kişilik ve çalışma tarzı testi
│   ├── notifications/             # Başvuru, randevu, son tarih ve görev bildirimleri
│   ├── profile/                   # Çoklu rol profili, Mentorlarım sekmesi, doluluk göstergesi
│   └── settings/                  # Dinamik tema geçişi, hesap ayarları, yardım ve destek
│
└── main.dart                      # Yalnızca başlatma ve tema yapılandırması
```

### Her Modülün Standart İç Yapısı:
```text
lib/features/<feature_name>/
├── controller/
│   └── <feature_name>_controller.dart   # ValueNotifier, iş mantığı, dispose()
├── models/
│   └── <feature_name>_model.dart        # Immutable model, copyWith, fromJson, toJson
├── view/
│   └── <feature_name>_view.dart         # StatelessWidget, ListenableBuilder (<40 satır build)
└── widgets/
    └── <feature_name>_card.dart         # Modüler, const, tema uyumlu parçacıklar

test/features/<feature_name>/
├── controller/<feature_name>_controller_test.dart  # Birim testleri
└── view/<feature_name>_view_test.dart              # Widget testleri
```

---

## 3. Adım Adım Modül Geliştirme Akışı

### Adım 1: Klasör Yapısını Oluşturma
Terminal veya dosya sistemi üzerinden ilgili özellik klasörlerini oluşturun:
```bash
mkdir -p lib/features/<feature_name>/{controller,models,view,widgets}
mkdir -p test/features/<feature_name>/{controller,view}
```

---

### Adım 2: Veri Modelini Tanımlama (`models/<feature_name>_model.dart`)
Tüm veri modelleri **immutable** (değişmez) olmalı; `const` yapıcı, `copyWith`, `fromJson` ve `toJson` metotlarını barındırmalıdır.

```dart
/// StartPath Standart Mentor Profili Modeli
/// project.md standartlarına tam uyumludur.
class MentorProfileModel {
  final String id;
  final String fullName;
  final String title;
  final String sector;
  final double rating;
  final bool isVerified;
  final List<String> expertise;

  const MentorProfileModel({
    required this.id,
    required this.fullName,
    required this.title,
    required this.sector,
    required this.rating,
    required this.isVerified,
    required this.expertise,
  });

  MentorProfileModel copyWith({
    String? id,
    String? fullName,
    String? title,
    String? sector,
    double? rating,
    bool? isVerified,
    List<String>? expertise,
  }) {
    return MentorProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      title: title ?? this.title,
      sector: sector ?? this.sector,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
      expertise: expertise ?? this.expertise,
    );
  }

  factory MentorProfileModel.fromJson(Map<String, dynamic> json) {
    return MentorProfileModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      sector: json['sector'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isVerified: json['isVerified'] as bool? ?? false,
      expertise: (json['expertise'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'title': title,
      'sector': sector,
      'rating': rating,
      'isVerified': isVerified,
      'expertise': expertise,
    };
  }
}
```

---

### Adım 3: Controller Dosyasını Oluşturma (`controller/<feature_name>_controller.dart`)
State yönetimi `ValueNotifier` ile sağlanır. Loading, Empty ve Error durumları eksiksiz yönetilir. Bellek sızıntısını önlemek için dinleyiciler mutlaka `dispose()` edilir.

```dart
import 'package:flutter/foundation.dart';
import '../models/mentor_profile_model.dart';

/// StartPath Standart Controller Yapısı
/// Ağır setState yasaktır; atomik ValueNotifier yapıları kullanılır.
class MentorMatchingController {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);
  final ValueNotifier<List<MentorProfileModel>> mentors =
      ValueNotifier<List<MentorProfileModel>>([]);
  final ValueNotifier<String> selectedSector = ValueNotifier<String>('Tümü');

  List<MentorProfileModel> get filteredMentors {
    if (selectedSector.value == 'Tümü') return mentors.value;
    return mentors.value
        .where((m) => m.sector == selectedSector.value)
        .toList();
  }

  void filterBySector(String sector) {
    selectedSector.value = sector;
  }

  void clearError() {
    errorMessage.value = null;
  }

  Future<void> loadMentors() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      // Ağ veya veritabanı simülasyonu
      await Future<void>.delayed(const Duration(milliseconds: 300));
      mentors.value = const [
        MentorProfileModel(
          id: '1',
          fullName: 'Ayşe Yılmaz',
          title: 'Seri Girişimci & Fintek Danışmanı',
          sector: 'Fintech',
          rating: 4.9,
          isVerified: true,
          expertise: ['Fintech', 'Yatırım Turu', 'Büyüme Stratejisi'],
        ),
      ];
    } catch (e) {
      errorMessage.value = 'Mentor listesi yüklenirken bir sorun oluştu.';
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    isLoading.dispose();
    errorMessage.dispose();
    mentors.dispose();
    selectedSector.dispose();
  }
}
```

---

### Adım 4: View Dosyasını Yazma (`view/<feature_name>_view.dart`)
- `StatelessWidget` kullanılır.
- Reaktif alanlar `ValueListenableBuilder` veya `ListenableBuilder` ile dinlenir.
- Liste ve filtre durumu birlikte `Listenable.merge([controller.mentors, controller.selectedSector])` ile dinlenerek filtreleme anında anında güncellenir.
- **`build()` metodu 40 satırı geçemez.**
- Loading, Empty ve Error durumları kapsanır.

```dart
import 'package:flutter/material.dart';
import '../controller/mentor_matching_controller.dart';
import '../widgets/mentor_card.dart';

class MentorMatchingView extends StatelessWidget {
  final MentorMatchingController controller;

  const MentorMatchingView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Eşleştirme'),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.loadMentors,
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.isLoading,
          builder: (context, loading, _) {
            if (loading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            return _ContentStateRouter(controller: controller);
          },
        ),
      ),
    );
  }
}

class _ContentStateRouter extends StatelessWidget {
  final MentorMatchingController controller;

  const _ContentStateRouter({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: controller.errorMessage,
      builder: (context, error, _) {
        if (error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(error, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: controller.loadMentors,
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          );
        }
        return _MentorListBody(controller: controller);
      },
    );
  }
}

class _MentorListBody extends StatelessWidget {
  final MentorMatchingController controller;

  const _MentorListBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([controller.mentors, controller.selectedSector]),
      builder: (context, _) {
        final list = controller.filteredMentors;
        if (list.isEmpty) {
          return const Center(child: Text('Henüz eşleşen mentor bulunamadı.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return MentorCard(mentor: list[index]);
          },
        );
      },
    );
  }
}
```

---

### Adım 5: Modüler Widget Dosyasını Oluşturma (`widgets/<feature_name>_card.dart`)
- `StatelessWidget` ve `const` yapıcı kullanılır.
- Renkler doğrudan `Theme.of(context)` ve `core/constants/app_colors.dart` üzerinden alınır. Hardcoded renk kullanımı **kesinlikle yasaktır.**
- Alt bileşenlerin `build()` metotları da 40 satırı geçemez.

```dart
import 'package:flutter/material.dart';
import '../models/mentor_profile_model.dart';

class MentorCard extends StatelessWidget {
  final MentorProfileModel mentor;
  final VoidCallback? onTap;

  const MentorCard({
    super.key,
    required this.mentor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderRow(mentor: mentor, colorScheme: colorScheme, theme: theme),
              const SizedBox(height: 8),
              Text(
                mentor.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              _ExpertiseChips(expertise: mentor.expertise),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final MentorProfileModel mentor;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _HeaderRow({
    required this.mentor,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // Şampanya altını vurgusu (project.md altın detay standardı)
    final goldColor = colorScheme.tertiary;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                mentor.fullName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (mentor.isVerified) ...[
                const SizedBox(width: 6),
                Icon(Icons.verified_rounded, size: 18, color: colorScheme.primary),
              ],
            ],
          ),
        ),
        Icon(Icons.star_rounded, size: 18, color: goldColor),
        const SizedBox(width: 4),
        Text(
          mentor.rating.toStringAsFixed(1),
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ExpertiseChips extends StatelessWidget {
  final List<String> expertise;

  const _ExpertiseChips({required this.expertise});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: expertise.take(3).map((skill) {
        return Chip(
          label: Text(skill, style: const TextStyle(fontSize: 12)),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }
}
```

---

### Adım 6: Test İskeleti (Birim ve Widget Testleri)

[project.md](file:///Users/d1-23/Documents/GitHub/hedasu/StartPath/project.md) standardı gereğince her modül için hem **Controller Birim Testi** hem de **Widget Testi** hazırlanır:

#### 6.1 Birim Testi (`test/features/<feature>/controller/<feature>_controller_test.dart`):
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:startpath/features/mentor_matching/controller/mentor_matching_controller.dart';

void main() {
  group('MentorMatchingController Testleri', () {
    late MentorMatchingController controller;

    setUp(() {
      controller = MentorMatchingController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumu boş ve yüklenmiyor olmalıdır', () {
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, isNull);
      expect(controller.mentors.value.isEmpty, true);
      expect(controller.selectedSector.value, 'Tümü');
    });

    test('loadMentors çağrıldığında mentor listesi dolmalıdır', () async {
      await controller.loadMentors();
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, isNull);
      expect(controller.mentors.value.isNotEmpty, true);
      expect(controller.filteredMentors.isNotEmpty, true);
    });

    test('Sektör filtreleme beklenen sonuçları döndürmelidir', () async {
      await controller.loadMentors();
      controller.filterBySector('Fintech');
      expect(controller.selectedSector.value, 'Fintech');
      expect(controller.filteredMentors.every((m) => m.sector == 'Fintech'), true);
    });
  });
}
```

#### 6.2 Widget Testi (`test/features/<feature>/view/<feature>_view_test.dart`):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startpath/features/mentor_matching/controller/mentor_matching_controller.dart';
import 'package:startpath/features/mentor_matching/view/mentor_matching_view.dart';

void main() {
  testWidgets('MentorMatchingView boş liste durumunu doğru göstermelidir', (tester) async {
    final controller = MentorMatchingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: MentorMatchingView(controller: controller),
      ),
    );

    expect(find.text('Mentor Eşleştirme'), findsOneWidget);
    expect(find.text('Henüz eşleşen mentor bulunamadı.'), findsOneWidget);
  });
}
```

---

## 4. Geliştirme Sonrası Zorunlu 7 Adımlı Kontrol Listesi

Antigravity, her kod değişikliğinin ardından [project.md](file:///Users/d1-23/Documents/GitHub/hedasu/StartPath/project.md) Bölüm 4.4 gereğince şu 7 adımı sırasıyla gerçekleştirmek zorundadır:

1. **Değiştirilen dosyaları ve etkilenen modülleri kontrol etmek.**
2. **`flutter analyze` komutunu çalıştırmak.**
3. **Tespit edilen tüm hata ve uyarıları gidermek (0 hata, 0 uyarı ŞARTI).**
4. **`flutter test` komutunu çalıştırmak ve tüm birim/widget testlerinin başarıyla geçtiğini doğrulamak.**
5. **Uygun geliştirme ortamında `flutter run` ile uygulamanın derlendiğini ve çalıştığını kontrol etmek.**
6. **Yapılan değişikliklerin mevcut özellikleri bozmadığını doğrulamak.**
7. **Gerçekleştirilen işlemleri ve test sonuçlarını kullanıcıya açıkça raporlamak.**

> [!CAUTION]
> **Kesin Dürüstlük Kuralı:** Antigravity, analiz veya test komutlarını fiilen çalıştırmadığı hâlde başarılı olduklarını iddia edemez. Komutların çalıştırılamadığı durumlarda bunun nedenini açıkça belirtmek ve eksik doğrulamaları kullanıcıya bildirmek zorundadır.

```bash
# Doğrulama Komutları:
flutter analyze
flutter test
flutter run
```

---

## 5. Ajanın Çıktı ve Yanıt Verme Standartları

StartPath projesinde yanıt verirken [project.md](file:///Users/d1-23/Documents/GitHub/hedasu/StartPath/project.md) Bölüm 5 standartlarına tam uyum esastır:

### 5.1 Açıklama Standartları
- Tüm açıklamalar Türkçe, net, anlaşılır ve doğrudan olacaktır.
- Kullanıcıya işlemin ne olduğu, neden yapıldığı ve uygulamanın hangi modülünü etkilediği açıklanacaktır.
- Kullanıcı onayı gereken paketler veya mimari kararlar uygulanmadan önce açıkça belirtilecektir.

### 5.2 Kod Değişikliklerinin Sunulması
- Küçük değişikliklerde dosyanın tamamı **KESİNLİKLE** yeniden paylaşılmayacaktır.
- Örneğin 500 satırlık bir dosyada 3 satır değiştirildiyse yalnızca ilgili kod bölümü gösterilecektir.
- Kod değişiklikleri mümkün olduğunda `diff` formatında sunulacaktır.

### 5.3 Tıklanabilir Dosya Bağlantıları
- Bahsedilen veya değiştirilen tüm dosyalar için geliştirme ortamında tıklanabilir bağlantılar (`file:///...` şeması) sunulacaktır.

### 5.4 Zorunlu Yanıt Formatı Şablonu

```markdown
**Yapılan Değişiklikler:**
- Geliştirilen veya düzenlenen özelliklerin özeti.
- Yapılan değişikliklerin teknik açıklaması.

**Etkilenen Dosyalar:**
- [dosya_adi.dart](file:///Users/d1-23/Documents/GitHub/hedasu/StartPath/lib/.../dosya_adi.dart) (Tıklanabilir bağlantı)

**Analiz ve Test Sonuçları:**
- `flutter analyze`: Başarılı (0 hata, 0 uyarı) / Başarısız / Çalıştırılamadı
- `flutter test`: Başarılı / Başarısız / Çalıştırılamadı
- `flutter run`: Başarılı / Başarısız / Çalıştırılamadı

**Kullanıcı İçin Notlar:**
- Varsa gerekli manuel kontroller veya kullanıcı onayı bekleyen kararlar.
```

---

## 6. Sıkça Sorulan Sorular ve Kritik Senaryolar (SSS)

### S1: Hukuki yol haritası (`legal_roadmap`) geliştirirken nelere dikkat etmeliyim?
**Cevap:** Her hukuki ekran ve rehber kartında, sunulan içeriğin bir bilgilendirme olduğu ve profesyonel hukuki danışmanlık yerine geçmediği feragati kullanıcıya açıkça gösterilmelidir.

### S2: Kişilik testinde (`personality_test`) otomatik eleme yapılabilir mi?
**Cevap:** Kesinlikle hayır. Kişilik testi isteğe bağlıdır, profil doluluğunu artırır ve ekip uyumuna tavsiye niteliğinde destek sunar. Asla başvuruları otomatik reddetmek veya kesin kategorilere ayırmak amacıyla kullanılamaz.

### S3: Çoklu rol desteği (`auth`, `profile`) nasıl kurgulanmalıdır?
**Cevap:** Bir kullanıcı aynı anda hem fikri olan bir girişimci ("Fikrim Var"), hem başka bir projeye katılmak isteyen bir ekip üyesi adayı ("Fikrim Yok"), hem de uzmanlık sunan bir danışman ("Mentor Olmak İstiyorum") olabilir. Veri modeli ve profil ekranı bu esnekliği desteklemelidir.

### S4: Harici bir paket (ör. `shared_preferences`, `intl`, `http`) eklemek gerekirse ne yapılmalıdır?
**Cevap:** Paket adı, sürümü, eklenme amacı ve alternatif yerel çözümlerin neden yetersiz kaldığı kullanıcıya açıklanarak **önce kullanıcı onayı alınmalıdır.** Onay alınmadan `pubspec.yaml`'a harici paket eklenemez.
