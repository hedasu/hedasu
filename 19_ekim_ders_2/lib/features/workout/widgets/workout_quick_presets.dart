import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Hızlı Antrenman Ekleme Seçenekleri (Temaya Duyarlı)
class WorkoutQuickPresets extends StatelessWidget {
  final void Function({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    required String category,
  }) onAddPreset;

  const WorkoutQuickPresets({
    super.key,
    required this.onAddPreset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hızlı Egzersiz Ekle',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _PresetChip(
              title: 'Ağırlık',
              subtitle: '45 dk • 320 kcal',
              icon: Icons.fitness_center_rounded,
              onTap: () => onAddPreset(
                title: 'Ağırlık Antrenmanı',
                durationMinutes: 45,
                caloriesBurned: 320,
                category: 'strength',
              ),
            ),
            _PresetChip(
              title: 'Kardio Koşu',
              subtitle: '30 dk • 280 kcal',
              icon: Icons.directions_run_rounded,
              onTap: () => onAddPreset(
                title: 'Kardio Koşu',
                durationMinutes: 30,
                caloriesBurned: 280,
                category: 'cardio',
              ),
            ),
            _PresetChip(
              title: 'HIIT Seansı',
              subtitle: '20 dk • 220 kcal',
              icon: Icons.flash_on_rounded,
              onTap: () => onAddPreset(
                title: 'HIIT Yağ Yakımı',
                durationMinutes: 20,
                caloriesBurned: 220,
                category: 'hiit',
              ),
            ),
            _PresetChip(
              title: 'Yoga & Esneme',
              subtitle: '25 dk • 90 kcal',
              icon: Icons.self_improvement_rounded,
              onTap: () => onAddPreset(
                title: 'Yoga & Esneme',
                durationMinutes: 25,
                caloriesBurned: 90,
                category: 'yoga',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _PresetChip({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final green = AppColors.greenOf(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceBorderOf(context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: green, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
