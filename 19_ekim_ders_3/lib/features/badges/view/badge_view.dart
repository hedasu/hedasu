import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/badge_controller.dart';
import '../models/badge_model.dart';
import '../widgets/badge_card.dart';
import '../widgets/badge_stats_header.dart';

/// Rozet Vitrini Görünümü (Stateless & ValueListenableBuilder)
class BadgeView extends StatelessWidget {
  final BadgeController controller;

  const BadgeView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<BadgeModel>>(
      valueListenable: controller.badges,
      builder: (context, badgeList, _) {
        final unlocked = controller.unlockedCount;
        final total = controller.totalCount;
        final progress = controller.progress;

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            BadgeStatsHeader(
              unlockedCount: unlocked,
              totalCount: total,
              progress: progress,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tüm Rozetler',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _BadgeGrid(badges: badgeList),
          ],
        );
      },
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  final List<BadgeModel> badges;

  const _BadgeGrid({required this.badges});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: badges.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        return BadgeCard(badge: badges[index]);
      },
    );
  }
}
