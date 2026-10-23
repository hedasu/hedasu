import 'package:flutter/material.dart';
import '../models/calendar_day_model.dart';
import '../../habits/models/habit_model.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final cellBg = isSelected
        ? primaryColor.withValues(alpha: isDark ? 0.16 : 0.14)
        : (dayModel.isToday
            ? primaryColor.withValues(alpha: isDark ? 0.06 : 0.08)
            : (isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.85)));

    final cellBorder = isSelected
        ? primaryColor
        : (dayModel.isToday
            ? primaryColor.withValues(alpha: 0.7)
            : (isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFDCE8DF)));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: cellBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: cellBorder,
            width: isSelected ? 1.6 : (dayModel.isToday ? 1.2 : 0.8),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DayHeader(dayModel: dayModel, isSelected: isSelected),
            const SizedBox(height: 2),
            Expanded(
              child: _HabitTitlesColumn(dayModel: dayModel),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  final CalendarDayModel dayModel;
  final bool isSelected;

  const _DayHeader({required this.dayModel, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    Color textColor;
    if (isSelected) {
      textColor = isDark ? Colors.black : Colors.white;
    } else if (dayModel.isToday) {
      textColor = primaryColor;
    } else if (!dayModel.isCurrentMonth) {
      textColor = isDark
          ? Colors.white.withValues(alpha: 0.25)
          : const Color(0xFF273B34).withValues(alpha: 0.28);
    } else {
      textColor = isDark
          ? Colors.white.withValues(alpha: 0.95)
          : const Color(0xFF273B34); // Sage & Cream deep text color (#273B34)
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor
                : (dayModel.isToday
                    ? primaryColor.withValues(alpha: isDark ? 0.22 : 0.15)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            '${dayModel.date.day}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected || dayModel.isToday
                  ? FontWeight.w800
                  : FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
        if (dayModel.badgesEarned.isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(right: 2),
            child: Text('🏆', style: TextStyle(fontSize: 8)),
          ),
      ],
    );
  }
}

class _HabitTitlesColumn extends StatelessWidget {
  final CalendarDayModel dayModel;

  const _HabitTitlesColumn({required this.dayModel});

  @override
  Widget build(BuildContext context) {
    final habits = dayModel.completedHabits;
    if (habits.isEmpty) {
      return const SizedBox.shrink();
    }

    final showMore = habits.length > 3;
    final visibleCount = showMore ? 2 : 3;
    final visibleHabits = habits.take(visibleCount).toList();
    final remaining = habits.length - visibleCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...visibleHabits.map((habit) => _HabitTitleChip(habit: habit)),
        if (showMore) _MoreHabitsChip(count: remaining),
      ],
    );
  }
}

class _HabitTitleChip extends StatelessWidget {
  final HabitModel habit;

  const _HabitTitleChip({required this.habit});

  @override
  Widget build(BuildContext context) {
    final chipBg = AppColors.getHabitCardBackground(habit.id, habit.color);
    final dotAndTextColor = AppColors.getHabitTextAndIconColor(habit.id, habit.color);

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: dotAndTextColor.withValues(alpha: 0.35),
          width: 0.6,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Takvimdeki küçük renkli nokta (Yeni renkle eşleştirilmiş)
          Container(
            width: 4.5,
            height: 4.5,
            decoration: BoxDecoration(
              color: dotAndTextColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 2.5),
          Expanded(
            child: Text(
              habit.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 7.5,
                fontWeight: FontWeight.w700,
                color: dotAndTextColor,
                letterSpacing: -0.2,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreHabitsChip extends StatelessWidget {
  final int count;

  const _MoreHabitsChip({required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252430) : const Color(0xFFEDE9F5),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: isDark ? const Color(0xFF393447) : const Color(0xFFD4CCE3),
          width: 0.5,
        ),
      ),
      child: Text(
        '+$count',
        style: TextStyle(
          fontSize: 7.5,
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFFBDB0D2) : const Color(0xFF5E4F77),
          letterSpacing: -0.2,
          height: 1.1,
        ),
      ),
    );
  }
}
