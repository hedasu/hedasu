import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../models/luggage_analysis_model.dart';

class LuggageAnalysisController {
  final TripRepository _tripRepository;
  final String tripId;

  final ValueNotifier<TripPlannerModel?> trip = ValueNotifier<TripPlannerModel?>(null);
  final ValueNotifier<LuggageAnalysisModel?> analysis = ValueNotifier<LuggageAnalysisModel?>(null);

  LuggageAnalysisController({
    required TripRepository tripRepository,
    required this.tripId,
  }) : _tripRepository = tripRepository {
    calculate();
  }

  void calculate() {
    final trips = _tripRepository.getAllTrips();
    final match = trips.where((t) => t.id == tripId).toList();
    if (match.isEmpty) return;

    final curTrip = match.first;
    trip.value = curTrip;

    final totalWeight = curTrip.totalWeightKg;
    final totalVolume = curTrip.totalVolumeLiters;

    final exceeded = totalWeight > AppConstants.cabinMaxWeightKg ||
        totalVolume > AppConstants.cabinMaxVolumeLiters;

    String summary;
    if (exceeded) {
      summary =
          'Dikkat: Valiz içeriği standart kabin bagajı sınırlarını (${AppConstants.cabinMaxWeightKg.toInt()} kg / ${AppConstants.cabinMaxVolumeLiters.toInt()} L) aşmaktadır. Uçuş için büyük boy bagaj teslimi veya eşya elemesi yapmanız gerekebilir.';
    } else {
      summary =
          'Mükemmel! Valiziniz standart kabin bagajı ölçüleri (${AppConstants.cabinMaxWeightKg.toInt()} kg / ${AppConstants.cabinMaxVolumeLiters.toInt()} L) ile tamamen uyumlu görünmektedir.';
    }

    analysis.value = LuggageAnalysisModel(
      totalWeightKg: totalWeight,
      totalVolumeLiters: totalVolume,
      cabinMaxWeightKg: AppConstants.cabinMaxWeightKg,
      cabinMaxVolumeLiters: AppConstants.cabinMaxVolumeLiters,
      isCabinExceeded: exceeded,
      statusSummary: summary,
    );
  }

  void dispose() {
    trip.dispose();
    analysis.dispose();
  }
}
