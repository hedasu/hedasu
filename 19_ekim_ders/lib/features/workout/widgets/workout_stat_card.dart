import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Egzersiz ve yakılan kalori istatistiklerini özetleyen neon kart.
class WorkoutStatCard extends StatelessWidget {
  const WorkoutStatCard({
    super.key,
    required this.caloriesBurned,
    required this.calorieGoal,
    required this.durationMinutes,
    required this.progressRatio,
    required this.isGoalAchieved,
  });

  final int caloriesBurned;
  final int calorieGoal;
  final int durationMinutes;
  final double progressRatio;
  final bool isGoalAchieved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isGoalAchieved ? AppColors.neonLime : AppColors.cardBorder,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric(
                label: 'Yakılan Kalori',
                value: '$caloriesBurned',
                unit: '/ $calorieGoal kcal',
                color: AppColors.neonOrange,
                icon: Icons.local_fire_department_rounded,
              ),
              _buildMetric(
                label: 'Toplam Süre',
                value: '$durationMinutes',
                unit: 'dk',
                color: AppColors.neonLime,
                icon: Icons.timer_outlined,
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressRatio,
              minHeight: 10,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                isGoalAchieved ? AppColors.neonLime : AppColors.neonOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({
    required String label,
    required String value,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
