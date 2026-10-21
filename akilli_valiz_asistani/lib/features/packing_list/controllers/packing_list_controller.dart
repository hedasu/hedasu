import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/luggage_calculator.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../models/packing_item_model.dart';

class PackingListController {
  final TripRepository _tripRepository;
  final String tripId;

  final ValueNotifier<TripPlannerModel?> trip = ValueNotifier<TripPlannerModel?>(null);
  final ValueNotifier<List<PackingItemModel>> items = ValueNotifier<List<PackingItemModel>>([]);
  final ValueNotifier<List<String>> availableCategories = ValueNotifier<List<String>>([]);

  PackingListController({
    required TripRepository tripRepository,
    required this.tripId,
  }) : _tripRepository = tripRepository {
    loadData();
  }

  void loadData() {
    final trips = _tripRepository.getAllTrips();
    final match = trips.where((t) => t.id == tripId).toList();
    if (match.isNotEmpty) {
      final curTrip = match.first;
      trip.value = curTrip;
      items.value = curTrip.items;

      // Calculate available categories (standard + dynamic for this trip type)
      final cats = List<String>.from(AppConstants.standardCategories);
      if (curTrip.tripType == AppConstants.tripTypeBusiness) {
        cats.add(AppConstants.categoryBusiness);
      } else if (curTrip.tripType == AppConstants.tripTypeCamping) {
        cats.add(AppConstants.categoryCamping);
      } else if (curTrip.tripType == AppConstants.tripTypeVacation) {
        if (curTrip.tripSubType == 'Kış Tatili') {
          cats.add(AppConstants.categoryWinterSports);
        } else {
          cats.add(AppConstants.categoryBeach);
        }
      }

      availableCategories.value = cats;
    }
  }

  Future<void> addItem({
    required String name,
    required String category,
    int quantity = 1,
  }) async {
    final curTrip = trip.value;
    if (curTrip == null || name.trim().isEmpty) return;

    final metrics = LuggageCalculator.estimateItemMetrics(name);
    const uuid = Uuid();
    final newItem = PackingItemModel(
      id: uuid.v4(),
      name: name.trim(),
      category: category,
      quantity: quantity,
      unitWeightKg: metrics.weight,
      unitVolumeLiters: metrics.volume,
      isPacked: false,
      isCustom: true,
    );

    final updated = List<PackingItemModel>.from(items.value)..add(newItem);
    items.value = updated;
    await _tripRepository.updateTripItems(tripId, updated);
  }

  Future<void> updateItemQuantity(String itemId, int delta) async {
    final updated = items.value.map((item) {
      if (item.id == itemId) {
        final newQty = (item.quantity + delta).clamp(1, 99);
        return item.copyWith(quantity: newQty);
      }
      return item;
    }).toList();

    items.value = updated;
    await _tripRepository.updateTripItems(tripId, updated);
  }

  Future<void> deleteItem(String itemId) async {
    final updated = items.value.where((it) => it.id != itemId).toList();
    items.value = updated;
    await _tripRepository.updateTripItems(tripId, updated);
  }

  List<PackingItemModel> getItemsForCategory(String category) {
    return items.value.where((it) => it.category == category).toList();
  }

  void dispose() {
    trip.dispose();
    items.dispose();
    availableCategories.dispose();
  }
}
