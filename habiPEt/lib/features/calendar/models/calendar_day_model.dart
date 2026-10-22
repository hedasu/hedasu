import '../../habits/models/habit_model.dart';
import '../../badges/models/badge_model.dart';

class CalendarDayModel {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final List<HabitModel> completedHabits;
  final List<BadgeModel> badgesEarned;

  const CalendarDayModel({
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    this.completedHabits = const [],
    this.badgesEarned = const [],
  });

  bool get hasActivity => completedHabits.isNotEmpty || badgesEarned.isNotEmpty;
}
