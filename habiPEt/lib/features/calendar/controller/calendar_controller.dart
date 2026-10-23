import 'package:flutter/material.dart';
import '../../../core/extensions/date_extensions.dart';
import '../models/calendar_day_model.dart';
import '../../habits/models/habit_model.dart';
import '../../badges/models/badge_model.dart';

enum CalendarViewMode { monthly, weekly, agenda }

class CalendarController extends ChangeNotifier {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  CalendarViewMode _viewMode = CalendarViewMode.monthly;

  CalendarController() {
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _displayedMonth = DateTime(now.year, now.month, 1);
  }

  DateTime get selectedDate => _selectedDate;
  DateTime get displayedMonth => _displayedMonth;
  CalendarViewMode get viewMode => _viewMode;

  void setViewMode(CalendarViewMode mode) {
    if (_viewMode != mode) {
      _viewMode = mode;
      notifyListeners();
    }
  }

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    if (_displayedMonth.month != date.month || _displayedMonth.year != date.year) {
      _displayedMonth = DateTime(date.year, date.month, 1);
    }
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

  void previousPeriod() {
    if (_viewMode == CalendarViewMode.weekly) {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
      notifyListeners();
    } else {
      previousMonth();
    }
  }

  void nextPeriod() {
    if (_viewMode == CalendarViewMode.weekly) {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
      _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
      notifyListeners();
    } else {
      nextMonth();
    }
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

  List<CalendarDayModel> generateWeekDays({
    required List<HabitModel> habits,
    required List<BadgeModel> badges,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final mondayOffset = _selectedDate.weekday - 1;
    final monday = _selectedDate.subtract(Duration(days: mondayOffset));

    return List.generate(7, (index) {
      final date = monday.add(Duration(days: index));
      final isCurrentMonth = date.month == _displayedMonth.month;
      return _buildDayModel(date, isCurrentMonth, today, habits, badges);
    });
  }

  List<CalendarDayModel> generateAgendaDays({
    required List<HabitModel> habits,
    required List<BadgeModel> badges,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;

    final List<CalendarDayModel> agendaDays = [];
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
      final model = _buildDayModel(date, true, today, habits, badges);
      if (model.hasActivity || model.isToday || date.isSameDay(_selectedDate)) {
        agendaDays.add(model);
      }
    }
    return agendaDays;
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
