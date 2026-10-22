import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WelcomeDialog extends StatelessWidget {
  final int currentStreak;
  final String petName;
  final String? recentBadgeTitle;
  final VoidCallback onDismiss;

  const WelcomeDialog({
    super.key,
    required this.currentStreak,
    required this.petName,
    this.recentBadgeTitle,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _DialogHeaderIcon(),
            const SizedBox(height: 16),
            const Text(
              'Hoş Geldiniz!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            _MotivationalMessage(
              currentStreak: currentStreak,
              petName: petName,
              recentBadgeTitle: recentBadgeTitle,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onDismiss,
                child: const Text('Hadi Başlayalım! 🚀'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogHeaderIcon extends StatelessWidget {
  const _DialogHeaderIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.darkMint, AppColors.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkMint.withValues(alpha: 0.35),
            blurRadius: 18,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Text('🎉', style: TextStyle(fontSize: 36)),
    );
  }
}

class _MotivationalMessage extends StatelessWidget {
  final int currentStreak;
  final String petName;
  final String? recentBadgeTitle;

  const _MotivationalMessage({
    required this.currentStreak,
    required this.petName,
    this.recentBadgeTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Bugün $currentStreak. gününüz, harika ilerliyorsunuz!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.darkMint,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$petName seni gördüğüne çok sevindi. Bugünün hedeflerini tamamla ve dostuna yiyecek kazan!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).textTheme.bodySmall?.color,
            height: 1.35,
          ),
        ),
        if (recentBadgeTitle != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accentGold.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  'Özel Başarı: $recentBadgeTitle',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentGold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
