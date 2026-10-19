import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Dairesel Su İlerleme Kartı (Karanlık ve Aydınlık Uyumlu)
class WaterProgressCard extends StatelessWidget {
  final int currentWater;
  final int dailyGoal;

  const WaterProgressCard({
    super.key,
    required this.currentWater,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = dailyGoal > 0 ? (currentWater / dailyGoal).clamp(0.0, 1.0) : 0.0;
    final percentage = (ratio * 100).toInt();
    final isDark = AppColors.isDark(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceBorderOf(context)),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.neonCyanGlow : const Color(0x1500E5FF),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _CircularProgress(ratio: ratio),
            _CenterProgressText(
              currentWater: currentWater,
              dailyGoal: dailyGoal,
              percentage: percentage,
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularProgress extends StatelessWidget {
  final double ratio;

  const _CircularProgress({required this.ratio});

  @override
  Widget build(BuildContext context) {
    final cyan = AppColors.cyanOf(context);
    return SizedBox(
      width: 190,
      height: 190,
      child: CircularProgressIndicator(
        value: ratio,
        strokeWidth: 14,
        strokeCap: StrokeCap.round,
        backgroundColor: AppColors.surfaceLightOf(context),
        valueColor: AlwaysStoppedAnimation<Color>(cyan),
      ),
    );
  }
}

class _CenterProgressText extends StatelessWidget {
  final int currentWater;
  final int dailyGoal;
  final int percentage;

  const _CenterProgressText({
    required this.currentWater,
    required this.dailyGoal,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final cyan = AppColors.cyanOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.water_drop_rounded, color: cyan, size: 36),
        const SizedBox(height: 6),
        Text(
          '$currentWater ml',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryOf(context),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Hedef: $dailyGoal ml (%$percentage)',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }
}
