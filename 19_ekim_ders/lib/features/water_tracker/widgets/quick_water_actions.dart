import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Hızlı su ekleme ve yanlışlıkla ekleme durumu için azaltma/geri alma butonları.
class QuickWaterActions extends StatelessWidget {
  const QuickWaterActions({
    super.key,
    required this.onAddWater,
    required this.onDecreaseWater,
    required this.onUndoLast,
    required this.onReset,
    required this.canDecrease,
  });

  final void Function(int amountMl, String label) onAddWater;
  final void Function(int amountMl, String label) onDecreaseWater;
  final VoidCallback onUndoLast;
  final VoidCallback onReset;
  final bool canDecrease;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 10),
        _buildAddPresets(context),
        const SizedBox(height: 14),
        _buildDecreaseSection(context),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Hızlı Ekle',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: canDecrease ? onUndoLast : null,
              icon: Icon(
                Icons.undo_rounded,
                size: 16,
                color: canDecrease ? AppColors.neonOrange : AppColors.textMuted,
              ),
              label: Text(
                'Geri Al',
                style: TextStyle(
                  fontSize: 12,
                  color: canDecrease ? AppColors.neonOrange : AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(width: 4),
            TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.textMuted),
              label: const Text(
                'Sıfırla',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddPresets(BuildContext context) {
    return Row(
      children: [
        _buildPresetButton(
          amount: 200,
          title: '+200 ml',
          icon: Icons.local_drink_outlined,
          label: 'Bardak',
          color: AppColors.neonCyan,
          onTap: () => onAddWater(200, 'Bardak'),
        ),
        const SizedBox(width: 8),
        _buildPresetButton(
          amount: 350,
          title: '+350 ml',
          icon: Icons.coffee_outlined,
          label: 'Büyük Kupa',
          color: AppColors.neonCyan,
          onTap: () => onAddWater(350, 'Büyük Kupa'),
        ),
        const SizedBox(width: 8),
        _buildPresetButton(
          amount: 500,
          title: '+500 ml',
          icon: Icons.sports_gymnastics_rounded,
          label: 'Matara',
          color: AppColors.neonCyan,
          onTap: () => onAddWater(500, 'Matara'),
        ),
        const SizedBox(width: 8),
        _buildPresetButton(
          amount: 1000,
          title: '+1000 ml',
          icon: Icons.battery_charging_full_rounded,
          label: 'Sürahi',
          color: AppColors.neonCyan,
          onTap: () => onAddWater(1000, 'Sürahi'),
        ),
      ],
    );
  }

  Widget _buildDecreaseSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Yanlış Ekleme / Azaltma',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPresetButton(
              amount: 100,
              title: '-100 ml',
              icon: Icons.remove_circle_outline_rounded,
              label: 'Azalt',
              color: canDecrease ? AppColors.neonOrange : AppColors.textMuted,
              onTap: canDecrease ? () => onDecreaseWater(100, 'Yanlış Ekleme Düzeltmesi') : null,
            ),
            const SizedBox(width: 8),
            _buildPresetButton(
              amount: 200,
              title: '-200 ml',
              icon: Icons.remove_circle_outline_rounded,
              label: 'Düzelt',
              color: canDecrease ? AppColors.neonOrange : AppColors.textMuted,
              onTap: canDecrease ? () => onDecreaseWater(200, 'Yanlış Ekleme Düzeltmesi') : null,
            ),
            const SizedBox(width: 8),
            _buildPresetButton(
              amount: 350,
              title: '-350 ml',
              icon: Icons.remove_circle_outline_rounded,
              label: 'Düzelt',
              color: canDecrease ? AppColors.neonOrange : AppColors.textMuted,
              onTap: canDecrease ? () => onDecreaseWater(350, 'Yanlış Ekleme Düzeltmesi') : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: canDecrease ? onUndoLast : null,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: canDecrease
                            ? AppColors.neonOrange.withValues(alpha: 0.5)
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          color: canDecrease ? AppColors.neonOrange : AppColors.textMuted,
                          size: 20,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Son Kayıt',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: canDecrease ? AppColors.textPrimary : AppColors.textMuted,
                          ),
                        ),
                        Text(
                          'İptal Et',
                          style: TextStyle(
                            fontSize: 10,
                            color: canDecrease ? AppColors.neonOrange : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetButton({
    required int amount,
    required String title,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: onTap != null ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
