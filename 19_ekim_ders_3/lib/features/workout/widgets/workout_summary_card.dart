import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Günlük Egzersiz Özeti ve Kalori Kartı (Temaya Duyarlı)
class WorkoutSummaryCard extends StatelessWidget {
  final int totalMinutes;
  final int totalCalories;
  final int minutesGoal;
  final int caloriesGoal;

  const WorkoutSummaryCard({
    super.key,
    required this.totalMinutes,
    required this.totalCalories,
    required this.minutesGoal,
    required this.caloriesGoal,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final green = AppColors.greenOf(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorderOf(context)),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.neonGreenGlow : const Color(0x1500E676),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatMetric(
              label: 'Aktif Süre',
              value: '$totalMinutes dk',
              goalText: 'Hedef: $minutesGoal dk',
              color: green,
              icon: Icons.timer_rounded,
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: AppColors.surfaceBorderOf(context),
          ),
          Expanded(
            child: _StatMetric(
              label: 'Yakılan Kalori',
              value: '$totalCalories kcal',
              goalText: 'Hedef: $caloriesGoal kcal',
              color: AppColors.neonOrange,
              icon: Icons.local_fire_department_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatMetric extends StatelessWidget {
  final String label;
  final String value;
  final String goalText;
  final Color color;
  final IconData icon;

  const _StatMetric({
    required this.label,
    required this.value,
    required this.goalText,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        Text(
          goalText,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }
}
