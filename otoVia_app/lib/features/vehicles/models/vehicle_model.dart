enum VehicleCategory {
  all('Tümü'),
  motorcycle('Motosiklet'),
  sedan('Binek'),
  suv('SUV'),
  group('Geniş Grup'),
  commercial('Nakliye & Ticari');

  const VehicleCategory(this.displayName);
  final String displayName;
}

enum RentalPurpose {
  city('Şehir İçi Ulaşım'),
  family('Aile Seyahati'),
  longTrip('Uzun Yol'),
  group('Grup Yolculuğu'),
  cargo('Eşya Taşıma');

  const RentalPurpose(this.displayName);
  final String displayName;
}

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

  final String id;
  final String brand;
  final String model;
  final int year;
  final VehicleCategory category;
  final double hourlyPrice;
  final double dailyPrice;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> galleryImages;
  final String fuelType; // Benzin, Dizel, Elektrik, Hibrit
  final String transmission; // Otomatik, Manuel
  final int passengerCapacity;
  final int luggageCapacity;
  final String requiredLicenseClass; // A, A2, B, C, D1
  final List<String> features;
  final List<RentalPurpose> suitablePurposes;
  final bool supportsHourly;
  final bool supportsDaily;
  final bool isAvailable;
  final String? unavailableReason;

  String get fullName => '$brand $model';

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
