import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PetLevelIndicator extends StatelessWidget {
  final int level;
  final int currentExp;
  final int maxExp;

  const PetLevelIndicator({
    super.key,
    required this.level,
    required this.currentExp,
    required this.maxExp,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentExp / maxExp).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LevelHeaderRow(level: level, currentExp: currentExp, maxExp: maxExp),
        const SizedBox(height: 6),
        _ProgressBar(progress: progress),
      ],
    );
  }
}

class _LevelHeaderRow extends StatelessWidget {
  final int level;
  final int currentExp;
  final int maxExp;

  const _LevelHeaderRow({
    required this.level,
    required this.currentExp,
    required this.maxExp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.darkMint.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.darkMint, width: 1),
              ),
              child: Text(
                'SV $level',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkMint,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Gelişim Seviyesi',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          '$currentExp / $maxExp XP',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 8,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.darkMint, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
