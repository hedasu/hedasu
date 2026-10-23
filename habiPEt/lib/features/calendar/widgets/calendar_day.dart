import 'package:flutter/material.dart';
import '../models/calendar_day_model.dart';
import '../../../core/constants/app_colors.dart';

class CalendarDay extends StatelessWidget {
  final CalendarDayModel dayModel;
  final bool isSelected;
  final VoidCallback onTap;

  const CalendarDay({
    super.key,
    required this.dayModel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : (dayModel.isToday
                    ? primaryColor
                    : Colors.transparent),
            width: isSelected || dayModel.isToday ? 1.5 : 0,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _DayNumberText(dayModel: dayModel, isSelected: isSelected),
            const SizedBox(height: 3),
            _HabitDotsRow(dayModel: dayModel),
          ],
        ),
      ),
    );
  }
}

class _DayNumberText extends StatelessWidget {
  final CalendarDayModel dayModel;
  final bool isSelected;

  const _DayNumberText({required this.dayModel, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    final textColor = !dayModel.isCurrentMonth
        ? Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.35)
        : (isSelected
            ? primaryColor
            : (dayModel.isToday
                ? primaryColor
                : Theme.of(context).textTheme.bodyMedium?.color));

    return Text(
      '${dayModel.date.day}',
      style: TextStyle(
        fontSize: 13,
        fontWeight: dayModel.isToday || isSelected
            ? FontWeight.w800
            : FontWeight.w600,
        color: textColor,
      ),
    );
  }
}

class _HabitDotsRow extends StatelessWidget {
  final CalendarDayModel dayModel;

  const _HabitDotsRow({required this.dayModel});

  @override
  Widget build(BuildContext context) {
    if (dayModel.completedHabits.isEmpty && dayModel.badgesEarned.isEmpty) {
      return const SizedBox(height: 6);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...dayModel.completedHabits.take(3).map((habit) {
          return Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: habit.color,
              shape: BoxShape.circle,
            ),
          );
        }),
        if (dayModel.badgesEarned.isNotEmpty)
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: const BoxDecoration(
              color: AppColors.accentGold,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
