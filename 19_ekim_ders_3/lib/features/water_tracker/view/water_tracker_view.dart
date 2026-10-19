import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_entry_model.dart';
import '../widgets/quick_add_buttons.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/water_undo_section.dart';

/// Su Takibi Ana Görünümü (Stateless & ValueListenableBuilder)
class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller.currentWater,
      builder: (context, currentWater, _) {
        return ValueListenableBuilder<List<WaterEntryModel>>(
          valueListenable: controller.history,
          builder: (context, history, _) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                WaterProgressCard(
                  currentWater: currentWater,
                  dailyGoal: controller.dailyGoalWater,
                ),
                const SizedBox(height: 16),
                WaterUndoSection(
                  history: history,
                  onUndo: () => _handleUndo(context),
                ),
                const SizedBox(height: 20),
                QuickAddButtons(
                  onAddWater: (amount, label) {
                    controller.addWater(amount, label: label);
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }

  void _handleUndo(BuildContext context) {
    final success = controller.undoLastWater();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Son su tüketimi başarıyla geri alındı.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
