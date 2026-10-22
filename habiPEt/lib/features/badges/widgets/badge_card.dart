import 'package:flutter/material.dart';
import '../models/badge_model.dart';
import '../../../core/constants/app_colors.dart';

class BadgeCard extends StatelessWidget {
  final BadgeModel badge;
  final VoidCallback onTap;

  const BadgeCard({
    super.key,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked;
    final categoryColor = badge.category.categoryColor;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BadgeIconCircle(
                badge: badge,
                isUnlocked: isUnlocked,
                categoryColor: categoryColor,
              ),
              const SizedBox(height: 8),
              _BadgeTitleText(title: badge.title, isUnlocked: isUnlocked),
              const SizedBox(height: 4),
              _BadgeBottomStatus(badge: badge, isUnlocked: isUnlocked),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeIconCircle extends StatelessWidget {
  final BadgeModel badge;
  final bool isUnlocked;
  final Color categoryColor;

  const _BadgeIconCircle({
    required this.badge,
    required this.isUnlocked,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked
            ? categoryColor.withValues(alpha: 0.2)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border.all(
          color: isUnlocked ? categoryColor : Colors.grey.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          if (isUnlocked)
            BoxShadow(
              color: categoryColor.withValues(alpha: 0.35),
              blurRadius: 10,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Icon(
        isUnlocked ? badge.icon : Icons.lock_outline_rounded,
        color: isUnlocked ? categoryColor : Colors.grey,
        size: 26,
      ),
    );
  }
}

class _BadgeTitleText extends StatelessWidget {
  final String title;
  final bool isUnlocked;

  const _BadgeTitleText({required this.title, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13,
        fontWeight: isUnlocked ? FontWeight.w700 : FontWeight.w500,
        color: isUnlocked ? null : Theme.of(context).textTheme.bodySmall?.color,
      ),
    );
  }
}

class _BadgeBottomStatus extends StatelessWidget {
  final BadgeModel badge;
  final bool isUnlocked;

  const _BadgeBottomStatus({required this.badge, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    if (isUnlocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.accentGold.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '+${badge.rewardCoins} Rozet',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.accentGold,
          ),
        ),
      );
    }

    return Column(
      children: [
        Text(
          badge.progressText,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: badge.progressRatio,
            minHeight: 4,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(badge.category.categoryColor),
          ),
        ),
      ],
    );
  }
}
