import 'package:flutter/material.dart';
import '../controller/badge_controller.dart';
import '../widgets/badge_card.dart';
import '../widgets/badge_summary_header.dart';

/// Kazanılan ve hedeflenen rozetlerin görüntülendiği ana görünüm (View).
/// Kırmızı çizgiler uyarınca build metodu kısa tutulmuş, alt bileşenlere delege edilmiştir.
class BadgeView extends StatelessWidget {
  const BadgeView({
    super.key,
    required this.controller,
  });

  final BadgeController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final badges = controller.badges;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BadgeSummaryHeader(
                unlockedCount: controller.unlockedCount,
                totalCount: controller.totalCount,
                ratio: controller.unlockRatio,
              ),
              const SizedBox(height: 20),
              const Text(
                'Tüm Başarılar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: badges.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) => BadgeCard(badge: badges[index]),
              ),
            ],
          ),
        );
      },
    );
  }
}
