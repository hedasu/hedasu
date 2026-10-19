import 'package:flutter/foundation.dart';
import '../models/workout.dart';

/// Egzersiz modülünün iş mantığını ve durumunu yöneten denetleyici (Controller).
/// Kırmızı çizgiler uyarınca saf Dart ve ChangeNotifier ile sayfa düzeyinde ağır setState önlenir.
class WorkoutController extends ChangeNotifier {
  WorkoutController({this.dailyCalorieGoal = 500});

  final int dailyCalorieGoal;
  final List<Workout> _workouts = [];

  List<Workout> get workouts => List.unmodifiable(_workouts);

  /// Toplam yakılan kalori
  int get totalCaloriesBurned {
    return _workouts.fold(0, (sum, item) => sum + item.caloriesBurned);
  }

  /// Toplam egzersiz süresi (dakika)
  int get totalDurationMinutes {
    return _workouts.fold(0, (sum, item) => sum + item.durationMinutes);
  }

  /// Kalori hedef oranı (0.0 - 1.0)
  double get calorieProgressRatio {
    if (dailyCalorieGoal <= 0) return 0.0;
    final ratio = totalCaloriesBurned / dailyCalorieGoal;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  /// Hedefe ulaşıldı mı?
  bool get isGoalAchieved => totalCaloriesBurned >= dailyCalorieGoal && dailyCalorieGoal > 0;

  /// Geri alma yapılabilir mi?
  bool get canUndo => _workouts.isNotEmpty;

  /// Hedef tamamlanınca verilen rozet başlığı
  String get badgeTitle => 'Kalori Canavarı';

  /// Rozet kazanıldı mı?
  bool get hasEarnedBadge => isGoalAchieved;

  /// Yeni egzersiz kaydı ekle
  void addWorkout({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    required String category,
  }) {
    final workout = Workout(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      category: category,
      timestamp: DateTime.now(),
    );
    _workouts.insert(0, workout);
    notifyListeners();
  }

  /// En son eklenen egzersizi geri al
  void undoLast() {
    if (_workouts.isNotEmpty) {
      _workouts.removeAt(0);
      notifyListeners();
    }
  }

  /// Egzersiz kaydını sil
  void removeWorkout(String id) {
    _workouts.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Günlük egzersizleri sıfırla
  void reset() {
    _workouts.clear();
    notifyListeners();
  }
}
