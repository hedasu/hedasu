import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/workout_entry_model.dart';

/// Son Antrenmanı Geri Alma (Undo) Bölümü (Temaya Duyarlı)
class WorkoutUndoSection extends StatelessWidget {
  final List<WorkoutEntryModel> workouts;
  final VoidCallback onUndo;

  const WorkoutUndoSection({
    super.key,
    required this.workouts,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const SizedBox.shrink();
    }

    final last = workouts.last;
    final green = AppColors.greenOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLightOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorderOf(context)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: green, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Son Egzersiz: ${last.title}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryOf(context),
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${last.durationMinutes} dk • ${last.caloriesBurned} kcal',
                  style: TextStyle(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: onUndo,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceOf(context),
              foregroundColor: AppColors.neonOrange,
              side: const BorderSide(color: AppColors.neonOrange),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: const Icon(Icons.undo_rounded, size: 18),
            label: const Text('Geri Al', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
