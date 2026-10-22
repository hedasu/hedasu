import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BadgeProgress extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;
  final int totalCoins;

  const BadgeProgress({
    super.key,
    required this.unlockedCount,
    required this.totalCount,
    required this.totalCoins,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          _BadgeStatsRow(
            unlockedCount: unlockedCount,
            totalCount: totalCount,
            totalCoins: totalCoins,
          ),
          const SizedBox(height: 12),
          const _BadgeHierarchyLegend(),
        ],
      ),
    );
  }
}

class _BadgeStatsRow extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;
  final int totalCoins;

  const _BadgeStatsRow({
    required this.unlockedCount,
    required this.totalCount,
    required this.totalCoins,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kazanılan Rozetler',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '$unlockedCount / $totalCount Rozet',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentGold.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.accentGold.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              const Text('🪙', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                '$totalCoins Rozet',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BadgeHierarchyLegend extends StatelessWidget {
  const _BadgeHierarchyLegend();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Değer Sıralaması: ',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
          Text(
            'Yıllık > Aylık > Haftalık > Günlük',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.darkMint,
            ),
          ),
        ],
      ),
    );
  }
}
