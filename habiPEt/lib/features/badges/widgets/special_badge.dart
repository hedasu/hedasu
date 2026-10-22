import 'package:flutter/material.dart';
import '../models/badge_model.dart';
import '../../../core/constants/app_colors.dart';

class SpecialBadge extends StatelessWidget {
  final BadgeModel badge;
  final VoidCallback onTap;

  const SpecialBadge({
    super.key,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accentPink.withValues(alpha: 0.22),
              AppColors.accentPurple.withValues(alpha: 0.15),
            ],
          ),
          border: Border.all(
            color: AppColors.accentPink.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentPink.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _SpecialBadgeHeader(badge: badge),
            const SizedBox(height: 12),
            _SpecialBadgeProgress(badge: badge),
          ],
        ),
      ),
    );
  }
}

class _SpecialBadgeHeader extends StatelessWidget {
  final BadgeModel badge;

  const _SpecialBadgeHeader({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.accentPink, AppColors.accentPurple],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentPink.withValues(alpha: 0.4),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.psychology_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentPink.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'BİLİMSEL HEDEF',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accentPink,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '+${badge.rewardCoins} Rozet',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentGold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                badge.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpecialBadgeProgress extends StatelessWidget {
  final BadgeModel badge;

  const _SpecialBadgeProgress({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              badge.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nörolojik İlerleme',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            Text(
              badge.progressText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.accentPink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: badge.progressRatio,
            minHeight: 8,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.accentPink),
          ),
        ),
      ],
    );
  }
}
