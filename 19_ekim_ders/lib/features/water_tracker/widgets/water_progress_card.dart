import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Günlük su tüketim ilerlemesini ve kalan miktarı gösteren neon gösterge kartı.
class WaterProgressCard extends StatelessWidget {
  const WaterProgressCard({
    super.key,
    required this.currentMl,
    required this.goalMl,
    required this.progressRatio,
    required this.isGoalAchieved,
  });

  final int currentMl;
  final int goalMl;
  final double progressRatio;
  final bool isGoalAchieved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isGoalAchieved ? AppColors.neonLime : AppColors.cardBorder,
          width: 1.5,
        ),
        boxShadow: isGoalAchieved
            ? [
                BoxShadow(
                  color: AppColors.neonLime.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          _buildProgressCircle(context),
          const SizedBox(height: 20),
          _buildGoalSummary(context),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progressRatio,
            strokeWidth: 14,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              isGoalAchieved ? AppColors.neonLime : AppColors.neonCyan,
            ),
            strokeCap: StrokeCap.round,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.water_drop_rounded,
                  color: isGoalAchieved ? AppColors.neonLime : AppColors.neonCyan,
                  size: 32,
                ),
                const SizedBox(height: 4),
                Text(
                  '$currentMl',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  '/ $goalMl ml',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSummary(BuildContext context) {
    final percentage = (progressRatio * 100).round();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoColumn('Yüzde', '%$percentage', AppColors.neonCyan),
        Container(width: 1, height: 28, color: AppColors.cardBorder),
        _buildInfoColumn(
          'Durum',
          isGoalAchieved ? 'Hedef Tamam!' : 'Devam Ediyor',
          isGoalAchieved ? AppColors.neonLime : AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
