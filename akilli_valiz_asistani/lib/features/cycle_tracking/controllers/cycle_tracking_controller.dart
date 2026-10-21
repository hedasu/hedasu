import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/models/user_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../models/cycle_model.dart';

class CycleTrackingController {
  final StorageService _storageService;
  final TripRepository _tripRepository;

  final ValueNotifier<UserModel> user = ValueNotifier<UserModel>(
    const UserModel(id: 'temp', name: '', email: ''),
  );
  final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(false);
  final ValueNotifier<DateTime> lastPeriodDate = ValueNotifier<DateTime>(DateTime.now().subtract(const Duration(days: 14)));
  final ValueNotifier<int> cycleLength = ValueNotifier<int>(28);
  final ValueNotifier<CyclePredictionModel?> prediction = ValueNotifier<CyclePredictionModel?>(null);

  CycleTrackingController({
    required StorageService storageService,
    required TripRepository tripRepository,
  })  : _storageService = storageService,
        _tripRepository = tripRepository {
    loadData();
  }

  void loadData() {
    final curUser = _storageService.getUser();
    user.value = curUser;
    isEnabled.value = curUser.cycleTrackingEnabled;
    lastPeriodDate.value = curUser.lastPeriodDate ?? DateTime.now().subtract(const Duration(days: 14));
    cycleLength.value = curUser.cycleLengthDays;
    _computePrediction();
  }

  void toggleEnabled(bool val) async {
    isEnabled.value = val;
    final updated = user.value.copyWith(cycleTrackingEnabled: val);
    await _storageService.saveUser(updated);
    user.value = updated;
    _computePrediction();
  }

  void setLastPeriodDate(DateTime date) async {
    lastPeriodDate.value = date;
    final updated = user.value.copyWith(lastPeriodDate: date);
    await _storageService.saveUser(updated);
    user.value = updated;
    _computePrediction();
  }

  void setCycleLength(int length) async {
    cycleLength.value = length;
    final updated = user.value.copyWith(cycleLengthDays: length);
    await _storageService.saveUser(updated);
    user.value = updated;
    _computePrediction();
  }

  void _computePrediction() {
    if (!isEnabled.value) {
      prediction.value = null;
      return;
    }

    final start = lastPeriodDate.value;
    final nextStart = start.add(Duration(days: cycleLength.value));
    final nextEnd = nextStart.add(const Duration(days: 5));

    final trips = _tripRepository.getAllTrips();
    bool overlap = false;
    String? overlapTripName;

    for (final t in trips) {
      // Check if [tStart, tEnd] overlaps with [nextStart, nextEnd]
      if (!(t.endDate.isBefore(nextStart) || t.startDate.isAfter(nextEnd))) {
        overlap = true;
        overlapTripName = t.destination;
        break;
      }
    }

    String msg;
    if (overlap) {
      msg =
          'Dikkat: $overlapTripName seyahatiniz tahmini döngü döneminiz (${nextStart.day}/${nextStart.month} - ${nextEnd.day}/${nextEnd.month}) ile çakışmaktadır. Hijyenik ped, sıcak su torbası, ağrı kesici ve konforlu kıyafetleri valizinize eklemeyi unutmayın.';
    } else {
      msg =
          'Harika! Yakın tarihli seyahatleriniz ile tahmini döngü döneminiz (${nextStart.day}/${nextStart.month} - ${nextEnd.day}/${nextEnd.month}) arasında bir çakışma görünmüyor.';
    }

    prediction.value = CyclePredictionModel(
      nextEstimatedStart: nextStart,
      nextEstimatedEnd: nextEnd,
      hasOverlapWithTrip: overlap,
      overlappingTripName: overlapTripName,
      advisoryMessage: msg,
    );
  }

  void dispose() {
    user.dispose();
    isEnabled.dispose();
    lastPeriodDate.dispose();
    cycleLength.dispose();
    prediction.dispose();
  }
}
