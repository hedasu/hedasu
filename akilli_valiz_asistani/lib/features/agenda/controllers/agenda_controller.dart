import 'package:flutter/material.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';

class AgendaController {
  final TripRepository _tripRepository;

  final ValueNotifier<List<TripPlannerModel>> pastTrips = ValueNotifier<List<TripPlannerModel>>([]);
  final ValueNotifier<List<TripPlannerModel>> currentTrips = ValueNotifier<List<TripPlannerModel>>([]);
  final ValueNotifier<List<TripPlannerModel>> upcomingTrips = ValueNotifier<List<TripPlannerModel>>([]);

  AgendaController({required TripRepository tripRepository})
      : _tripRepository = tripRepository {
    classifyTrips();
  }

  void classifyTrips() {
    final all = _tripRepository.getAllTrips();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final past = <TripPlannerModel>[];
    final current = <TripPlannerModel>[];
    final upcoming = <TripPlannerModel>[];

    for (final t in all) {
      final s = DateTime(t.startDate.year, t.startDate.month, t.startDate.day);
      final e = DateTime(t.endDate.year, t.endDate.month, t.endDate.day);

      if (e.isBefore(today)) {
        past.add(t);
      } else if (s.isAfter(today)) {
        upcoming.add(t);
      } else {
        current.add(t);
      }
    }

    pastTrips.value = past;
    currentTrips.value = current;
    upcomingTrips.value = upcoming;
  }

  void dispose() {
    pastTrips.dispose();
    currentTrips.dispose();
    upcomingTrips.dispose();
  }
}
