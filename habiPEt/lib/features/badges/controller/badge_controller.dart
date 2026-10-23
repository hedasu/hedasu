import 'package:flutter/material.dart';
import '../models/badge_model.dart';
import '../repository/badge_repository.dart';
import '../../habits/models/habit_model.dart';

class BadgeController extends ChangeNotifier {
  final BadgeRepository _repository;
  late List<BadgeModel> _badges;
  List<HabitModel> _cachedHabits = [];
  int _totalBadgeCoins = 185; // Initial coin balance
  BadgeCategory? _selectedCategory;
  String? _selectedHabitId; // null = Tüm Alışkanlıklar

  BadgeController({BadgeRepository? repository})
      : _repository = repository ?? BadgeRepository() {
    _badges = _repository.getInitialBadges();
  }

  List<BadgeModel> get allBadges => List.unmodifiable(_badges);
  int get totalBadgeCoins => _totalBadgeCoins;
  BadgeCategory? get selectedCategory => _selectedCategory;
  String? get selectedHabitId => _selectedHabitId;
  List<HabitModel> get cachedHabits => List.unmodifiable(_cachedHabits);

  List<BadgeModel> get filteredBadges {
    if (_selectedCategory == null) return _badges;
    return _badges.where((b) => b.category == _selectedCategory).toList();
  }

  int get unlockedCount => _badges.where((b) => b.isUnlocked).length;
  int get totalCount => _badges.length;

  HabitModel? get selectedHabit {
    if (_selectedHabitId == null) return null;
    final matches = _cachedHabits.where((h) => h.id == _selectedHabitId);
    return matches.isNotEmpty ? matches.first : null;
  }

  BadgeModel get special21Badge {
    return _badges.firstWhere(
      (b) => b.id == 'special_21_days',
      orElse: () => _badges.first,
    );
  }

  void filterCategory(BadgeCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void selectHabit(String? habitId) {
    _selectedHabitId = habitId;
    if (_cachedHabits.isNotEmpty) {
      _applyProgress(_cachedHabits);
    }
    notifyListeners();
  }

  void addCoins(int amount) {
    if (amount <= 0) return;
    _totalBadgeCoins += amount;
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (amount <= 0 || _totalBadgeCoins < amount) {
      return false;
    }
    _totalBadgeCoins -= amount;
    notifyListeners();
    return true;
  }

  void syncProgressWithHabits({
    required List<HabitModel> habits,
    String? selectedHabitId,
  }) {
    _cachedHabits = habits;
    if (selectedHabitId != null) {
      _selectedHabitId = selectedHabitId;
    }
    _applyProgress(habits);
    notifyListeners();
  }

  void _applyProgress(List<HabitModel> habits) {
    final now = DateTime.now();
    final habitCount = habits.length;
    final completedTodayCount = habits.where((h) => h.isCompletedToday).length;

    // Determine streak to use: individual habit streak or global max streak
    final targetHabit = selectedHabit;
    final activeStreak = targetHabit != null
        ? targetHabit.currentStreak
        : (habits.isEmpty
            ? 0
            : habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b));

    _badges = _badges.map((badge) {
      int newCurrentDays = badge.currentDays;
      bool newlyUnlocked = badge.isUnlocked;

      if (badge.id.startsWith('multi_habit_') &&
          badge.id != 'multi_habit_dual_done' &&
          badge.id != 'multi_habit_all_done') {
        newCurrentDays = habitCount.clamp(0, badge.targetDays);
        newlyUnlocked = habitCount >= badge.targetDays;
      } else if (badge.id == 'multi_habit_dual_done') {
        newCurrentDays = completedTodayCount.clamp(0, 2);
        newlyUnlocked = completedTodayCount >= 2;
      } else if (badge.id == 'multi_habit_all_done') {
        newCurrentDays =
            (habitCount >= 2 && completedTodayCount == habitCount) ? 1 : 0;
        newlyUnlocked =
            (habitCount >= 2 && completedTodayCount == habitCount);
      } else if (badge.category != BadgeCategory.multiHabit &&
          badge.id != 'special_start') {
        // Individual habit day tracking or global highest day tracking
        newCurrentDays = activeStreak.clamp(0, badge.targetDays);
        newlyUnlocked = activeStreak >= badge.targetDays;
      }

      // Check if newly unlocked for coin rewards
      if (newlyUnlocked && !badge.isUnlocked) {
        _totalBadgeCoins += badge.rewardCoins;
      }

      return badge.copyWith(
        currentDays: newCurrentDays,
        isUnlocked: newlyUnlocked,
        unlockedDate:
            newlyUnlocked && badge.unlockedDate == null ? now : badge.unlockedDate,
        habitId: targetHabit?.id,
        habitTitle: targetHabit?.title,
      );
    }).toList();
  }
}
