import 'package:flutter/material.dart';
import '../../vehicles/models/vehicle_model.dart';
import '../../vehicles/controller/vehicle_controller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/extensions/context_extensions.dart';

final FavoritesController favoritesController = FavoritesController();

class FavoritesController extends ChangeNotifier {
  FavoritesController() {
    _loadFavorites();
  }

  final Set<String> _favoriteIds = {'veh_01', 'veh_03'};

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  List<VehicleModel> get favoriteVehicles {
    return _favoriteIds
        .map((id) => vehicleController.getVehicleById(id))
        .whereType<VehicleModel>()
        .toList();
  }

  bool isFavorite(String vehicleId) => _favoriteIds.contains(vehicleId);

  void _loadFavorites() {
    final list = StorageService.getFavorites();
    if (list.isNotEmpty) {
      _favoriteIds.clear();
      _favoriteIds.addAll(list);
    }
  }

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

  Future<void> removeFavorite(String id, BuildContext context) async {
    final vehicle = vehicleController.getVehicleById(id);
    if (vehicle != null) {
      await toggleFavorite(vehicle, context);
    }
  }
}
