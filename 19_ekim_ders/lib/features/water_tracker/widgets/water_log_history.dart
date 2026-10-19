import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_log.dart';

/// Günlük su tüketim geçmişini listeleyen widget.
class WaterLogHistory extends StatelessWidget {
  const WaterLogHistory({
    super.key,
    required this.logs,
    required this.onDeleteLog,
  });

  final List<WaterLog> logs;
  final void Function(String logId) onDeleteLog;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final log = logs[index];
        return _buildLogItem(log);
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.5)),
      ),
      child: const Column(
        children: [
          Icon(Icons.opacity_rounded, color: AppColors.textMuted, size: 28),
          SizedBox(height: 8),
          Text(
            'Henüz su tüketimi kaydedilmedi.',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(WaterLog log) {
    final isDecrease = log.amountMl < 0;
    final amountText = isDecrease ? '${log.amountMl} ml' : '+${log.amountMl} ml';
    final accentColor = isDecrease ? AppColors.neonOrange : AppColors.neonCyan;
    final itemIcon = isDecrease ? Icons.remove_circle_outline_rounded : Icons.water_drop_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              itemIcon,
              color: accentColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amountText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDecrease ? AppColors.neonOrange : AppColors.textPrimary,
                  ),
                ),
                Text(
                  log.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            log.formattedTime,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textMuted),
            onPressed: () => onDeleteLog(log.id),
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}
