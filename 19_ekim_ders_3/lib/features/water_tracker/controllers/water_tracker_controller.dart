import 'package:flutter/foundation.dart';
import '../../badges/controllers/badge_controller.dart';
import '../models/water_entry_model.dart';

/// Su Takip Durum Kontrolcüsü (ValueNotifier + Geri Alma / Undo Desteği)
class WaterTrackerController {
  final BadgeController? badgeController;
  final int dailyGoalWater;

  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final ValueNotifier<List<WaterEntryModel>> history =
      ValueNotifier<List<WaterEntryModel>>([]);

  WaterTrackerController({
    this.badgeController,
    this.dailyGoalWater = 2500, // 2.5 Litre standart sporcu hedefi
  });

  bool get canUndo => history.value.isNotEmpty;
  double get progressRatio =>
      dailyGoalWater > 0 ? (currentWater.value / dailyGoalWater).clamp(0.0, 1.0) : 0.0;

  /// Hızlı su ekleme
  void addWater(int amountMl, {String label = 'Su'}) {
    if (amountMl <= 0) return;

    final newEntry = WaterEntryModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
      label: label,
    );

    currentWater.value += amountMl;
    history.value = [...history.value, newEntry];

    // Rozet kontrolü
    badgeController?.checkWaterBadges(currentWater.value, dailyGoalWater);
  }

  /// Son su tüketimini geri alma (Undo)
  bool undoLastWater() {
    if (history.value.isEmpty) return false;

    final updated = List<WaterEntryModel>.from(history.value);
    final removed = updated.removeLast();

    currentWater.value = (currentWater.value - removed.amountMl).clamp(0, 99999);
    history.value = updated;

    return true;
  }

  /// Sıfırlama
  void resetWater() {
    currentWater.value = 0;
    history.value = [];
  }

  void dispose() {
    currentWater.dispose();
    history.dispose();
  }
}
