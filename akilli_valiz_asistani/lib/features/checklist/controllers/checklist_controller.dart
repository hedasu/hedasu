import 'package:flutter/material.dart';
import '../../packing_list/models/packing_item_model.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';

class ChecklistController {
  final TripRepository _tripRepository;
  final String tripId;

  final ValueNotifier<TripPlannerModel?> trip = ValueNotifier<TripPlannerModel?>(null);
  final ValueNotifier<List<PackingItemModel>> toPackItems = ValueNotifier<List<PackingItemModel>>([]);
  final ValueNotifier<List<PackingItemModel>> packedItems = ValueNotifier<List<PackingItemModel>>([]);

  ChecklistController({
    required TripRepository tripRepository,
    required this.tripId,
  }) : _tripRepository = tripRepository {
    loadData();
  }

  void loadData() {
    final trips = _tripRepository.getAllTrips();
    final match = trips.where((t) => t.id == tripId).toList();
    if (match.isEmpty) return;

    final curTrip = match.first;
    trip.value = curTrip;

    toPackItems.value = curTrip.items.where((it) => !it.isPacked).toList();
    packedItems.value = curTrip.items.where((it) => it.isPacked).toList();
  }

  Future<void> toggleItem(String itemId) async {
    final curTrip = trip.value;
    if (curTrip == null) return;

    final updatedAll = curTrip.items.map((it) {
      if (it.id == itemId) {
        return it.copyWith(isPacked: !it.isPacked);
      }
      return it;
    }).toList();

    final updatedTrip = curTrip.copyWith(items: updatedAll);
    await _tripRepository.saveTrip(updatedTrip);

    trip.value = updatedTrip;
    toPackItems.value = updatedAll.where((it) => !it.isPacked).toList();
    packedItems.value = updatedAll.where((it) => it.isPacked).toList();
  }

  Future<void> finishChecklist() async {
    final curTrip = trip.value;
    if (curTrip != null) {
      await _tripRepository.setActiveTrip(curTrip.id);
    }
  }

  void dispose() {
    trip.dispose();
    toPackItems.dispose();
    packedItems.dispose();
  }
}
