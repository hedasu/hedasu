import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/badge_item.dart';

/// Tek bir başarı rozetini temsil eden kart bileşeni.
class BadgeCard extends StatelessWidget {
  const BadgeCard({
    super.key,
    required this.badge,
  });

  final BadgeItem badge;

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.surface : AppColors.surfaceVariant.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked ? AppColors.neonLime.withValues(alpha: 0.7) : AppColors.cardBorder,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? AppColors.neonLime.withValues(alpha: 0.15)
                  : AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Text(
              badge.iconEmoji,
              style: TextStyle(
                fontSize: 26,
                color: isUnlocked ? null : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      badge.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                    _buildStatusChip(isUnlocked),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  badge.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: badge.progress,
                          minHeight: 5,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isUnlocked ? AppColors.neonLime : AppColors.neonCyan,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      badge.requirementText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isUnlocked ? AppColors.neonLime : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isUnlocked) {
    if (isUnlocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.neonLime.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Kazanıldı',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.neonLime,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Kilitli',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}
