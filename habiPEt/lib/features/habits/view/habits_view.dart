import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/router/app_router.dart';
import '../../pets/models/pet_model.dart';
import '../../pets/widgets/pet_character.dart';
import '../models/habit_model.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_progress.dart';

class HabitsView extends StatelessWidget {
  const HabitsView({super.key});

  Future<bool?> _showDeleteHabitConfirmationDialog(
    BuildContext context, {
    required HabitModel habit,
    required PetModel pet,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PetCharacter(
                type: pet.type,
                size: 110,
                isHappy: false,
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      Theme.of(ctx).colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${pet.name} (${pet.type.displayName})',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(ctx).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Çok iyi gidiyordunuz!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Alışkanlığı silmek istediğinize emin misiniz?',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: habit.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: habit.color.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: habit.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(habit.icon, color: habit.color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${habit.currentStreak}. Gün Serisi • ${habit.target}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(ctx).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '„${habit.title}” aktif listenizden kaldırılacaktır. Başardığınız geçmiş tarihlerdeki takvim ve ajanda başarı kayıtlarınız korunmaya devam eder.',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(ctx).textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Vazgeç',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Evet, Sil',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showDeleteHabitSheet(
    BuildContext context, {
    required List<HabitModel> habits,
    required PetModel pet,
    required void Function(HabitModel) onDeleteHabit,
  }) {
    if (habits.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Henüz silinebilecek bir alışkanlık bulunmuyor.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Silinecek Alışkanlığı Seçin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(modalContext).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Silmek istediğiniz alışkanlığa dokunun.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: habits.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (_, index) {
                      final habit = habits[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.of(modalContext).pop();
                          onDeleteHabit(habit);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: habit.color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(habit.icon,
                                    color: habit.color, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      habit.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${habit.currentStreak}. Gün Serisi • ${habit.target}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppColors.error,
                                ),
                                onPressed: () {
                                  Navigator.of(modalContext).pop();
                                  onDeleteHabit(habit);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitCtrl = AppScope.of(context).habitController;
    final badgeCtrl = AppScope.of(context).badgeController;
    final petCtrl = AppScope.of(context).petController;

    return ListenableBuilder(
      listenable: habitCtrl,
      builder: (context, _) {
        final habits = habitCtrl.habits;

        void handleDeleteHabit(HabitModel habit) async {
          final confirmed = await _showDeleteHabitConfirmationDialog(
            context,
            habit: habit,
            pet: petCtrl.pet,
          );

          if (confirmed == true && context.mounted) {
            habitCtrl.deleteHabit(habit.id);
            badgeCtrl.syncProgressWithHabits(habits: habitCtrl.habits);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '„${habit.title}” silindi. Geçmiş günlerdeki takvim başarı kayıtlarınız korundu.',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }

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
                  onDelete: handleDeleteHabit,
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: _CompactDeleteHabitButton(
                    onTap: () => _showDeleteHabitSheet(
                      context,
                      habits: habits,
                      pet: petCtrl.pet,
                      onDeleteHabit: handleDeleteHabit,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CompactDeleteHabitButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CompactDeleteHabitButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: 'Alışkanlık Sil',
      child: Material(
        color: isDark ? const Color(0xFF261919) : const Color(0xFFFFF0F0),
        shape: CircleBorder(
          side: BorderSide(
            color: AppColors.error.withValues(alpha: 0.45),
            width: 1.2,
          ),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(11),
            child: Icon(
              Icons.delete_outline_rounded,
              color: AppColors.error,
              size: 22,
            ),
          ),
        ),
      ),
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
  final List<HabitModel> habits;
  final ValueChanged<String> onToggle;
  final ValueChanged<HabitModel> onDelete;

  const _HabitsListView({
    required this.habits,
    required this.onToggle,
    required this.onDelete,
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
          onLongPress: () => onDelete(habit),
        );
      },
    );
  }
}
