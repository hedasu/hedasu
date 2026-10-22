import 'package:flutter/material.dart';
import '../models/calendar_day_model.dart';
import '../../habits/models/habit_model.dart';
import '../../badges/models/badge_model.dart';

class CalendarController extends ChangeNotifier {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;

  CalendarController() {
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _displayedMonth = DateTime(now.year, now.month, 1);
  }

  DateTime get selectedDate => _selectedDate;
  DateTime get displayedMonth => _displayedMonth;

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  void previousMonth() {
    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    notifyListeners();
  }

  void nextMonth() {
    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    notifyListeners();
  }

  List<CalendarDayModel> generateMonthDays({
    required List<HabitModel> habits,
    required List<BadgeModel> badges,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final firstDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;

    // Monday as first day of week (weekday 1 = Monday in Dart)
    final startingWeekdayOffset = firstDayOfMonth.weekday - 1; // 0 for Monday

    final List<CalendarDayModel> dayModels = [];

    // Leading padding days from previous month
    for (int i = startingWeekdayOffset - 1; i >= 0; i--) {
      final prevDate = firstDayOfMonth.subtract(Duration(days: i + 1));
      dayModels.add(_buildDayModel(prevDate, false, today, habits, badges));
    }

    // Days in current month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
      dayModels.add(_buildDayModel(date, true, today, habits, badges));
    }

    // Trailing padding days to fill 7-column grid up to multiples of 7
    final remainingDays = (7 - (dayModels.length % 7)) % 7;
    for (int i = 1; i <= remainingDays; i++) {
      final nextDate = DateTime(_displayedMonth.year, _displayedMonth.month + 1, i);
      dayModels.add(_buildDayModel(nextDate, false, today, habits, badges));
    }

    return dayModels;
  }

  CalendarDayModel _buildDayModel(
    DateTime date,
    bool isCurrentMonth,
    DateTime today,
    List<HabitModel> habits,
    List<BadgeModel> badges,
  ) {
    final completed = habits.where((h) => h.isCompletedOnDate(date)).toList();
    final earned = badges.where((b) {
      if (b.unlockedDate == null) return false;
      final u = b.unlockedDate!;
      return u.year == date.year && u.month == date.month && u.day == date.day;
    }).toList();

    return CalendarDayModel(
      date: date,
      isCurrentMonth: isCurrentMonth,
      isToday: date.year == today.year && date.month == today.month && date.day == today.day,
      completedHabits: completed,
      badgesEarned: earned,
    );
  }
}
