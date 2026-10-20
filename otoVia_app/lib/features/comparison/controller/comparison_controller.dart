import 'package:flutter/material.dart';
import '../../vehicles/models/vehicle_model.dart';
import '../../../core/extensions/context_extensions.dart';

final ComparisonController comparisonController = ComparisonController();

class ComparisonController extends ChangeNotifier {
  final List<VehicleModel> _selectedVehicles = [];

  List<VehicleModel> get selectedVehicles => List.unmodifiable(_selectedVehicles);
  bool get hasVehicles => _selectedVehicles.isNotEmpty;
  bool get canCompare => _selectedVehicles.length >= 2;

  bool isSelected(String id) => _selectedVehicles.any((v) => v.id == id);

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

  void removeVehicle(String id) {
    _selectedVehicles.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  void clear() {
    _selectedVehicles.clear();
    notifyListeners();
  }
}
