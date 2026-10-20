/// Araç Kategorileri Sabiti
///
/// Uygulamada filtrelenebilir tüm araç segmentlerini tanımlar.
enum VehicleCategory {
  all('Tümü'),
  motorcycle('Motosiklet'),
  sedan('Binek'),
  suv('SUV'),
  group('Geniş Grup'),
  commercial('Nakliye & Ticari');

  const VehicleCategory(this.displayName);
  /// Kullanıcı arayüzünde gösterilecek Türkçe etiket adı
  final String displayName;
}

/// Kiralama Kullanım Amacı Sabiti
///
/// Akıllı filtreleme ve kullanım amacına göre araç önerilerinde kullanılır.
enum RentalPurpose {
  city('Şehir İçi Ulaşım'),
  family('Aile Seyahati'),
  longTrip('Uzun Yol'),
  group('Grup Yolculuğu'),
  cargo('Eşya Taşıma');

  const RentalPurpose(this.displayName);
  /// Arayüzde görüntülenecek Türkçe kullanım amacı başlığı
  final String displayName;
}

/// otoVia Araç Veri Modeli (VehicleModel)
///
/// Bir kiralık aracın tüm teknik özelliklerini, fiyatlandırmasını,
/// fotoğraflarını, ehliyet gereksinimini ve müsaitlik durumunu barındırır.
class VehicleModel {
  const VehicleModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.category,
    required this.hourlyPrice,
    required this.dailyPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.galleryImages,
    required this.fuelType,
    required this.transmission,
    required this.passengerCapacity,
    required this.luggageCapacity,
    required this.requiredLicenseClass,
    required this.features,
    required this.suitablePurposes,
    this.supportsHourly = true,
    this.supportsDaily = true,
    this.isAvailable = true,
    this.unavailableReason,
  });

  /// Benzersiz araç ID'si
  final String id;

  /// Araç markası (ör. Porsche, Mercedes-Benz, BMW, Tesla)
  final String brand;

  /// Model adı (ör. Taycan 4S, S 500 4MATIC)
  final String model;

  /// Model yılı
  final int year;

  /// Aracın dahil olduğu kategori segmenti
  final VehicleCategory category;

  /// Saatlik kiralama taban ücreti (TL)
  final double hourlyPrice;

  /// Günlük kiralama taban ücreti (TL)
  final double dailyPrice;

  /// Kullanıcı puan ortalaması (5 üzerinden)
  final double rating;

  /// Yapılan toplam değerlendirme sayısı
  final int reviewCount;

  /// Ana vitrin görselinin URL bağlantısı
  final String imageUrl;

  /// Detay sayfasında sergilenecek galeri görselleri listesi
  final List<String> galleryImages;

  /// Yakıt türü (Benzin, Dizel, Elektrik, Hibrit)
  final String fuelType;

  /// Vites tipi (Otomatik, Manuel)
  final String transmission;

  /// Yolcu taşıma kapasitesi (kişi sayısı)
  final int passengerCapacity;

  /// Bagaj hacmi (valiz kapasitesi)
  final int luggageCapacity;

  /// Aracı kiralamak için gereken minimum ehliyet sınıfı (A, A2, B, C, D1)
  final String requiredLicenseClass;

  /// Öne çıkan donanım ve konfor özellikleri (ör. Otopilot, Masajlı Koltuk, Panoramik Tavan)
  final List<String> features;

  /// Aracın tavsiye edildiği kullanım amaçları
  final List<RentalPurpose> suitablePurposes;

  /// Aracın saatlik kiralamayı destekleyip desteklemediği
  final bool supportsHourly;

  /// Aracın günlük kiralamayı destekleyip desteklemediği
  final bool supportsDaily;

  /// Aracın şu anda kiralamaya müsait olup olmadığı
  final bool isAvailable;

  /// Araç müsait değilse kullanıcıya gösterilecek açıklama (ör. 'Serviste', 'Kirada')
  final String? unavailableReason;

  /// Marka ve modeli birleştiren tam araç ismi
  String get fullName => '$brand $model';

  /// Kullanıcının sahip olduğu ehliyetin bu araç için yeterli olup olmadığını kontrol eder
  bool isEligibleForLicense(String userLicense) {
    if (requiredLicenseClass == 'A' || requiredLicenseClass == 'A2') {
      return userLicense.contains('A');
    }
    if (requiredLicenseClass == 'B') {
      return userLicense == 'B' || userLicense == 'C' || userLicense == 'D1';
    }
    if (requiredLicenseClass == 'D1') {
      return userLicense == 'D1';
    }
    if (requiredLicenseClass == 'C') {
      return userLicense == 'C';
    }
    return false;
  }
}
