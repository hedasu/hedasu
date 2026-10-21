import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../models/trip_type_model.dart';

class TripTypeController {
  final TripRepository _tripRepository;
  final String tripId;

  final ValueNotifier<TripPlannerModel?> trip = ValueNotifier<TripPlannerModel?>(null);
  final ValueNotifier<String> selectedType = ValueNotifier<String>(AppConstants.tripTypeVacation);
  final ValueNotifier<String?> selectedSubType = ValueNotifier<String?>('Yaz Tatili');

  final List<TripTypeOption> options = [
    const TripTypeOption(
      title: AppConstants.tripTypeVacation,
      description: 'Plaj, kayak, dinlenme veya deniz kenarı seyahatleri.',
      icon: Icons.beach_access_rounded,
      subTypes: ['Yaz Tatili', 'Kış Tatili'],
      accentColor: AppColors.primary,
    ),
    const TripTypeOption(
      title: AppConstants.tripTypeBusiness,
      description: 'Resmi toplantılar, sempozyumlar, kongre ve networking.',
      icon: Icons.business_center_rounded,
      subTypes: ['Konferans', 'Sempozyum', 'Toplantı'],
      accentColor: AppColors.secondary,
    ),
    const TripTypeOption(
      title: AppConstants.tripTypeCamping,
      description: 'Doğa kampları, trekking, çadır ve açık hava aktiviteleri.',
      icon: Icons.forest_rounded,
      subTypes: ['Kamp Gezisi', 'Dağcılık / Trekking'],
      accentColor: AppColors.success,
    ),
    const TripTypeOption(
      title: AppConstants.tripTypeCultural,
      description: 'Tarihi şehir turları, müzeler, gastronomi ve keşif gezileri.',
      icon: Icons.museum_rounded,
      subTypes: ['Şehir Keşfi', 'Müze & Tarihi Tur'],
      accentColor: AppColors.accentIndigo,
    ),
  ];

  TripTypeController({
    required TripRepository tripRepository,
    required this.tripId,
  }) : _tripRepository = tripRepository {
    _loadTrip();
  }

  void _loadTrip() {
    final trips = _tripRepository.getAllTrips();
    final match = trips.where((t) => t.id == tripId).toList();
    if (match.isNotEmpty) {
      final current = match.first;
      trip.value = current;
      selectedType.value = current.tripType;
      selectedSubType.value = current.tripSubType ?? options.first.subTypes.first;
    }
  }

  void selectType(String type) {
    selectedType.value = type;
    final opt = options.firstWhere((o) => o.title == type);
    selectedSubType.value = opt.subTypes.isNotEmpty ? opt.subTypes.first : null;
  }

  void selectSubType(String subType) {
    selectedSubType.value = subType;
  }

  Future<void> saveTripType() async {
    final cur = trip.value;
    if (cur != null) {
      final updated = cur.copyWith(
        tripType: selectedType.value,
        tripSubType: selectedSubType.value,
      );
      await _tripRepository.saveTrip(updated);
      trip.value = updated;
    }
  }

  void dispose() {
    trip.dispose();
    selectedType.dispose();
    selectedSubType.dispose();
  }
}
