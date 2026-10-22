import 'package:flutter/material.dart';
import '../models/badge_model.dart';
import '../repository/badge_repository.dart';

class BadgeController extends ChangeNotifier {
  final BadgeRepository _repository;
  late List<BadgeModel> _badges;
  int _totalBadgeCoins = 185; // Initial coin balance from completed streak
  BadgeCategory? _selectedCategory;

  BadgeController({BadgeRepository? repository})
      : _repository = repository ?? BadgeRepository() {
    _badges = _repository.getInitialBadges();
  }

  List<BadgeModel> get allBadges => List.unmodifiable(_badges);
  int get totalBadgeCoins => _totalBadgeCoins;
  BadgeCategory? get selectedCategory => _selectedCategory;

  List<BadgeModel> get filteredBadges {
    if (_selectedCategory == null) return _badges;
    return _badges.where((b) => b.category == _selectedCategory).toList();
  }

  int get unlockedCount => _badges.where((b) => b.isUnlocked).length;
  int get totalCount => _badges.length;

  void filterCategory(BadgeCategory? category) {
    _selectedCategory = category;
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
    required int maxStreak,
    required int habitCount,
  }) {
    bool hasChanges = false;
    final now = DateTime.now();

    final updated = _badges.map((badge) {
      int newCurrentDays = badge.currentDays;
      bool newlyUnlocked = badge.isUnlocked;

      if (badge.id.startsWith('special_habit_')) {
        newCurrentDays = habitCount.clamp(0, badge.targetDays);
        if (newCurrentDays >= badge.targetDays && !badge.isUnlocked) {
          newlyUnlocked = true;
          _totalBadgeCoins += badge.rewardCoins;
          hasChanges = true;
        }
      } else {
        newCurrentDays = maxStreak.clamp(0, badge.targetDays);
        if (newCurrentDays >= badge.targetDays && !badge.isUnlocked) {
          newlyUnlocked = true;
          _totalBadgeCoins += badge.rewardCoins;
          hasChanges = true;
        }
      }

      if (newCurrentDays != badge.currentDays || newlyUnlocked != badge.isUnlocked) {
        hasChanges = true;
        return badge.copyWith(
          currentDays: newCurrentDays,
          isUnlocked: newlyUnlocked,
          unlockedDate: newlyUnlocked && badge.unlockedDate == null
              ? now
              : badge.unlockedDate,
        );
      }
      return badge;
    }).toList();

    if (hasChanges) {
      _badges = updated;
      notifyListeners();
    }
  }
}
