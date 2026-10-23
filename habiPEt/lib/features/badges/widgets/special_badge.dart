import 'package:flutter/material.dart';
import '../models/badge_model.dart';
import '../../../core/constants/app_colors.dart';

class SpecialBadge extends StatelessWidget {
  final BadgeModel badge;
  final VoidCallback onTap;
  final bool isDark;

  const SpecialBadge({
    super.key,
    required this.badge,
    required this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark
        ? AppColors.specialCardBackgroundDark
        : AppColors.specialCardBackground;
    final borderColor =
        isDark ? AppColors.specialCardBorderDark : AppColors.specialCardBorder;
    final iconCircleColor =
        isDark ? AppColors.specialIconCircleDark : AppColors.specialIconCircle;
    final titleColor =
        isDark ? AppColors.specialTitleTextDark : AppColors.specialTitleText;
    final progressTextColor =
        isDark ? AppColors.specialTagTextDark : AppColors.specialProgressText;
    final progressInactive = isDark
        ? AppColors.badgeProgressInactiveDark
        : AppColors.specialProgressInactive;
    final rewardBg =
        isDark ? AppColors.specialTagBackgroundDark : AppColors.specialTagBackground;
    final rewardText =
        isDark ? AppColors.specialTagTextDark : AppColors.specialTagText;

    final habitTitle = badge.habitTitle;
    final displayTitle = habitTitle != null
        ? '21 Gün: $habitTitle'
        : '21 Gün: Bilimsel Alışkanlık';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                // Küçük Hedef İkonu
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconCircleColor,
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),

                // Başlık ve İlerleme
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              displayTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: titleColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // +150 Rozet Ödülü
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: rewardBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '+${badge.rewardCoins} Rozet',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: rewardText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nörolojik Hedef',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.specialDescText,
                            ),
                          ),
                          Text(
                            badge.progressText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: progressTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // İnce İlerleme Çubuğu
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: badge.progressRatio,
                minHeight: 4,
                backgroundColor: progressInactive,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.specialProgressActive,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
