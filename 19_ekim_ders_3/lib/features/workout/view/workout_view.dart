import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/workout_controller.dart';
import '../models/workout_entry_model.dart';
import '../widgets/workout_card.dart';
import '../widgets/workout_quick_presets.dart';
import '../widgets/workout_summary_card.dart';
import '../widgets/workout_undo_section.dart';

/// Egzersiz ve Fitness Takip Görünümü (Stateless & ValueListenableBuilder)
class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<WorkoutEntryModel>>(
      valueListenable: controller.workouts,
      builder: (context, workoutList, _) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          children: [
            WorkoutSummaryCard(
              totalMinutes: controller.totalMinutes,
              totalCalories: controller.totalCalories,
              minutesGoal: controller.dailyMinutesGoal,
              caloriesGoal: controller.dailyCalorieGoal,
            ),
            const SizedBox(height: 16),
            WorkoutUndoSection(
              workouts: workoutList,
              onUndo: () => _handleUndo(context),
            ),
            const SizedBox(height: 16),
            WorkoutQuickPresets(
              onAddPreset: ({
                required String title,
                required int durationMinutes,
                required int caloriesBurned,
                required String category,
              }) {
                controller.addWorkout(
                  title: title,
                  durationMinutes: durationMinutes,
                  caloriesBurned: caloriesBurned,
                  category: category,
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Bugünkü Antrenmanlar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _WorkoutList(workoutList: workoutList),
          ],
        );
      },
    );
  }

  void _handleUndo(BuildContext context) {
    final success = controller.undoLastWorkout();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Son antrenman kaydı geri alındı.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class _WorkoutList extends StatelessWidget {
  final List<WorkoutEntryModel> workoutList;

  const _WorkoutList({required this.workoutList});

  @override
  Widget build(BuildContext context) {
    if (workoutList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: const Center(
          child: Text(
            'Henüz antrenman kaydı eklenmedi.\nYukarıdaki hızlı seçeneklerden ekleyebilirsin.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workoutList.length,
      itemBuilder: (context, index) {
        // En yeniden en eskiye
        final item = workoutList[workoutList.length - 1 - index];
        return WorkoutCard(workout: item);
      },
    );
  }
}
