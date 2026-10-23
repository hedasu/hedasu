import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../habits/models/habit_model.dart';
import '../models/badge_model.dart';
import '../widgets/badge_card.dart';
import '../widgets/badge_progress.dart';
import '../widgets/special_badge.dart';

class BadgesView extends StatelessWidget {
  const BadgesView({super.key});

  void _showBadgeDetail(BuildContext context, BadgeModel badge) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _BadgeDetailModal(badge: badge),
    );
  }

  @override
  Widget build(BuildContext context) {
    final badgeCtrl = AppScope.of(context).badgeController;
    final habitCtrl = AppScope.of(context).habitController;

    return ListenableBuilder(
      listenable: Listenable.merge([badgeCtrl, habitCtrl]),
      builder: (context, _) {
        final special21 = badgeCtrl.special21Badge;

        return Scaffold(
          appBar: AppBar(title: const Text('Başarı Rozetleri')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                BadgeProgress(
                  unlockedCount: badgeCtrl.unlockedCount,
                  totalCount: badgeCtrl.totalCount,
                  totalCoins: badgeCtrl.totalBadgeCoins,
                ),
                const SizedBox(height: 16),
                _HabitSelectorFilterRow(
                  habits: habitCtrl.habits,
                  selectedHabitId: badgeCtrl.selectedHabitId,
                  onSelect: (habitId) => badgeCtrl.selectHabit(habitId),
                ),
                const SizedBox(height: 16),
                SpecialBadge(
                  badge: special21,
                  onTap: () => _showBadgeDetail(context, special21),
                ),
                const SizedBox(height: 16),
                _CategoryChipsRow(
                  selectedCategory: badgeCtrl.selectedCategory,
                  onSelect: (cat) => badgeCtrl.filterCategory(cat),
                ),
                const SizedBox(height: 16),
                _BadgeGrid(
                  badges: badgeCtrl.filteredBadges,
                  onTapBadge: (b) => _showBadgeDetail(context, b),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HabitSelectorFilterRow extends StatelessWidget {
  final List<HabitModel> habits;
  final String? selectedHabitId;
  final ValueChanged<String?> onSelect;

  const _HabitSelectorFilterRow({
    required this.habits,
    required this.selectedHabitId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alışkanlık Bazında Rozet İlerlemesi',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('Tüm Alışkanlıklar (Genel)'),
                selected: selectedHabitId == null,
                onSelected: (_) => onSelect(null),
              ),
              const SizedBox(width: 8),
              ...habits.map((habit) {
                final isSelected = habit.id == selectedHabitId;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: Icon(
                      habit.icon,
                      size: 16,
                      color: isSelected ? Colors.white : habit.color,
                    ),
                    label: Text('${habit.title} (${habit.currentStreak}. Gün)'),
                    selected: isSelected,
                    onSelected: (_) => onSelect(habit.id),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChipsRow extends StatelessWidget {
  final BadgeCategory? selectedCategory;
  final ValueChanged<BadgeCategory?> onSelect;

  const _CategoryChipsRow({
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Tümü'),
            selected: selectedCategory == null,
            onSelected: (_) => onSelect(null),
          ),
          const SizedBox(width: 8),
          ...BadgeCategory.values.map((cat) {
            final isSelected = cat == selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat.displayName),
                selected: isSelected,
                onSelected: (_) => onSelect(cat),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  final List<BadgeModel> badges;
  final ValueChanged<BadgeModel> onTapBadge;

  const _BadgeGrid({required this.badges, required this.onTapBadge});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: badges.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) {
        final badge = badges[index];
        return BadgeCard(
          badge: badge,
          onTap: () => onTapBadge(badge),
        );
      },
    );
  }
}

class _BadgeDetailModal extends StatelessWidget {
  final BadgeModel badge;

  const _BadgeDetailModal({required this.badge});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked;
    final catColor = badge.category.categoryColor;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          Icon(
            isUnlocked ? badge.icon : Icons.lock_outline_rounded,
            size: 54,
            color: isUnlocked ? catColor : Colors.grey,
          ),
          const SizedBox(height: 12),
          Text(
            badge.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          if (badge.habitTitle != null) ...[
            const SizedBox(height: 4),
            Text(
              'Alışkanlık: ${badge.habitTitle}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            badge.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ödül: +${badge.rewardCoins} Rozet',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentGold,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Durum: ${isUnlocked ? "Kazanıldı ✅" : badge.progressText}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ),
        ],
      ),
    );
  }
}
