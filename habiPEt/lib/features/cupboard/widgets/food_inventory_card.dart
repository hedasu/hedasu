import 'package:flutter/material.dart';
import '../models/cupboard_item_model.dart';
import '../../../core/constants/app_colors.dart';
import 'feeding_button.dart';

class FoodInventoryCard extends StatelessWidget {
  final CupboardItemModel item;
  final VoidCallback onFeed;

  const FoodInventoryCard({
    super.key,
    required this.item,
    required this.onFeed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _ItemHeaderRow(emoji: item.food.emoji, quantity: item.quantity),
            const SizedBox(height: 8),
            Text(
              item.food.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              '+${item.food.expBoost} XP',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.darkMint,
              ),
            ),
            const Spacer(),
            FeedingButton(onPressed: onFeed),
          ],
        ),
      ),
    );
  }
}

class _ItemHeaderRow extends StatelessWidget {
  final String emoji;
  final int quantity;

  const _ItemHeaderRow({required this.emoji, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.darkMint.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(emoji, style: const TextStyle(fontSize: 28)),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accentOrange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'x$quantity',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
