import 'package:flutter/material.dart';
import '../controller/water_tracker_controller.dart';
import '../widgets/quick_water_actions.dart';
import '../widgets/water_goal_badge.dart';
import '../widgets/water_log_history.dart';
import '../widgets/water_progress_card.dart';

/// Su takip modülü ana ekran görünümü.
/// Kırmızı çizgiler uyarınca build metodu kısa tutulmuş, alt bileşenlere delege edilmiştir.
class WaterTrackerView extends StatelessWidget {
  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WaterProgressCard(
                currentMl: controller.currentIntakeMl,
                goalMl: controller.dailyGoalMl,
                progressRatio: controller.progressRatio,
                isGoalAchieved: controller.isGoalAchieved,
              ),
              const SizedBox(height: 14),
              WaterGoalBadge(
                isAchieved: controller.isGoalAchieved,
                badgeTitle: controller.badgeTitle,
                remainingMl: controller.remainingMl,
              ),
              const SizedBox(height: 20),
              QuickWaterActions(
                onAddWater: (amount, label) => controller.addWater(amount, label: label),
                onDecreaseWater: (amount, label) => controller.decreaseWater(amount, label: label),
                onUndoLast: controller.undoLast,
                onReset: controller.reset,
                canDecrease: controller.canDecrease,
              ),
              const SizedBox(height: 20),
              const Text(
                'Bugünkü Kayıtlar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              WaterLogHistory(
                logs: controller.logs,
                onDeleteLog: controller.removeLog,
              ),
            ],
          ),
        );
      },
    );
  }
}
