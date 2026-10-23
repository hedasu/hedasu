import 'package:flutter/material.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/router/app_router.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_progress.dart';

class HabitsView extends StatelessWidget {
  const HabitsView({super.key});

  @override
  Widget build(BuildContext context) {
    final habitCtrl = AppScope.of(context).habitController;
    final badgeCtrl = AppScope.of(context).badgeController;

    return ListenableBuilder(
      listenable: habitCtrl,
      builder: (context, _) {
        final habits = habitCtrl.habits;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Alışkanlıklarım'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Yeni Alışkanlık Ekle',
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRouter.addHabitRoute),
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                HabitProgress(
                  completed: habitCtrl.completedTodayCount,
                  total: habitCtrl.habitCount,
                ),
                const SizedBox(height: 20),
                const _HabitsListHeader(),
                const SizedBox(height: 12),
                _HabitsListView(
                  habits: habits,
                  onToggle: (habitId) {
                    habitCtrl.toggleHabitCompletion(habitId, DateTime.now());
                    badgeCtrl.syncProgressWithHabits(
                      habits: habitCtrl.habits,
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRouter.addHabitRoute),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Yeni Alışkanlık'),
          ),
        );
      },
    );
  }
}

class _HabitsListHeader extends StatelessWidget {
  const _HabitsListHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Aktif Alışkanlıklar',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        Text(
          'Her gün bir adım',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _HabitsListView extends StatelessWidget {
  final List<dynamic> habits;
  final ValueChanged<String> onToggle;

  const _HabitsListView({
    required this.habits,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('Henüz eklenmiş bir alışkanlık yok.'),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: habits.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final habit = habits[index];
        return HabitCard(
          habit: habit,
          onToggle: () => onToggle(habit.id),
        );
      },
    );
  }
}
