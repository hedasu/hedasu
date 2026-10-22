import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../../../core/constants/app_colors.dart';
import 'purchase_button.dart';

class FoodCard extends StatelessWidget {
  final FoodModel food;
  final bool canAfford;
  final VoidCallback onBuy;

  const FoodCard({
    super.key,
    required this.food,
    required this.canAfford,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _FoodIconDisplay(emoji: food.emoji),
            const SizedBox(height: 8),
            Text(
              food.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            _FoodStatsBadge(satiety: food.satietyBoost, exp: food.expBoost),
            const Spacer(),
            PurchaseButton(
              price: food.priceInBadges,
              canAfford: canAfford,
              onPressed: onBuy,
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodIconDisplay extends StatelessWidget {
  final String emoji;

  const _FoodIconDisplay({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.darkMint.withValues(alpha: 0.12),
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 32)),
    );
  }
}

class _FoodStatsBadge extends StatelessWidget {
  final int satiety;
  final int exp;

  const _FoodStatsBadge({required this.satiety, required this.exp});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '+$satiety Doygunluk',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.accentOrange,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '+$exp XP',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.darkMint,
          ),
        ),
      ],
    );
  }
}
