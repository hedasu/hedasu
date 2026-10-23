import 'package:flutter/material.dart';

class HabitModel {
  final String id;
  final String title;
  final String target;
  final String category;
  final IconData icon;
  final Color color;
  final DateTime startDate;
  final int currentStreak;
  final int bestStreak;
  final List<DateTime> completedDates;
  final bool isArchived;

  const HabitModel({
    required this.id,
    required this.title,
    required this.target,
    required this.category,
    required this.icon,
    required this.color,
    required this.startDate,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.completedDates = const [],
    this.isArchived = false,
  });

  bool isCompletedOnDate(DateTime date) {
    return completedDates.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  bool get isCompletedToday {
    final now = DateTime.now();
    return isCompletedOnDate(now);
  }

  int get totalCompletedCount => completedDates.length;

  int get daysSinceStart {
    final now = DateTime.now();
    final diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(startDate.year, startDate.month, startDate.day))
        .inDays;
    return diff < 0 ? 1 : diff + 1;
  }

  String get dayCounterText => '$currentStreak. Gün';

  double get scientificGoalProgress => (currentStreak / 21).clamp(0.0, 1.0);

  String get scientificGoalText => '$currentStreak/21 Gün';

  HabitModel copyWith({
    String? id,
    String? title,
    String? target,
    String? category,
    IconData? icon,
    Color? color,
    DateTime? startDate,
    int? currentStreak,
    int? bestStreak,
    List<DateTime>? completedDates,
    bool? isArchived,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      target: target ?? this.target,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      startDate: startDate ?? this.startDate,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      completedDates: completedDates ?? this.completedDates,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
