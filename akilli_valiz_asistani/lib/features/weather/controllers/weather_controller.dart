import 'package:flutter/material.dart';
import '../../../core/services/weather_service.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../models/weather_model.dart';

class WeatherController {
  final WeatherService _weatherService;
  final TripRepository _tripRepository;
  final String tripId;

  final ValueNotifier<TripPlannerModel?> currentTrip =
      ValueNotifier<TripPlannerModel?>(null);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<List<DailyWeatherItem>> dailyItems =
      ValueNotifier<List<DailyWeatherItem>>([]);
  final ValueNotifier<List<HourlyWeatherItem>> hourlyItems =
      ValueNotifier<List<HourlyWeatherItem>>([]);
  final ValueNotifier<List<String>> alerts = ValueNotifier<List<String>>([]);
  final ValueNotifier<String?> error = ValueNotifier<String?>(null);

  WeatherController({
    required WeatherService weatherService,
    required TripRepository tripRepository,
    required this.tripId,
  })  : _weatherService = weatherService,
        _tripRepository = tripRepository {
    loadWeatherData();
  }

  Future<void> loadWeatherData() async {
    isLoading.value = true;
    error.value = null;

    final trips = _tripRepository.getAllTrips();
    final match = trips.where((t) => t.id == tripId).toList();
    if (match.isEmpty) {
      error.value = 'Seyahat bulunamadı.';
      isLoading.value = false;
      return;
    }

    final trip = match.first;
    currentTrip.value = trip;

    try {
      final report = await _weatherService.fetchTripWeather(
        lat: trip.latitude,
        lon: trip.longitude,
        startDate: trip.startDate,
        endDate: trip.endDate,
        arrivalTime: trip.arrivalHour != null
            ? TimeOfDay(hour: trip.arrivalHour!, minute: trip.arrivalMinute ?? 0)
            : null,
        departureTime: trip.departureHour != null
            ? TimeOfDay(hour: trip.departureHour!, minute: trip.departureMinute ?? 0)
            : null,
      );

      dailyItems.value = report.dailyForecast
          .map((d) => DailyWeatherItem(
                date: d.date,
                maxTemp: d.tempMax,
                minTemp: d.tempMin,
                precipitationProbability: d.precipitationProbability,
                conditionDescription: d.conditionText,
                icon: d.iconData,
              ))
          .toList();

      hourlyItems.value = report.hourlyForecast
          .map((h) => HourlyWeatherItem(
                time: h.time,
                temperature: h.temperature,
                precipitationProbability: h.precipitationProbability,
                icon: h.iconData,
              ))
          .toList();

      alerts.value = report.weatherAlerts;
      isLoading.value = false;
    } catch (e) {
      error.value = 'Hava durumu verisi alınamadı: $e';
      isLoading.value = false;
    }
  }

  void dispose() {
    currentTrip.dispose();
    isLoading.dispose();
    dailyItems.dispose();
    hourlyItems.dispose();
    alerts.dispose();
    error.dispose();
  }
}
