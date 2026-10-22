import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PurchaseButton extends StatelessWidget {
  final int price;
  final bool canAfford;
  final VoidCallback onPressed;

  const PurchaseButton({
    super.key,
    required this.price,
    required this.canAfford,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: canAfford
              ? AppColors.darkMint
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          foregroundColor: canAfford ? Colors.black : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onPressed: canAfford ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🪙', style: TextStyle(fontSize: 13)),
            const SizedBox(width: 4),
            Text(
              '$price Rozet',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
