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
    );
  }
}
