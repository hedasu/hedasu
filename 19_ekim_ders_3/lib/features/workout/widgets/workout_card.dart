import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/workout_entry_model.dart';

/// Tekil Antrenman Kartı (Temaya Duyarlı)
class WorkoutCard extends StatelessWidget {
  final WorkoutEntryModel workout;

  const WorkoutCard({
    super.key,
    required this.workout,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'cardio':
        return Icons.directions_run_rounded;
      case 'hiit':
        return Icons.flash_on_rounded;
      case 'yoga':
        return Icons.self_improvement_rounded;
      case 'strength':
      default:
        return Icons.fitness_center_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorderOf(context)),
      ),
      child: Row(
        children: [
          _WorkoutIconBox(icon: _getCategoryIcon(workout.category)),
          const SizedBox(width: 14),
          Expanded(
            child: _WorkoutInfo(
              title: workout.title,
              durationMinutes: workout.durationMinutes,
            ),
          ),
          _WorkoutCalories(calories: workout.caloriesBurned),
        ],
      ),
    );
  }
}

class _WorkoutIconBox extends StatelessWidget {
  final IconData icon;

  const _WorkoutIconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final green = AppColors.greenOf(context);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? AppColors.neonGreenGlow : const Color(0x2000E676),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: green, size: 24),
    );
  }
}

class _WorkoutInfo extends StatelessWidget {
  final String title;
  final int durationMinutes;

  const _WorkoutInfo({
    required this.title,
    required this.durationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$durationMinutes dakika',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }
}

class _WorkoutCalories extends StatelessWidget {
  final int calories;

  const _WorkoutCalories({required this.calories});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLightOf(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neonOrangeGlow),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: AppColors.neonOrange, size: 16),
          const SizedBox(width: 4),
          Text(
            '$calories kcal',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.neonOrange,
            ),
          ),
        ],
      ),
    );
  }
}
