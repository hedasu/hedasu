import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../../auth/controller/auth_controller.dart';

/// Global araç kontrolcüsü (Singleton)
final VehicleController vehicleController = VehicleController();

/// Araç Sıralama Seçenekleri
enum VehicleSortOption {
  lowestPrice('En Düşük Fiyat'),
  highestPrice('En Yüksek Fiyat'),
  highestRating('En Yüksek Puan'),
  newestYear('En Yeni Model');

  const VehicleSortOption(this.displayName);
  final String displayName;
}

/// Araç Listesi ve Filtreleme Kontrolcüsü
///
/// Arama metni, kategori seçimi, kiralama türü (saatlik/günlük),
/// kullanım amacı, ehliyet uygunluğu, yakıt türü, vites ve sıralama
/// kriterlerine göre filoyu dinamik olarak filtreler ve durumu yönetir.
class VehicleController extends ChangeNotifier {
  VehicleController() {
    _vehicles = _generateInitialVehicles();
  }

  /// Uygulamadaki tüm araçların ana listesi
  late final List<VehicleModel> _vehicles;

  /// Arama sorgusu metni
  String _searchQuery = '';

  /// Seçili araç kategorisi (varsayılan: Tümü)
  VehicleCategory _selectedCategory = VehicleCategory.all;

  /// Kiralama türü ('daily' = Günlük, 'hourly' = Saatlik)
  String _rentalType = 'daily';

  /// Seçili kullanım amacı filtresi
  RentalPurpose? _selectedPurpose;

  /// Sadece kullanıcının ehliyetine uygun araçları gösterme filtresi
  bool _onlyEligibleForLicense = false;

  /// Seçili sıralama kriteri
  VehicleSortOption _sortOption = VehicleSortOption.lowestPrice;

  /// Seçili yakıt türü filtresi
  String? _selectedFuelType;

  /// Seçili vites türü filtresi
  String? _selectedTransmission;

  // ==========================================
  // Dışa Açık Getter Özellikleri
  // ==========================================
  List<VehicleModel> get allVehicles => List.unmodifiable(_vehicles);
  String get searchQuery => _searchQuery;
  VehicleCategory get selectedCategory => _selectedCategory;
  String get rentalType => _rentalType;
  bool get isHourly => _rentalType == 'hourly';
  RentalPurpose? get selectedPurpose => _selectedPurpose;
  bool get onlyEligibleForLicense => _onlyEligibleForLicense;
  VehicleSortOption get sortOption => _sortOption;
  String? get selectedFuelType => _selectedFuelType;
  String? get selectedTransmission => _selectedTransmission;

  /// Seçili tüm filtreler ve sıralama kuralları uygulanmış araç listesi
  List<VehicleModel> get filteredVehicles {
    final userLicense = authController.currentUser?.driverLicenseClass ?? 'B';

    return _vehicles.where((v) {
      // 1. Arama Metni Filtresi (Marka, model veya kategori adında arama)
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = v.fullName.toLowerCase().contains(q);
        final matchesCategory = v.category.displayName.toLowerCase().contains(q);
        if (!matchesName && !matchesCategory) return false;
      }

      // 2. Kategori Segmenti Filtresi
      if (_selectedCategory != VehicleCategory.all && v.category != _selectedCategory) {
        return false;
      }

      // 3. Kiralama Türü Desteği (Saatlik / Günlük)
      if (isHourly && !v.supportsHourly) return false;
      if (!isHourly && !v.supportsDaily) return false;

      // 4. Kullanım Amacı Filtresi (Şehir içi, aile, uzun yol, yük vb.)
      if (_selectedPurpose != null && !v.suitablePurposes.contains(_selectedPurpose)) {
        return false;
      }

      // 5. Ehliyet Sınıfı Uygunluğu Filtresi
      if (_onlyEligibleForLicense && !v.isEligibleForLicense(userLicense)) {
        return false;
      }

      // 6. Yakıt ve Vites Tipi Filtreleri
      if (_selectedFuelType != null && v.fuelType != _selectedFuelType) {
        return false;
      }
      if (_selectedTransmission != null && v.transmission != _selectedTransmission) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        // Sıralama algoritması
        switch (_sortOption) {
          case VehicleSortOption.lowestPrice:
            final priceA = isHourly ? a.hourlyPrice : a.dailyPrice;
            final priceB = isHourly ? b.hourlyPrice : b.dailyPrice;
            return priceA.compareTo(priceB);
          case VehicleSortOption.highestPrice:
            final priceA = isHourly ? a.hourlyPrice : a.dailyPrice;
            final priceB = isHourly ? b.hourlyPrice : b.dailyPrice;
            return priceB.compareTo(priceA);
          case VehicleSortOption.highestRating:
            return b.rating.compareTo(a.rating);
          case VehicleSortOption.newestYear:
            return b.year.compareTo(a.year);
        }
      });
  }

  /// Arama kutusu metnini günceller ve arayüzü tetikler
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Araç kategorisini günceller
  void setCategory(VehicleCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Kiralama tipini (saatlik / günlük) ayarlar
  void setRentalType(String type) {
    _rentalType = type;
    notifyListeners();
  }

  /// Kullanım amacını seçer veya seçimi kaldırır
  void setPurpose(RentalPurpose? purpose) {
    if (_selectedPurpose == purpose) {
      _selectedPurpose = null;
    } else {
      _selectedPurpose = purpose;
    }
    notifyListeners();
  }

  /// Sadece ehliyete uygun araçları listeleme filtresini açıp kapatır
  void toggleLicenseEligibility() {
    _onlyEligibleForLicense = !_onlyEligibleForLicense;
    notifyListeners();
  }

  /// Sıralama kriterini değiştirir
  void setSortOption(VehicleSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  /// Detaylı filtreleri (yakıt ve vites) uygular
  void setFilters({String? fuel, String? transmission}) {
    _selectedFuelType = fuel;
    _selectedTransmission = transmission;
    notifyListeners();
  }

  /// Tüm filtreleri sıfırlayarak varsayılan görünüme döner
  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = VehicleCategory.all;
    _selectedPurpose = null;
    _onlyEligibleForLicense = false;
    _selectedFuelType = null;
    _selectedTransmission = null;
    _sortOption = VehicleSortOption.lowestPrice;
    notifyListeners();
  }

  /// ID'ye göre tek bir araç nesnesi bulur
  VehicleModel? getVehicleById(String id) {
    try {
      return _vehicles.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Başlangıçta filoda yer alan zengin demo araç verilerini üretir
  static List<VehicleModel> _generateInitialVehicles() {
    return [
      const VehicleModel(
        id: 'veh_01',
        brand: 'Porsche',
        model: 'Taycan 4S Electric',
        year: 2024,
        category: VehicleCategory.sedan,
        hourlyPrice: 480,
        dailyPrice: 3950,
        rating: 4.9,
        reviewCount: 38,
        imageUrl: 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=1200&q=80',
        galleryImages: [
          'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=1200&q=80',
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80',
        ],
        fuelType: 'Elektrik',
        transmission: 'Otomatik',
        passengerCapacity: 4,
        luggageCapacity: 3,
        requiredLicenseClass: 'B',
        features: [
          '530 HP Elektrikli Güç',
          'Hızlı Şarj (22 dk %80)',
          'Panoramik Cam Tavan',
          'Bose 3D Surround Ses',
          '360 Derece Çevre Görüş',
          'Adaptif Havalı Süspansiyon'
        ],
        suitablePurposes: [RentalPurpose.city, RentalPurpose.longTrip],
        supportsHourly: true,
        supportsDaily: true,
      ),
      const VehicleModel(
        id: 'veh_02',
        brand: 'Mercedes-Benz',
        model: 'S 500 4MATIC Luxury',
        year: 2024,
        category: VehicleCategory.sedan,
        hourlyPrice: 550,
        dailyPrice: 4600,
        rating: 5.0,
        reviewCount: 42,
        imageUrl: 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?auto=format&fit=crop&w=1200&q=80',
        galleryImages: [
          'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?auto=format&fit=crop&w=1200&q=80',
          'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=1200&q=80',
        ],
        fuelType: 'Hibrit',
        transmission: 'Otomatik',
        passengerCapacity: 5,
        luggageCapacity: 4,
        requiredLicenseClass: 'B',
        features: [
          'Executive Masaj Koltukları',
          'Burmester 4D High-End Ses',
          'Otonom Sürüş Asistanı',
          'Arka Multimedya Ekranları',
          'Akustik Konfor Paketi'
        ],
        suitablePurposes: [RentalPurpose.city, RentalPurpose.longTrip, RentalPurpose.family],
        supportsHourly: true,
        supportsDaily: true,
      ),
      const VehicleModel(
        id: 'veh_03',
        brand: 'Range Rover',
        model: 'Autobiography P530',
        year: 2024,
        category: VehicleCategory.suv,
        hourlyPrice: 620,
        dailyPrice: 5200,
        rating: 4.9,
        reviewCount: 29,
        imageUrl: 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?auto=format&fit=crop&w=1200&q=80',
        galleryImages: [
          'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?auto=format&fit=crop&w=1200&q=80',
        ],
        fuelType: 'Benzin',
        transmission: 'Otomatik',
        passengerCapacity: 5,
        luggageCapacity: 5,
        requiredLicenseClass: 'B',
        features: [
          '4.4L V8 Twin-Turbo (530 HP)',
          'Tüm Arazi Sürüş Modları',
          'Meridian Signature Ses',
          'Arka Aks Yönlendirme',
          'Isıtmalı/Soğutmalı Koltuklar'
        ],
        suitablePurposes: [RentalPurpose.family, RentalPurpose.longTrip],
        supportsHourly: true,
        supportsDaily: true,
      ),
      const VehicleModel(
        id: 'veh_04',
        brand: 'BMW',
        model: 'M5 Competition',
        year: 2023,
        category: VehicleCategory.sedan,
        hourlyPrice: 510,
        dailyPrice: 4200,
        rating: 4.8,
        reviewCount: 31,
        imageUrl: 'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=1200&q=80',
        galleryImages: [
          'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=1200&q=80',
        ],
        fuelType: 'Benzin',
        transmission: 'Otomatik',
        passengerCapacity: 5,
        luggageCapacity: 3,
        requiredLicenseClass: 'B',
        features: [
          '625 HP M TwinPower Turbo',
          'M xDrive Akıllı 4 Çeker',
          'Karbon Seramik Frenler',
          'Harman Kardon Surround',
          'Head-Up Display'
        ],
        suitablePurposes: [RentalPurpose.city, RentalPurpose.longTrip],
        supportsHourly: true,
        supportsDaily: true,
      ),
      const VehicleModel(
        id: 'veh_05',
        brand: 'Ducati',
        model: 'Panigale V4 S',
        year: 2024,
        category: VehicleCategory.motorcycle,
        hourlyPrice: 320,
        dailyPrice: 2400,
        rating: 4.9,
        reviewCount: 22,
        imageUrl: 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?auto=format&fit=crop&w=1200&q=80',
        galleryImages: [
          'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?auto=format&fit=crop&w=1200&q=80',
        ],
        fuelType: 'Benzin',
        transmission: 'Manuel',
        passengerCapacity: 1,
        luggageCapacity: 0,
        requiredLicenseClass: 'A',
        features: [
          '215.5 HP Desmosedici Stradale',
          'Öhlins Smart EC 2.0 Süspansiyon',
          'Ducati Quick Shift (DQS) Up/Down',
          'Cornering ABS EVO',
          'Aerodinamik Kanatçıklar'
        ],
        suitablePurposes: [RentalPurpose.city],
        supportsHourly: true,
        supportsDaily: true,
      ),
      const VehicleModel(
        id: 'veh_06',
        brand: 'BMW',
        model: 'R 1250 GS Adventure',
        year: 2024,
        category: VehicleCategory.motorcycle,
        hourlyPrice: 290,
        dailyPrice: 2100,
        rating: 4.8,
        reviewCount: 19,
        imageUrl: 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=1200&q=80',
        galleryImages: [
          'https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=1200&q=80',
        ],
        fuelType: 'Benzin',
        transmission: 'Manuel',
        passengerCapacity: 2,
        luggageCapacity: 2,
        requiredLicenseClass: 'A',
        features: [
          'ShiftCam Boxer Motor (136 HP)',
          'Dinamik ESA Elektronik Süspansiyon',
          '30 Litre Alüminyum Yakıt Tankı',
          'Isıtmalı Elcik & Koltuk',
          'LED Adaptif Farlar'
        ],
        suitablePurposes: [RentalPurpose.longTrip, RentalPurpose.city],
        supportsHourly: true,
        supportsDaily: true,
      ),
      const VehicleModel(
        id: 'veh_07',
        brand: 'Mercedes-Benz',
        model: 'V-Class Maybach Edition',
        year: 2024,
        category: VehicleCategory.group,
        hourlyPrice: 580,
        dailyPrice: 4900,
        rating: 4.9,
        reviewCount: 35,
        imageUrl: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=1200&q=80',
        galleryImages: [
          'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=1200&q=80',
        ],
        fuelType: 'Dizel',
        transmission: 'Otomatik',
        passengerCapacity: 7,
        luggageCapacity: 6,
        requiredLicenseClass: 'B',
        features: [
          '7 Kişilik VIP Konfigürasyon',
          'Elektrikli Yatarlı Kaptan Koltukları',
          'Buzdolabı & Şampanya Bölmesi',
          '32 inç Smart TV Bölmesi',
          'Yıldız Tavan Aydınlatması'
        ],
        suitablePurposes: [RentalPurpose.group, RentalPurpose.family, RentalPurpose.longTrip],
        supportsHourly: true,
        supportsDaily: true,
      ),
      const VehicleModel(
        id: 'veh_08',
        brand: 'Ford',
        model: 'Transit Custom EcoBlue',
        year: 2023,
        category: VehicleCategory.commercial,
        hourlyPrice: 220,
        dailyPrice: 1750,
        rating: 4.7,
        reviewCount: 18,
        imageUrl: 'https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98?auto=format&fit=crop&w=1200&q=80',
        galleryImages: [
          'https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98?auto=format&fit=crop&w=1200&q=80',
        ],
        fuelType: 'Dizel',
        transmission: 'Manuel',
        passengerCapacity: 3,
        luggageCapacity: 12,
        requiredLicenseClass: 'B',
        features: [
          '6.8 m³ Geniş Kargo Hacmi',
          '1.300 kg Yükleme Kapasitesi',
          'Çift Kanatlı Arka Kapılar',
          'Geri Görüş Kamerası',
          'SYNC 4 Dokunmatik Multimedya'
        ],
        suitablePurposes: [RentalPurpose.cargo],
        supportsHourly: true,
        supportsDaily: true,
      ),
    ];
  }
}
