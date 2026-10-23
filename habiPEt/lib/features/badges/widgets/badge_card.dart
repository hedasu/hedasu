import 'package:flutter/material.dart';
import '../models/badge_model.dart';
import '../../../core/constants/app_colors.dart';

class BadgeCard extends StatelessWidget {
  final BadgeModel badge;
  final VoidCallback onTap;
  final bool isDark;

  const BadgeCard({
    super.key,
    required this.badge,
    required this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked;
    final cardBg = isDark
        ? AppColors.badgeCardBackgroundDark
        : AppColors.badgeCardBackground;
    final cardBorder =
        isDark ? AppColors.badgeCardBorderDark : AppColors.badgeCardBorder;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BadgeIconCircle(
                  badge: badge,
                  isUnlocked: isUnlocked,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _BadgeTitleText(
                  title: badge.title,
                  isUnlocked: isUnlocked,
                  isDark: isDark,
                ),
                const SizedBox(height: 4),
                _BadgeBottomStatus(
                  badge: badge,
                  isUnlocked: isUnlocked,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeIconCircle extends StatelessWidget {
  final BadgeModel badge;
  final bool isUnlocked;
  final bool isDark;

  const _BadgeIconCircle({
    required this.badge,
    required this.isUnlocked,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color borderColor;
    final Color iconColor;

    if (isUnlocked) {
      bgColor = isDark
          ? AppColors.badgeUnlockedIconBgDark
          : AppColors.badgeUnlockedIconBg;
      borderColor = isDark
          ? AppColors.badgeUnlockedIconBorderDark
          : AppColors.badgeUnlockedIconBorder;
      iconColor = isDark
          ? AppColors.badgeUnlockedIconColorDark
          : AppColors.badgeUnlockedIconColor;
    } else {
      bgColor = isDark
          ? AppColors.badgeLockedIconBgDark
          : AppColors.badgeLockedIconBg;
      borderColor = isDark
          ? AppColors.badgeLockedIconBorderDark
          : AppColors.badgeLockedIconBorder;
      iconColor = isDark
          ? AppColors.badgeLockedIconColorDark
          : AppColors.badgeLockedIconColor;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(color: borderColor, width: 1.8),
        boxShadow: [
          if (isUnlocked)
            BoxShadow(
              color: (isDark
                      ? AppColors.badgeUnlockedGlowDark
                      : AppColors.badgeUnlockedGlow)
                  .withValues(alpha: isDark ? 0.25 : 0.35),
              blurRadius: 8,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Icon(
        isUnlocked ? badge.icon : Icons.lock_outline_rounded,
        color: iconColor,
        size: 24,
      ),
    );
  }
}

class _BadgeTitleText extends StatelessWidget {
  final String title;
  final bool isUnlocked;
  final bool isDark;

  const _BadgeTitleText({
    required this.title,
    required this.isUnlocked,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor;
    if (isUnlocked) {
      textColor = isDark
          ? AppColors.badgeUnlockedTitleDark
          : AppColors.badgeUnlockedTitle;
    } else {
      textColor = isDark
          ? AppColors.badgeLockedTitleDark
          : AppColors.badgeLockedTitle;
    }

    return Text(
      title,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 12.5,
        fontWeight: isUnlocked ? FontWeight.w700 : FontWeight.w600,
        color: textColor,
      ),
    );
  }
}

class _BadgeBottomStatus extends StatelessWidget {
  final BadgeModel badge;
  final bool isUnlocked;
  final bool isDark;

  const _BadgeBottomStatus({
    required this.badge,
    required this.isUnlocked,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (isUnlocked) {
      final tagBg = isDark
          ? AppColors.badgeRewardTagBgDark
          : AppColors.badgeRewardTagBg;
      final tagText = isDark
          ? AppColors.badgeRewardTagTextDark
          : AppColors.badgeRewardTagText;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: tagBg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '+${badge.rewardCoins} Rozet',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: tagText,
          ),
        ),
      );
    }

    final countColor = isDark
        ? AppColors.badgeProgressCountDark
        : AppColors.badgeProgressCount;
    final progressBg = isDark
        ? AppColors.badgeProgressInactiveDark
        : AppColors.badgeProgressInactive;

    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Text(
            badge.progressText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: countColor,
            ),
          ),
          const SizedBox(height: 2.5),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: badge.progressRatio,
              minHeight: 3,
              backgroundColor: progressBg,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.badgeProgressActive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
