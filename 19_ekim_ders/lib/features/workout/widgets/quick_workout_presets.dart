import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Hızlı egzersiz ekleme buton grubu widgetı.
class QuickWorkoutPresets extends StatelessWidget {
  const QuickWorkoutPresets({
    super.key,
    required this.onAddWorkout,
    required this.onUndoLast,
    required this.onReset,
    required this.canUndo,
  });

  final void Function({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    required String category,
  }) onAddWorkout;
  final VoidCallback onUndoLast;
  final VoidCallback onReset;
  final bool canUndo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Hızlı Egzersiz',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Row(
              children: [
                TextButton.icon(
                  onPressed: canUndo ? onUndoLast : null,
                  icon: Icon(
                    Icons.undo_rounded,
                    size: 16,
                    color: canUndo ? AppColors.neonOrange : AppColors.textMuted,
                  ),
                  label: Text(
                    'Geri Al',
                    style: TextStyle(
                      fontSize: 12,
                      color: canUndo ? AppColors.neonOrange : AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.textMuted),
                  label: const Text(
                    'Sıfırla',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildPresetButton(
              title: 'Koşu',
              duration: 25,
              calories: 220,
              icon: Icons.directions_run_rounded,
              color: AppColors.neonOrange,
            ),
            const SizedBox(width: 8),
            _buildPresetButton(
              title: 'Ağırlık',
              duration: 40,
              calories: 250,
              icon: Icons.fitness_center_rounded,
              color: AppColors.neonLime,
            ),
            const SizedBox(width: 8),
            _buildPresetButton(
              title: 'HIIT',
              duration: 15,
              calories: 180,
              icon: Icons.bolt_rounded,
              color: AppColors.neonPurple,
            ),
            const SizedBox(width: 8),
            _buildPresetButton(
              title: 'Bisiklet',
              duration: 30,
              calories: 200,
              icon: Icons.pedal_bike_rounded,
              color: AppColors.neonCyan,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetButton({
    required String title,
    required int duration,
    required int calories,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onAddWorkout(
            title: title,
            durationMinutes: duration,
            caloriesBurned: calories,
            category: title,
          ),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$duration dk',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
