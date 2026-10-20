import 'package:flutter/material.dart';
import '../../vehicles/models/vehicle_model.dart';
import '../../vehicles/controller/vehicle_controller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/extensions/context_extensions.dart';

/// Global favoriler kontrolcüsü (Singleton)
final FavoritesController favoritesController = FavoritesController();

/// Favori Araçlar Yönetim Kontrolcüsü
///
/// Kullanıcının beğendiği ve kaydettiği araçları yerel depolama (SharedPreferences)
/// ile senkronize tutar. Favoriye ekleme, çıkarma ve "Geri Al" (Undo) mekanizmasını sağlar.
class FavoritesController extends ChangeNotifier {
  FavoritesController() {
    _loadFavorites();
  }

  /// Favorilenen araç ID'lerinin kümesi (Set yapısı ile tekillik sağlanır)
  final Set<String> _favoriteIds = {'veh_01', 'veh_03'};

  /// Değiştirilemez ID kümesi
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  /// Favori ID'lerine karşılık gelen tam araç nesnelerinin listesi
  List<VehicleModel> get favoriteVehicles {
    return _favoriteIds
        .map((id) => vehicleController.getVehicleById(id))
        .whereType<VehicleModel>()
        .toList();
  }

  /// Belirtilen aracın favorilerde olup olmadığını sorgular
  bool isFavorite(String vehicleId) => _favoriteIds.contains(vehicleId);

  /// Cihaz hafızasından kayıtlı favorileri okur
  void _loadFavorites() {
    final list = StorageService.getFavorites();
    if (list.isNotEmpty) {
      _favoriteIds.clear();
      _favoriteIds.addAll(list);
    }
  }

  /// Aracı favorilere ekler veya favorilerden çıkarır. Çıkarıldığında 'Geri Al' SnackBar'ı gösterir.
  Future<void> toggleFavorite(VehicleModel vehicle, BuildContext context) async {
    final id = vehicle.id;
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
      await StorageService.saveFavorites(_favoriteIds.toList());
      notifyListeners();

      if (context.mounted) {
        context.showAppSnackBar(
          '${vehicle.fullName} favorilerden çıkarıldı.',
          actionLabel: 'Geri Al',
          onAction: () {
            _favoriteIds.add(id);
            StorageService.saveFavorites(_favoriteIds.toList());
            notifyListeners();
          },
        );
      }
    } else {
      _favoriteIds.add(id);
      await StorageService.saveFavorites(_favoriteIds.toList());
      notifyListeners();

      if (context.mounted) {
        context.showAppSnackBar('${vehicle.fullName} favorilere eklendi.');
      }
    }
  }

  /// ID ile favoriden kaldırma yardımcısı
  Future<void> removeFavorite(String id, BuildContext context) async {
    final vehicle = vehicleController.getVehicleById(id);
    if (vehicle != null) {
      await toggleFavorite(vehicle, context);
    }
  }
}
