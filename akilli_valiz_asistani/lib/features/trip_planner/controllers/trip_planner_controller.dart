import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/weather_service.dart';
import '../models/trip_planner_model.dart';
import '../repositories/trip_repository.dart';

class TripPlannerController {
  final TripRepository _tripRepository;
  final WeatherService _weatherService;

  final ValueNotifier<String> destination = ValueNotifier<String>('İstanbul, Türkiye');
  final ValueNotifier<double> latitude = ValueNotifier<double>(41.0082);
  final ValueNotifier<double> longitude = ValueNotifier<double>(28.9784);

  final ValueNotifier<DateTime?> startDate = ValueNotifier<DateTime?>(null);
  final ValueNotifier<DateTime?> endDate = ValueNotifier<DateTime?>(null);

  final ValueNotifier<bool> askForTimes = ValueNotifier<bool>(false);
  final ValueNotifier<bool> provideSpecificTimes = ValueNotifier<bool>(false);
  final ValueNotifier<TimeOfDay?> arrivalTime = ValueNotifier<TimeOfDay?>(const TimeOfDay(hour: 10, minute: 0));
  final ValueNotifier<TimeOfDay?> departureTime = ValueNotifier<TimeOfDay?>(const TimeOfDay(hour: 18, minute: 0));

  final ValueNotifier<List<Map<String, dynamic>>> searchResults = ValueNotifier<List<Map<String, dynamic>>>([]);
  final ValueNotifier<bool> isSearching = ValueNotifier<bool>(false);
  final ValueNotifier<String?> validationError = ValueNotifier<String?>(null);

  String? editingTripId;

  TripPlannerController({
    required TripRepository tripRepository,
    required WeatherService weatherService,
    String? editTripId,
  })  : _tripRepository = tripRepository,
        _weatherService = weatherService,
        editingTripId = editTripId {
    if (editingTripId != null) {
      _loadExistingTrip(editingTripId!);
    } else {
      // Default to next week
      final now = DateTime.now();
      startDate.value = now.add(const Duration(days: 3));
      endDate.value = now.add(const Duration(days: 7));
    }
  }

  void _loadExistingTrip(String tripId) {
    final trips = _tripRepository.getAllTrips();
    final match = trips.where((t) => t.id == tripId).toList();
    if (match.isNotEmpty) {
      final trip = match.first;
      destination.value = trip.destination;
      latitude.value = trip.latitude;
      longitude.value = trip.longitude;
      startDate.value = trip.startDate;
      endDate.value = trip.endDate;
      if (trip.arrivalHour != null) {
        arrivalTime.value = TimeOfDay(hour: trip.arrivalHour!, minute: trip.arrivalMinute ?? 0);
      }
      if (trip.departureHour != null) {
        departureTime.value = TimeOfDay(hour: trip.departureHour!, minute: trip.departureMinute ?? 0);
      }
      provideSpecificTimes.value = trip.hasSpecificHours;
      askForTimes.value = trip.hasSpecificHours;
    }
  }

  void setDestination({required String name, required double lat, required double lon}) {
    destination.value = name;
    latitude.value = lat;
    longitude.value = lon;
    searchResults.value = [];
  }

  Future<void> searchDestination(String query) async {
    if (query.trim().length < 2) {
      searchResults.value = [];
      return;
    }
    isSearching.value = true;
    final res = await _weatherService.searchLocation(query);
    searchResults.value = res;
    isSearching.value = false;
  }

  void setDates(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
    validationError.value = null;
  }

  void setArrivalTime(TimeOfDay time) {
    arrivalTime.value = time;
  }

  void setDepartureTime(TimeOfDay time) {
    departureTime.value = time;
  }

  bool validateStep1() {
    if (destination.value.trim().isEmpty) {
      validationError.value = 'Lütfen bir seyahat lokasyonu belirleyin.';
      return false;
    }
    final s = startDate.value;
    final e = endDate.value;
    if (s == null || e == null) {
      validationError.value = 'Lütfen başlangıç ve bitiş tarihlerini seçin.';
      return false;
    }
    if (e.isBefore(s)) {
      validationError.value = 'Bitiş tarihi başlangıç tarihinden önce olamaz.';
      return false;
    }
    validationError.value = null;
    return true;
  }

  TripPlannerModel buildDraftTrip({String? existingType, String? existingSubType}) {
    const uuid = Uuid();
    return TripPlannerModel(
      id: editingTripId ?? uuid.v4(),
      destination: destination.value,
      latitude: latitude.value,
      longitude: longitude.value,
      startDate: startDate.value!,
      endDate: endDate.value!,
      arrivalHour: provideSpecificTimes.value ? arrivalTime.value?.hour : null,
      arrivalMinute: provideSpecificTimes.value ? arrivalTime.value?.minute : null,
      departureHour: provideSpecificTimes.value ? departureTime.value?.hour : null,
      departureMinute: provideSpecificTimes.value ? departureTime.value?.minute : null,
      tripType: existingType ?? AppConstants.tripTypeVacation,
      tripSubType: existingSubType,
      createdAt: DateTime.now(),
    );
  }

  void dispose() {
    destination.dispose();
    latitude.dispose();
    longitude.dispose();
    startDate.dispose();
    endDate.dispose();
    askForTimes.dispose();
    provideSpecificTimes.dispose();
    arrivalTime.dispose();
    departureTime.dispose();
    searchResults.dispose();
    isSearching.dispose();
    validationError.dispose();
  }
}
