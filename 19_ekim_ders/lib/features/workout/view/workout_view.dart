import 'package:flutter/material.dart';
import '../controller/workout_controller.dart';
import '../widgets/quick_workout_presets.dart';
import '../widgets/workout_log_list.dart';
import '../widgets/workout_stat_card.dart';

/// Egzersiz takip modülü ana ekran görünümü.
/// Kırmızı çizgiler uyarınca build metodu kısa ve modüler widgetlardan oluşmaktadır.
class WorkoutView extends StatelessWidget {
  const WorkoutView({
    super.key,
    required this.controller,
  });

  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WorkoutStatCard(
                caloriesBurned: controller.totalCaloriesBurned,
                calorieGoal: controller.dailyCalorieGoal,
                durationMinutes: controller.totalDurationMinutes,
                progressRatio: controller.calorieProgressRatio,
                isGoalAchieved: controller.isGoalAchieved,
              ),
              const SizedBox(height: 20),
              QuickWorkoutPresets(
                onAddWorkout: controller.addWorkout,
                onUndoLast: controller.undoLast,
                onReset: controller.reset,
                canUndo: controller.canUndo,
              ),
              const SizedBox(height: 20),
              const Text(
                'Tamamlanan Egzersizler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              WorkoutLogList(
                workouts: controller.workouts,
                onDeleteWorkout: controller.removeWorkout,
              ),
            ],
          ),
        );
      },
    );
  }
}
