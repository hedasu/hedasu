import 'package:flutter/foundation.dart';
import '../models/badge_model.dart';

/// Rozet Durum Kontrolcüsü (ValueNotifier Tabanlı)
class BadgeController {
  final ValueNotifier<List<BadgeModel>> badges = ValueNotifier<List<BadgeModel>>([
    const BadgeModel(
      id: 'water_first',
      title: 'İlk Damla',
      description: 'Günün ilk su tüketimini kaydettin.',
      iconName: 'water_drop',
      category: 'water',
    ),
    const BadgeModel(
      id: 'water_goal',
      title: 'Hidrasyon Şampiyonu',
      description: 'Günlük su tüketim hedefine başarıyla ulaştın.',
      iconName: 'verified',
      category: 'water',
    ),
    const BadgeModel(
      id: 'workout_first',
      title: 'İlk Ter',
      description: 'İlk antrenmanını tamamlayıp sisteme işledin.',
      iconName: 'fitness_center',
      category: 'workout',
    ),
    const BadgeModel(
      id: 'workout_burn_500',
      title: 'Kalori Avcısı',
      description: 'Antrenmanlarda toplam 500 kcal yaktın.',
      iconName: 'local_fire_department',
      category: 'workout',
    ),
    const BadgeModel(
      id: 'double_champion',
      title: 'Çifte Şampiyon',
      description: 'Hem su hem de egzersiz hedeflerini tamamladın.',
      iconName: 'military_tech',
      category: 'special',
    ),
  ]);

  final ValueNotifier<String?> lastUnlockedBadgeNotification = ValueNotifier<String?>(null);

  int get unlockedCount => badges.value.where((b) => b.isUnlocked).length;
  int get totalCount => badges.value.length;
  double get progress => totalCount > 0 ? unlockedCount / totalCount : 0.0;

  void checkWaterBadges(int currentWater, int dailyGoal) {
    final updated = List<BadgeModel>.from(badges.value);
    bool changed = false;

    // İlk damla
    if (currentWater > 0) {
      changed |= _unlockBadge(updated, 'water_first');
    }

    // Su hedefi
    if (currentWater >= dailyGoal && dailyGoal > 0) {
      changed |= _unlockBadge(updated, 'water_goal');
    }

    if (changed) {
      badges.value = updated;
    }
  }

  void checkWorkoutBadges(int totalMinutes, int totalCalories, int dailyCalorieGoal) {
    final updated = List<BadgeModel>.from(badges.value);
    bool changed = false;

    // İlk antrenman
    if (totalMinutes > 0) {
      changed |= _unlockBadge(updated, 'workout_first');
    }

    // 500 kcal
    if (totalCalories >= 500) {
      changed |= _unlockBadge(updated, 'workout_burn_500');
    }

    if (changed) {
      badges.value = updated;
    }
  }

  void checkComboBadge(bool waterGoalMet, bool workoutGoalMet) {
    if (waterGoalMet && workoutGoalMet) {
      final updated = List<BadgeModel>.from(badges.value);
      if (_unlockBadge(updated, 'double_champion')) {
        badges.value = updated;
      }
    }
  }

  bool _unlockBadge(List<BadgeModel> list, String badgeId) {
    final index = list.indexWhere((b) => b.id == badgeId);
    if (index != -1 && !list[index].isUnlocked) {
      final unlocked = list[index].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      list[index] = unlocked;
      lastUnlockedBadgeNotification.value = unlocked.title;
      return true;
    }
    return false;
  }

  void clearNotification() {
    lastUnlockedBadgeNotification.value = null;
  }

  void dispose() {
    badges.dispose();
    lastUnlockedBadgeNotification.dispose();
  }
}
