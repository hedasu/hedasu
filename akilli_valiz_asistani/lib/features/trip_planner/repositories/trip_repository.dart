import '../../../core/services/storage_service.dart';
import '../models/trip_planner_model.dart';
import '../../packing_list/models/packing_item_model.dart';

class TripRepository {
  final StorageService _storageService;

  TripRepository({required StorageService storageService})
      : _storageService = storageService;

  List<TripPlannerModel> getAllTrips() {
    return _storageService.getTrips();
  }

  TripPlannerModel? getActiveTrip() {
    return _storageService.getActiveTrip();
  }

  Future<void> saveTrip(TripPlannerModel trip) async {
    await _storageService.saveTrip(trip);
  }

  Future<void> deleteTrip(String tripId) async {
    await _storageService.deleteTrip(tripId);
  }

  Future<void> setActiveTrip(String tripId) async {
    await _storageService.setActiveTripId(tripId);
  }

  Future<void> updateTripItems(String tripId, List<PackingItemModel> items) async {
    final trips = getAllTrips();
    final idx = trips.indexWhere((t) => t.id == tripId);
    if (idx >= 0) {
      final updated = trips[idx].copyWith(items: items);
      await saveTrip(updated);
    }
  }

  Future<void> toggleItemPacked(String tripId, String itemId) async {
    final trips = getAllTrips();
    final idx = trips.indexWhere((t) => t.id == tripId);
    if (idx >= 0) {
      final trip = trips[idx];
      final newItems = trip.items.map((it) {
        if (it.id == itemId) {
          return it.copyWith(isPacked: !it.isPacked);
        }
        return it;
      }).toList();
      await saveTrip(trip.copyWith(items: newItems));
    }
  }
}
