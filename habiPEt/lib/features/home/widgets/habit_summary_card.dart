import 'package:flutter/material.dart';
import '../../habits/models/habit_model.dart';

class HabitSummaryCard extends StatelessWidget {
  final List<HabitModel> habits;
  final ValueChanged<String> onToggleHabit;
  final VoidCallback onAddHabit;

  const HabitSummaryCard({
    super.key,
    required this.habits,
    required this.onToggleHabit,
    required this.onAddHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryHeaderRow(onAddHabit: onAddHabit),
            const SizedBox(height: 14),
            _HabitsCompactList(habits: habits, onToggle: onToggleHabit),
          ],
        ),
      ),
    );
  }
}

class _SummaryHeaderRow extends StatelessWidget {
  final VoidCallback onAddHabit;

  const _SummaryHeaderRow({required this.onAddHabit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Bugünün Görevleri',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        TextButton.icon(
          onPressed: onAddHabit,
          icon: const Icon(Icons.add_rounded, size: 16),
          label: const Text('Ekle', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}

class _HabitsCompactList extends StatelessWidget {
  final List<HabitModel> habits;
  final ValueChanged<String> onToggle;

  const _HabitsCompactList({required this.habits, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text('Henüz alışkanlık eklemediniz.'),
      );
    }

    return Column(
      children: habits.take(4).map((habit) {
        final isDone = habit.isCompletedToday;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: habit.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  habit.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isDone ? FontWeight.w500 : FontWeight.w700,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone
                        ? Theme.of(context).textTheme.bodySmall?.color
                        : null,
                  ),
                ),
              ),
              InkWell(
                onTap: () => onToggle(habit.id),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDone ? habit.color : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone ? habit.color : Theme.of(context).dividerColor,
                      width: 1.5,
                    ),
                  ),
                  child: isDone
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                      : null,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
