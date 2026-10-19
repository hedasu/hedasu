import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/water_entry_model.dart';

/// Son Su Tüketimi ve Geri Alma (Undo) Butonu Widget'ı (Temaya Duyarlı)
class WaterUndoSection extends StatelessWidget {
  final List<WaterEntryModel> history;
  final VoidCallback onUndo;

  const WaterUndoSection({
    super.key,
    required this.history,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    final lastEntry = history.last;
    final cyan = AppColors.cyanOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLightOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorderOf(context)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: cyan, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Son Eklenen: +${lastEntry.amountMl} ml',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryOf(context),
                    fontSize: 14,
                  ),
                ),
                Text(
                  lastEntry.label,
                  style: TextStyle(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: onUndo,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceOf(context),
              foregroundColor: AppColors.neonOrange,
              side: const BorderSide(color: AppColors.neonOrange),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: const Icon(Icons.undo_rounded, size: 18),
            label: const Text('Geri Al', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
