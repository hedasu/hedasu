import 'package:flutter/foundation.dart';
import '../../water_tracker/controller/water_tracker_controller.dart';
import '../../workout/controller/workout_controller.dart';
import '../models/badge_item.dart';

/// Rozetler modülünün iş mantığını yöneten denetleyici (Controller).
/// Su ve egzersiz denetleyicilerini dinleyerek rozetlerin kazanım durumunu günceller.
class BadgeController extends ChangeNotifier {
  BadgeController({
    required this.waterController,
    required this.workoutController,
  }) {
    waterController.addListener(_onDependenciesUpdated);
    workoutController.addListener(_onDependenciesUpdated);
  }

  final WaterTrackerController waterController;
  final WorkoutController workoutController;

  void _onDependenciesUpdated() {
    notifyListeners();
  }

  @override
  void dispose() {
    waterController.removeListener(_onDependenciesUpdated);
    workoutController.removeListener(_onDependenciesUpdated);
    super.dispose();
  }

  /// Tüm rozet listesi ve güncel kilit durumları
  List<BadgeItem> get badges {
    final isWaterAchieved = waterController.isGoalAchieved;
    final isWorkoutAchieved = workoutController.isGoalAchieved;
    final hasWaterLogs = waterController.currentIntakeMl > 0;
    final has30MinWorkout = workoutController.totalDurationMinutes >= 30;

    return [
      BadgeItem(
        id: 'hidrasyon_sampiyonu',
        title: 'Hidrasyon Şampiyonu',
        description: 'Günlük 2500 ml su hedefini başarıyla tamamla.',
        iconEmoji: '💧',
        category: BadgeCategory.water,
        isUnlocked: isWaterAchieved,
        progress: waterController.progressRatio,
        requirementText: '${waterController.currentIntakeMl} / ${waterController.dailyGoalMl} ml',
      ),
      BadgeItem(
        id: 'ilk_yudum',
        title: 'İlk Yudum',
        description: 'Güne zinde başla ve günün ilk su kaydını oluştur.',
        iconEmoji: '🥤',
        category: BadgeCategory.water,
        isUnlocked: hasWaterLogs,
        progress: hasWaterLogs ? 1.0 : 0.0,
        requirementText: hasWaterLogs ? 'Tamamlandı' : '1 Bardak Su İç',
      ),
      BadgeItem(
        id: 'kalori_canavari',
        title: 'Kalori Canavarı',
        description: 'Günlük 500 kcal yakım hedefine başarıyla ulaş.',
        iconEmoji: '🔥',
        category: BadgeCategory.workout,
        isUnlocked: isWorkoutAchieved,
        progress: workoutController.calorieProgressRatio,
        requirementText: '${workoutController.totalCaloriesBurned} / ${workoutController.dailyCalorieGoal} kcal',
      ),
      BadgeItem(
        id: 'demir_adam',
        title: 'Demir Adam',
        description: 'Günde toplam en az 30 dakika antrenman yap.',
        iconEmoji: '🏋️',
        category: BadgeCategory.workout,
        isUnlocked: has30MinWorkout,
        progress: (workoutController.totalDurationMinutes / 30).clamp(0.0, 1.0),
        requirementText: '${workoutController.totalDurationMinutes} / 30 dk',
      ),
      BadgeItem(
        id: 'cifte_sampiyon',
        title: 'Çifte Şampiyon',
        description: 'Hem su hedefini hem de egzersiz hedefini aynı gün tamamla!',
        iconEmoji: '👑',
        category: BadgeCategory.general,
        isUnlocked: isWaterAchieved && isWorkoutAchieved,
        progress: (isWaterAchieved ? 0.5 : 0.0) + (isWorkoutAchieved ? 0.5 : 0.0),
        requirementText: isWaterAchieved && isWorkoutAchieved
            ? 'Tüm Hedefler Başarıldı!'
            : 'Su & Egzersiz Hedefini Bitir',
      ),
    ];
  }

  /// Toplam kazanılan rozet sayısı
  int get unlockedCount => badges.where((b) => b.isUnlocked).length;

  /// Toplam rozet sayısı
  int get totalCount => badges.length;

  /// Kazanım oranı (0.0 - 1.0)
  double get unlockRatio => totalCount > 0 ? unlockedCount / totalCount : 0.0;
}
