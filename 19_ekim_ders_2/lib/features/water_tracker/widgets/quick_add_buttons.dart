import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Hızlı Su Ekleme Butonları (Temaya Duyarlı)
class QuickAddButtons extends StatelessWidget {
  final void Function(int amount, String label) onAddWater;

  const QuickAddButtons({
    super.key,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hızlı Su Ekle',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickButton(
                amount: 200,
                label: 'Bardak',
                icon: Icons.local_drink_rounded,
                onTap: () => onAddWater(200, 'Bardak (200ml)'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickButton(
                amount: 330,
                label: 'K. Şişe',
                icon: Icons.water_drop_outlined,
                onTap: () => onAddWater(330, 'Küçük Şişe (330ml)'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickButton(
                amount: 500,
                label: 'Matara',
                icon: Icons.sports_gymnastics_rounded,
                onTap: () => onAddWater(500, 'Spor Matarası (500ml)'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickButton(
                amount: 1000,
                label: '1 Litre',
                icon: Icons.fitness_center_rounded,
                onTap: () => onAddWater(1000, 'Sürahi (1000ml)'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickButton extends StatelessWidget {
  final int amount;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickButton({
    required this.amount,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cyan = AppColors.cyanOf(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceBorderOf(context)),
        ),
        child: Column(
          children: [
            Icon(icon, color: cyan, size: 22),
            const SizedBox(height: 4),
            Text(
              '+$amount',
              style: TextStyle(
                color: cyan,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondaryOf(context),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
