import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout.dart';

/// Kaydedilen egzersizleri listeleyen widget.
class WorkoutLogList extends StatelessWidget {
  const WorkoutLogList({
    super.key,
    required this.workouts,
    required this.onDeleteWorkout,
  });

  final List<Workout> workouts;
  final void Function(String id) onDeleteWorkout;

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workouts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return _buildWorkoutItem(workout);
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.5)),
      ),
      child: const Column(
        children: [
          Icon(Icons.fitness_center_rounded, color: AppColors.textMuted, size: 28),
          SizedBox(height: 8),
          Text(
            'Henüz egzersiz kaydı bulunmuyor.',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutItem(Workout workout) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.neonOrange.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.neonOrange,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${workout.durationMinutes} dakika • ${workout.caloriesBurned} kcal',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            workout.formattedTime,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textMuted),
            onPressed: () => onDeleteWorkout(workout.id),
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}
