import 'package:flutter/material.dart';
import '../../vehicles/models/vehicle_model.dart';
import '../../../core/extensions/context_extensions.dart';

/// Global araç karşılaştırma kontrolcüsü (Singleton)
final ComparisonController comparisonController = ComparisonController();

/// Araç Karşılaştırma Kontrolcüsü
///
/// Kullanıcının filodan seçtiği araçları (en fazla 3 adet) yan yana
/// fiyat, yakıt, vites, beygir, ehliyet gereksinimi gibi kriterlerde
/// kıyaslamasını sağlayan durum yönetim sınıfıdır.
class ComparisonController extends ChangeNotifier {
  /// Karşılaştırma için seçilmiş araçlar listesi (maksimum 3 adet)
  final List<VehicleModel> _selectedVehicles = [];

  /// Dışa açık değiştirilemez seçili araç listesi
  List<VehicleModel> get selectedVehicles => List.unmodifiable(_selectedVehicles);

  /// Karşılaştırma listesinde en az 1 araç olup olmadığı
  bool get hasVehicles => _selectedVehicles.isNotEmpty;

  /// Kıyaslama tablosu açmak için en az 2 araç gerekip gerekmediğini denetler
  bool get canCompare => _selectedVehicles.length >= 2;

  /// Belirtilen ID'ye sahip aracın karşılaştırma listesinde olup olmadığını kontrol eder
  bool isSelected(String id) => _selectedVehicles.any((v) => v.id == id);

  /// Aracı karşılaştırma listesine ekler veya çıkarır (Maksimum 3 araç sınırı uygular)
  void toggleVehicle(VehicleModel vehicle, BuildContext context) {
    if (isSelected(vehicle.id)) {
      _selectedVehicles.removeWhere((v) => v.id == vehicle.id);
      notifyListeners();
      context.showAppSnackBar('${vehicle.fullName} karşılaştırmadan çıkarıldı.');
    } else {
      if (_selectedVehicles.length >= 3) {
        context.showAppSnackBar('En fazla 3 araç aynı anda karşılaştırılabilir.', isError: true);
        return;
      }
      _selectedVehicles.add(vehicle);
      notifyListeners();
      context.showAppSnackBar('${vehicle.fullName} karşılaştırma listesine eklendi.');
    }
  }

  /// Belirli bir aracı karşılaştırma listesinden siler
  void removeVehicle(String id) {
    _selectedVehicles.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  /// Karşılaştırma listesini tamamen boşaltır
  void clear() {
    _selectedVehicles.clear();
    notifyListeners();
  }
}
