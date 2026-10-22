import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../../../core/constants/app_colors.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = habit.isCompletedToday;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _HabitIconBadge(habit: habit),
              const SizedBox(width: 14),
              _HabitInfoColumn(habit: habit),
              const SizedBox(width: 8),
              _HabitCheckButton(isDone: isDone, color: habit.color),
            ],
          ),
        ),
      ),
    );
  }
}

class _HabitIconBadge extends StatelessWidget {
  final HabitModel habit;

  const _HabitIconBadge({required this.habit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: habit.color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: habit.color.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Icon(
        habit.icon,
        color: habit.color,
        size: 26,
      ),
    );
  }
}

class _HabitInfoColumn extends StatelessWidget {
  final HabitModel habit;

  const _HabitInfoColumn({required this.habit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  habit.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _StreakBadge(streak: habit.currentStreak),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            habit.target,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int streak;

  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accentOrange.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: AppColors.accentOrange, size: 14),
          const SizedBox(width: 2),
          Text(
            '$streak g',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.accentOrange,
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitCheckButton extends StatelessWidget {
  final bool isDone;
  final Color color;

  const _HabitCheckButton({required this.isDone, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: isDone ? color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDone ? color : Theme.of(context).dividerColor,
          width: 2,
        ),
      ),
      child: isDone
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
          : null,
    );
  }
}
