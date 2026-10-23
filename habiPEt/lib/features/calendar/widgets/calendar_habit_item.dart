import 'package:flutter/material.dart';
import '../../habits/models/habit_model.dart';
import '../../../core/constants/app_colors.dart';

class CalendarHabitItem extends StatelessWidget {
  final HabitModel habit;

  const CalendarHabitItem({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final cardBg = AppColors.getHabitCardBackground(habit.id, habit.color);
    final tagBg = AppColors.getHabitTagBackground(habit.id, habit.color);
    final textIconColor = AppColors.getHabitTextAndIconColor(habit.id, habit.color);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: textIconColor, width: 4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            habit.icon,
            color: textIconColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    habit.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textIconColor,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: tagBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${habit.currentStreak}. Gün',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: textIconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            color: textIconColor.withValues(alpha: 0.85),
            size: 18,
          ),
        ],
      ),
    );
  }
}
