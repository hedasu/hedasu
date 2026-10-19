import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Rozet İlerleme Başlık Kartı (Temaya Duyarlı)
class BadgeStatsHeader extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;
  final double progress;

  const BadgeStatsHeader({
    super.key,
    required this.unlockedCount,
    required this.totalCount,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final gold = AppColors.goldOf(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kazanılan Rozetler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              Text(
                '$unlockedCount / $totalCount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.surfaceBorderOf(context),
              valueColor: AlwaysStoppedAnimation<Color>(gold),
            ),
          ),
        ],
      ),
    );
  }
}
