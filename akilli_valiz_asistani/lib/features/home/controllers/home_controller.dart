import 'package:flutter/foundation.dart';
import '../../../core/services/storage_service.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../models/current_trip_summary_model.dart';

class HomeController {
  final TripRepository _tripRepository;
  final StorageService _storageService;

  final ValueNotifier<TripPlannerModel?> activeTrip =
      ValueNotifier<TripPlannerModel?>(null);
  final ValueNotifier<List<TripPlannerModel>> allTrips =
      ValueNotifier<List<TripPlannerModel>>([]);
  final ValueNotifier<CurrentTripSummaryModel?> summary =
      ValueNotifier<CurrentTripSummaryModel?>(null);
  final ValueNotifier<int> shoppingItemsCount = ValueNotifier<int>(0);

  HomeController({
    required TripRepository tripRepository,
    required StorageService storageService,
  })  : _tripRepository = tripRepository,
        _storageService = storageService {
    refresh();
  }

  void refresh() {
    final trips = _tripRepository.getAllTrips();
    allTrips.value = trips;

    final current = _tripRepository.getActiveTrip();
    activeTrip.value = current;

    if (current != null) {
      summary.value = CurrentTripSummaryModel(
        tripId: current.id,
        destination: current.destination,
        startDate: current.startDate,
        endDate: current.endDate,
        tripType: current.tripType,
        totalItems: current.totalItemsCount,
        packedItems: current.packedCount,
        totalWeightKg: current.totalWeightKg,
        totalVolumeLiters: current.totalVolumeLiters,
      );
    } else {
      summary.value = null;
    }

    final shopping = _storageService.getShoppingItems();
    shoppingItemsCount.value = shopping.where((i) => !i.isPurchased).length;
  }

  Future<void> deleteActiveTrip() async {
    final current = activeTrip.value;
    if (current != null) {
      await _tripRepository.deleteTrip(current.id);
      refresh();
    }
  }

  void dispose() {
    activeTrip.dispose();
    allTrips.dispose();
    summary.dispose();
    shoppingItemsCount.dispose();
  }
}
