import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PetAgeIndicator extends StatelessWidget {
  final String formattedAge;

  const PetAgeIndicator({
    super.key,
    required this.formattedAge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accentGold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cake_outlined,
            size: 14,
            color: AppColors.accentGold,
          ),
          const SizedBox(width: 4),
          Text(
            formattedAge,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.accentGold,
            ),
          ),
        ],
      ),
    );
  }
}
