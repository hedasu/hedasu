import 'package:flutter/material.dart';
import '../../habits/models/habit_model.dart';
import '../../../core/constants/app_colors.dart';

class CalendarHabitItem extends StatelessWidget {
  final HabitModel habit;

  const CalendarHabitItem({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: habit.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: habit.color, width: 4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            habit.icon,
            color: habit.color,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              habit.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: habit.color,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 18,
          ),
        ],
      ),
    );
  }
}
