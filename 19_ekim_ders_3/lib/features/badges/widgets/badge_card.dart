import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/badge_model.dart';

/// Tekil Rozet Kartı Widget'ı (Temaya Duyarlı)
class BadgeCard extends StatelessWidget {
  final BadgeModel badge;

  const BadgeCard({
    super.key,
    required this.badge,
  });

  IconData _resolveIcon(String iconName) {
    switch (iconName) {
      case 'water_drop':
        return Icons.water_drop_rounded;
      case 'verified':
        return Icons.verified_rounded;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'local_fire_department':
        return Icons.local_fire_department_rounded;
      case 'military_tech':
      default:
        return Icons.military_tech_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked;
    final gold = AppColors.goldOf(context);
    final border = AppColors.surfaceBorderOf(context);
    final isDark = AppColors.isDark(context);

    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.surfaceLightOf(context) : AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? gold : border,
          width: isUnlocked ? 1.5 : 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: isDark ? AppColors.neonGoldGlow : const Color(0x22FFD700),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _BadgeIcon(
            icon: _resolveIcon(badge.iconName),
            isUnlocked: isUnlocked,
          ),
          const SizedBox(height: 10),
          Text(
            badge.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isUnlocked
                  ? AppColors.textPrimaryOf(context)
                  : AppColors.textMutedOf(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            badge.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondaryOf(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final bool isUnlocked;

  const _BadgeIcon({
    required this.icon,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final gold = AppColors.goldOf(context);
    final isDark = AppColors.isDark(context);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked
            ? (isDark ? AppColors.neonGoldGlow : const Color(0x25FFD700))
            : AppColors.surfaceBorderOf(context),
      ),
      child: Icon(
        icon,
        size: 26,
        color: isUnlocked ? gold : AppColors.textMutedOf(context),
      ),
    );
  }
}
