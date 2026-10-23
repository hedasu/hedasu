import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../repository/habit_repository.dart';

class HabitController extends ChangeNotifier {
  final HabitRepository _repository;
  late List<HabitModel> _habits;

  HabitController({HabitRepository? repository})
      : _repository = repository ?? HabitRepository() {
    _habits = _repository.getPreloadedHabits();
  }

  /// Aktif (silinmemiş) alışkanlıklar - Alışkanlıklarım, Bugünün Görevleri ve sayaçlar için
  List<HabitModel> get habits =>
      List.unmodifiable(_habits.where((h) => !h.isArchived).toList());

  /// Tüm alışkanlıklar ve geçmiş tamamlanma kayıtları (Silinenlerin geçmişi dahil) - Takvim ve Ajanda için
  List<HabitModel> get allHabitsWithHistory => List.unmodifiable(_habits);

  int get habitCount => habits.length;

  int get maxStreak {
    if (habits.isEmpty) return 0;
    return habits
        .map((h) => h.currentStreak)
        .reduce((a, b) => a > b ? a : b);
  }

  int get completedTodayCount {
    return habits.where((h) => h.isCompletedToday).length;
  }

  double get todayProgress {
    if (habits.isEmpty) return 0.0;
    return completedTodayCount / habits.length;
  }

  void addHabit({
    required String title,
    required String target,
    required String category,
    required IconData icon,
    required Color color,
  }) {
    final newHabit = HabitModel(
      id: 'habit_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      target: target,
      category: category,
      icon: icon,
      color: color,
      startDate: DateTime.now(),
      currentStreak: 0,
      bestStreak: 0,
      completedDates: const [],
    );

    _habits = [..._habits, newHabit];
    notifyListeners();
  }

  void toggleHabitCompletion(String habitId, DateTime date) {
    _habits = _habits.map((habit) {
      if (habit.id != habitId) return habit;

      final isAlreadyCompleted = habit.isCompletedOnDate(date);
      List<DateTime> updatedDates;
      int newStreak = habit.currentStreak;

      if (isAlreadyCompleted) {
        updatedDates = habit.completedDates
            .where((d) => !(d.year == date.year && d.month == date.month && d.day == date.day))
            .toList();
        newStreak = (newStreak - 1).clamp(0, 9999);
      } else {
        updatedDates = [...habit.completedDates, date];
        newStreak += 1;
      }

      final newBest = newStreak > habit.bestStreak ? newStreak : habit.bestStreak;

      return habit.copyWith(
        completedDates: updatedDates,
        currentStreak: newStreak,
        bestStreak: newBest,
      );
    }).toList();

    notifyListeners();
  }

  /// Alışkanlığı siler: Aktif listelerden kaldırır ancak geçmiş günlerdeki takvim/ajanda kayıtlarını korur
  void deleteHabit(String habitId) {
    _habits = _habits.map((habit) {
      if (habit.id == habitId) {
        return habit.copyWith(isArchived: true);
      }
      return habit;
    }).toList();
    notifyListeners();
  }
}
