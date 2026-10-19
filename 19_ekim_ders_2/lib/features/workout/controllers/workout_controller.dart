import 'package:flutter/foundation.dart';
import '../../badges/controllers/badge_controller.dart';
import '../models/workout_entry_model.dart';

/// Fitness & Egzersiz Durum Kontrolcüsü (ValueNotifier + Geri Alma / Undo Desteği)
class WorkoutController {
  final BadgeController? badgeController;
  final int dailyCalorieGoal;
  final int dailyMinutesGoal;

  final ValueNotifier<List<WorkoutEntryModel>> workouts =
      ValueNotifier<List<WorkoutEntryModel>>([]);

  WorkoutController({
    this.badgeController,
    this.dailyCalorieGoal = 600,
    this.dailyMinutesGoal = 45,
  });

  int get totalMinutes =>
      workouts.value.fold<int>(0, (sum, w) => sum + w.durationMinutes);

  int get totalCalories =>
      workouts.value.fold<int>(0, (sum, w) => sum + w.caloriesBurned);

  bool get canUndo => workouts.value.isNotEmpty;

  double get calorieProgress =>
      dailyCalorieGoal > 0 ? (totalCalories / dailyCalorieGoal).clamp(0.0, 1.0) : 0.0;

  double get minutesProgress =>
      dailyMinutesGoal > 0 ? (totalMinutes / dailyMinutesGoal).clamp(0.0, 1.0) : 0.0;

  /// Antrenman ekleme
  void addWorkout({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    required String category,
  }) {
    if (durationMinutes <= 0 || caloriesBurned < 0) return;

    final newWorkout = WorkoutEntryModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      timestamp: DateTime.now(),
      category: category,
    );

    workouts.value = [...workouts.value, newWorkout];

    // Rozet tetiklemesi
    badgeController?.checkWorkoutBadges(
      totalMinutes,
      totalCalories,
      dailyCalorieGoal,
    );
  }

  /// Son antrenmanı geri alma (Undo)
  bool undoLastWorkout() {
    if (workouts.value.isEmpty) return false;

    final updated = List<WorkoutEntryModel>.from(workouts.value);
    updated.removeLast();
    workouts.value = updated;

    return true;
  }

  /// Sıfırlama
  void resetWorkouts() {
    workouts.value = [];
  }

  void dispose() {
    workouts.dispose();
  }
}
