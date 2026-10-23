import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../habits/models/habit_model.dart';
import '../models/badge_model.dart';
import '../widgets/badge_card.dart';
import '../widgets/badge_progress.dart';
import '../widgets/special_badge.dart';

class BadgesView extends StatefulWidget {
  const BadgesView({super.key});

  @override
  State<BadgesView> createState() => _BadgesViewState();
}

class _BadgesViewState extends State<BadgesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showBadgeDetail(BuildContext context, BadgeModel badge, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark
          ? AppColors.badgeCardBackgroundDark
          : AppColors.badgeCardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _BadgeDetailModal(badge: badge, isDark: isDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final badgeCtrl = AppScope.of(context).badgeController;
    final habitCtrl = AppScope.of(context).habitController;
    final themeCtrl = AppScope.of(context).themeController;

    return ListenableBuilder(
      listenable: Listenable.merge([badgeCtrl, habitCtrl, themeCtrl]),
      builder: (context, _) {
        final isDark = themeCtrl.isDarkMode;
        final special21 = badgeCtrl.special21Badge;
        final filteredBadges = badgeCtrl.filteredBadges;

        final pageBg =
            isDark ? AppColors.darkBackground : AppColors.lightBackground;
        final titleColor = isDark
            ? AppColors.badgeUnlockedTitleDark
            : AppColors.badgeUnlockedTitle;

        return Scaffold(
          backgroundColor: pageBg,
          appBar: AppBar(
            backgroundColor: pageBg,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              'Başarı Rozetleri',
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            actions: [
              IconButton(
                tooltip: isDark ? 'Açık Mod' : 'Koyu Mod',
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: isDark ? AppColors.accentGold : AppColors.badgeUnlockedTitle,
                ),
                onPressed: themeCtrl.toggleTheme,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: ListView(
              key: const PageStorageKey('badges_scroll_view_v2'),
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              children: [
                // 1. Kompakt Rozet Özeti
                BadgeProgress(
                  unlockedCount: badgeCtrl.unlockedCount,
                  totalCount: badgeCtrl.totalCount,
                  totalCoins: badgeCtrl.totalBadgeCoins,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),

                // 2. Küçük 21 Gün Hedef Kartı
                SpecialBadge(
                  badge: special21,
                  isDark: isDark,
                  onTap: () => _showBadgeDetail(context, special21, isDark),
                ),
                const SizedBox(height: 12),

                // 3. Kompakt Filtreleme Alanı (Alışkanlık Açılır Menü + Kategori Satırı)
                _CompactFilterBar(
                  habits: habitCtrl.habits,
                  selectedHabitId: badgeCtrl.selectedHabitId,
                  selectedCategory: badgeCtrl.selectedCategory,
                  onSelectHabit: (id) => badgeCtrl.selectHabit(id),
                  onSelectCategory: (cat) => badgeCtrl.filterCategory(cat),
                  isDark: isDark,
                ),
                const SizedBox(height: 14),

                // 4. İki Sütunlu Rozet Koleksiyonu Grid
                _BadgeGrid(
                  badges: filteredBadges,
                  isDark: isDark,
                  onTapBadge: (b) => _showBadgeDetail(context, b, isDark),
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

class _CompactFilterBar extends StatelessWidget {
  final List<HabitModel> habits;
  final String? selectedHabitId;
  final BadgeCategory? selectedCategory;
  final ValueChanged<String?> onSelectHabit;
  final ValueChanged<BadgeCategory?> onSelectCategory;
  final bool isDark;

  const _CompactFilterBar({
    required this.habits,
    required this.selectedHabitId,
    required this.selectedCategory,
    required this.onSelectHabit,
    required this.onSelectCategory,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final HabitModel? selectedHabit = selectedHabitId == null
        ? null
        : habits.where((h) => h.id == selectedHabitId).firstOrNull;

    final dropdownBg = isDark
        ? AppColors.badgeCardBackgroundDark
        : AppColors.badgeCardBackground;
    final dropdownBorder =
        isDark ? AppColors.badgeCardBorderDark : AppColors.badgeCardBorder;
    final primaryTextColor = isDark
        ? AppColors.badgeUnlockedTitleDark
        : AppColors.specialTitleText;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.specialDescText;

    // Filter categories: Tümü, Günlük, Haftalık, Aylık, Yıllık
    const availableCategories = [
      null,
      BadgeCategory.daily,
      BadgeCategory.weekly,
      BadgeCategory.monthly,
      BadgeCategory.yearly,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Üst Kısım: Kompakt Alışkanlık Seçici Açılır Menü
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                cardColor: isDark
                    ? AppColors.badgeCardBackgroundDark
                    : AppColors.badgeCardBackground,
              ),
              child: PopupMenuButton<String?>(
                tooltip: 'Alışkanlık Filtresi Seç',
                offset: const Offset(0, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: dropdownBorder),
                ),
                color: isDark
                    ? AppColors.badgeCardBackgroundDark
                    : AppColors.badgeCardBackground,
                onSelected: onSelectHabit,
                itemBuilder: (ctx) => [
                  PopupMenuItem<String?>(
                    value: null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.all_inclusive_rounded,
                          size: 18,
                          color: selectedHabitId == null
                              ? (isDark
                                  ? AppColors.accentGold
                                  : AppColors.badgeRewardTagText)
                              : secondaryTextColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tüm Alışkanlıklar',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: selectedHabitId == null
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: selectedHabitId == null
                                  ? primaryTextColor
                                  : secondaryTextColor,
                            ),
                          ),
                        ),
                        if (selectedHabitId == null)
                          Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: isDark
                                ? AppColors.accentGold
                                : AppColors.badgeRewardTagText,
                          ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  ...habits.map((h) {
                    final isCurrent = h.id == selectedHabitId;
                    return PopupMenuItem<String?>(
                      value: h.id,
                      child: Row(
                        children: [
                          Icon(
                            h.icon,
                            size: 18,
                            color: h.color,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${h.title} (${h.currentStreak}. Gün)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isCurrent
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                color: isCurrent
                                    ? primaryTextColor
                                    : secondaryTextColor,
                              ),
                            ),
                          ),
                          if (isCurrent)
                            Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: isDark
                                  ? AppColors.accentGold
                                  : AppColors.badgeRewardTagText,
                            ),
                        ],
                      ),
                    );
                  }),
                ],
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: dropdownBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: dropdownBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selectedHabit != null
                            ? selectedHabit.icon
                            : Icons.tune_rounded,
                        size: 14,
                        color: selectedHabit != null
                            ? selectedHabit.color
                            : (isDark
                                ? AppColors.accentGold
                                : AppColors.badgeRewardTagText),
                      ),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 160),
                        child: Text(
                          selectedHabit != null
                              ? selectedHabit.title
                              : 'Tüm Alışkanlıklar',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 18,
                        color: secondaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (selectedHabitId != null)
              InkWell(
                onTap: () => onSelectHabit(null),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.close_rounded,
                        size: 13,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Temizle',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Alt Kısım: Tek Yatay Filtre Satırı (Tümü, Günlük, Haftalık, Aylık, Yıllık)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: availableCategories.map((cat) {
              final isSelected = cat == selectedCategory;
              final label = cat == null ? 'Tümü' : cat.displayName;

              final chipBg = isSelected
                  ? (isDark
                      ? AppColors.badgeRewardTagBgDark
                      : AppColors.badgeRewardTagBg)
                  : (isDark
                      ? AppColors.badgeCardBackgroundDark
                      : AppColors.badgeCardBackground);

              final chipBorder = isSelected
                  ? (isDark
                      ? AppColors.specialCardBorderDark
                      : AppColors.specialCardBorder)
                  : (isDark
                      ? AppColors.badgeCardBorderDark
                      : AppColors.badgeCardBorder);

              final chipTextColor = isSelected
                  ? (isDark
                      ? AppColors.specialTagTextDark
                      : AppColors.specialTagText)
                  : secondaryTextColor;

              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: InkWell(
                  onTap: () => onSelectCategory(cat),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5.5),
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: chipBorder, width: 1),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: chipTextColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  final List<BadgeModel> badges;
  final bool isDark;
  final ValueChanged<BadgeModel> onTapBadge;

  const _BadgeGrid({
    required this.badges,
    required this.isDark,
    required this.onTapBadge,
  });

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: Center(
          child: Text(
            'Seçilen filtreye uygun rozet bulunamadı.',
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.specialDescText,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: badges.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final badge = badges[index];
        return BadgeCard(
          badge: badge,
          isDark: isDark,
          onTap: () => onTapBadge(badge),
        );
      },
    );
  }
}

class _BadgeDetailModal extends StatelessWidget {
  final BadgeModel badge;
  final bool isDark;

  const _BadgeDetailModal({required this.badge, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked;

    final titleColor = isDark
        ? AppColors.badgeUnlockedTitleDark
        : (isUnlocked
            ? AppColors.badgeUnlockedTitle
            : AppColors.badgeLockedTitle);
    final descColor =
        isDark ? AppColors.darkTextSecondary : AppColors.specialDescText;

    final Color iconBg;
    final Color iconBorder;
    final Color iconColor;

    if (isUnlocked) {
      iconBg = isDark
          ? AppColors.badgeUnlockedIconBgDark
          : AppColors.badgeUnlockedIconBg;
      iconBorder = isDark
          ? AppColors.badgeUnlockedIconBorderDark
          : AppColors.badgeUnlockedIconBorder;
      iconColor = isDark
          ? AppColors.badgeUnlockedIconColorDark
          : AppColors.badgeUnlockedIconColor;
    } else {
      iconBg = isDark
          ? AppColors.badgeLockedIconBgDark
          : AppColors.badgeLockedIconBg;
      iconBorder = isDark
          ? AppColors.badgeLockedIconBorderDark
          : AppColors.badgeLockedIconBorder;
      iconColor = isDark
          ? AppColors.badgeLockedIconColorDark
          : AppColors.badgeLockedIconColor;
    }

    final rewardBg = isDark
        ? AppColors.badgeRewardTagBgDark
        : AppColors.badgeRewardTagBg;
    final rewardBorder = isDark
        ? AppColors.specialCardBorderDark
        : AppColors.specialCardBorder;
    final rewardText = isDark
        ? AppColors.badgeRewardTagTextDark
        : AppColors.badgeRewardTagText;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.badgeLockedIconBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBg,
                border: Border.all(color: iconBorder, width: 2.2),
                boxShadow: [
                  if (isUnlocked)
                    BoxShadow(
                      color: (isDark
                              ? AppColors.badgeUnlockedGlowDark
                              : AppColors.badgeUnlockedGlow)
                          .withValues(alpha: isDark ? 0.35 : 0.45),
                      blurRadius: 14,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Icon(
                isUnlocked ? badge.icon : Icons.lock_outline_rounded,
                size: 34,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              badge.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
            if (badge.habitTitle != null) ...[
              const SizedBox(height: 4),
              Text(
                'Alışkanlık: ${badge.habitTitle}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: rewardText,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: descColor,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: rewardBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: rewardBorder),
                  ),
                  child: Text(
                    'Ödül: +${badge.rewardCoins} Rozet',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: rewardText,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: isUnlocked ? rewardBg : iconBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isUnlocked ? rewardBorder : iconBorder,
                    ),
                  ),
                  child: Text(
                    'Durum: ${isUnlocked ? "Kazanıldı ✅" : badge.progressText}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isUnlocked ? titleColor : descColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.darkSecondary
                      : AppColors.badgeUnlockedTitle,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Kapat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
