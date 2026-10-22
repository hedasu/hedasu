import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FeedingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FeedingButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accentOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 6),
        ),
        onPressed: onPressed,
        child: const Text(
          'Besle',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
