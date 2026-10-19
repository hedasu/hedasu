import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Rozet kazanım durumunu ve genel başarı oranını özetleyen kart.
class BadgeSummaryHeader extends StatelessWidget {
  const BadgeSummaryHeader({
    super.key,
    required this.unlockedCount,
    required this.totalCount,
    required this.ratio,
  });

  final int unlockedCount;
  final int totalCount;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    final percentage = (ratio * 100).round();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: unlockedCount > 0 ? AppColors.neonLime : AppColors.cardBorder,
          width: 1.5,
        ),
        boxShadow: unlockedCount > 0
            ? [
                BoxShadow(
                  color: AppColors.neonLime.withValues(alpha: 0.12),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.neonLime.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      color: AppColors.neonLime,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rozet Odası',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$unlockedCount / $totalCount Rozet Kazanıldı',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '%$percentage',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.neonLime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonLime),
            ),
          ),
        ],
      ),
    );
  }
}
