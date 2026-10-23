import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/extensions/date_extensions.dart';
import '../controller/calendar_controller.dart';
import '../models/calendar_day_model.dart';
import '../widgets/calendar_day.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  void _showDayDetailsModal(BuildContext context, DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DayDetailsModal(selectedDate: date),
    );
  }

  @override
  Widget build(BuildContext context) {
    final calendarCtrl = AppScope.of(context).calendarController;
    final habitCtrl = AppScope.of(context).habitController;
    final badgeCtrl = AppScope.of(context).badgeController;

    return ListenableBuilder(
      listenable: Listenable.merge([calendarCtrl, habitCtrl, badgeCtrl]),
      builder: (context, _) {
        final monthDays = calendarCtrl.generateMonthDays(
          habits: habitCtrl.allHabitsWithHistory,
          badges: badgeCtrl.allBadges,
        );

        final selectedDayModel = monthDays.firstWhere(
          (d) => d.date.isSameDay(calendarCtrl.selectedDate),
          orElse: () => CalendarDayModel(
            date: calendarCtrl.selectedDate,
            isCurrentMonth: true,
            isToday: true,
          ),
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Alışkanlık Takvimi'),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Ay ve Yıl Gezinti Başlığı (< Ekim 2026 >)
                _CalendarNavigationHeader(controller: calendarCtrl),
                const SizedBox(height: 12),

                // Haftanın Günleri Başlığı (Pzt, Sal, Çar, ...)
                const _WeekdayHeader(),
                const SizedBox(height: 8),

                // Aylık Takvim Izgarası (Güne tıklanınca gün penceresi açılır)
                _CalendarGrid(
                  days: monthDays,
                  selectedDate: calendarCtrl.selectedDate,
                  onSelectDate: (date) {
                    calendarCtrl.selectDate(date);
                    _showDayDetailsModal(context, date);
                  },
                ),
                const SizedBox(height: 16),

                // Alt Kısım: Seçili Gün Hızlı Bilgi & İpucu Kartı
                _SelectedDayQuickCard(
                  dayModel: selectedDayModel,
                  onOpenDetails: () =>
                      _showDayDetailsModal(context, selectedDayModel.date),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CalendarNavigationHeader extends StatelessWidget {
  final CalendarController controller;

  const _CalendarNavigationHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    const months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];

    final title =
        '${months[controller.displayedMonth.month - 1]} ${controller.displayedMonth.year}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              tooltip: 'Önceki Ay',
              onPressed: controller.previousMonth,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              tooltip: 'Sonraki Ay',
              onPressed: controller.nextMonth,
            ),
          ],
        ),
      ],
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    const weekdays = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return Expanded(
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final List<CalendarDayModel> days;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectDate;

  const _CalendarGrid({
    required this.days,
    required this.selectedDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.50,
        crossAxisSpacing: 3,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        final day = days[index];
        final isSelected = day.date.isSameDay(selectedDate);
        return CalendarDay(
          dayModel: day,
          isSelected: isSelected,
          onTap: () => onSelectDate(day.date),
        );
      },
    );
  }
}

class _SelectedDayQuickCard extends StatelessWidget {
  final CalendarDayModel dayModel;
  final VoidCallback onOpenDetails;

  const _SelectedDayQuickCard({
    required this.dayModel,
    required this.onOpenDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final completedCount = dayModel.completedHabits.length;

    return InkWell(
      onTap: onOpenDetails,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark
              ? (Theme.of(context).cardTheme.color ?? const Color(0xFF1A221E))
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFDCE8DF),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
              ),
              child: Icon(
                Icons.event_available_rounded,
                size: 20,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayModel.date.toFormattedFullDate(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    completedCount > 0
                        ? '$completedCount alışkanlık tamamlandı • Detaylar için dokunun'
                        : 'Kayıt yok • Detaylar için dokunun',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// GÜN PENCERESİ (DAY DETAILS MODAL WINDOW)
// ==========================================

class _DayDetailsModal extends StatelessWidget {
  final DateTime selectedDate;

  const _DayDetailsModal({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final habitCtrl = AppScope.of(context).habitController;
    final badgeCtrl = AppScope.of(context).badgeController;
    final petCtrl = AppScope.of(context).petController;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final modalBg = isDark ? const Color(0xFF161917) : const Color(0xFFFAF8F1);
    final cardBg = isDark ? const Color(0xFF1F2622) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2E3D34) : const Color(0xFFDCE8DF);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListenableBuilder(
      listenable: Listenable.merge([habitCtrl, badgeCtrl, petCtrl]),
      builder: (context, _) {
        final activeHabits = habitCtrl.habits;
        final historicalCompletedHabits = habitCtrl.allHabitsWithHistory
            .where((h) => h.isArchived && h.isCompletedOnDate(selectedDate))
            .toList();
        final dayHabits = [...activeHabits, ...historicalCompletedHabits];
        final completedHabits =
            dayHabits.where((h) => h.isCompletedOnDate(selectedDate)).toList();
        final completedCount = completedHabits.length;
        final totalCount = dayHabits.length;
        final progressRatio = totalCount > 0 ? completedCount / totalCount : 0.0;

        // Earned badges on this date
        final badgesEarned = badgeCtrl.allBadges.where((b) {
          if (b.unlockedDate == null) return false;
          final u = b.unlockedDate!;
          return u.year == selectedDate.year &&
              u.month == selectedDate.month &&
              u.day == selectedDate.day;
        }).toList();

        final now = DateTime.now();
        final isToday = selectedDate.year == now.year &&
            selectedDate.month == now.month &&
            selectedDate.day == now.day;

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          decoration: BoxDecoration(
            color: modalBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tutamaç (Drag Handle)
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Center(
                  child: Container(
                    width: 42,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF35443B) : const Color(0xFFD2DCD5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              // Üst Başlık ve Tarih Alanı
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                      ),
                      child: Icon(
                        Icons.calendar_today_rounded,
                        size: 20,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedDate.toFormattedFullDate(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              if (isToday) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Bugün',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$completedCount / $totalCount Alışkanlık Tamamlandı',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Günlük İlerleme Çubuğu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressRatio,
                    minHeight: 5,
                    backgroundColor: isDark
                        ? const Color(0xFF28342D)
                        : const Color(0xFFE5ECE7),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Alışkanlıklar Listesi & Rozetler
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // Kazanılan Rozetler Bölümü (Varsa)
                    if (badgesEarned.isNotEmpty) ...[
                      ...badgesEarned.map((badge) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.accentGold.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text('🏆', style: TextStyle(fontSize: 22)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rozet Kazanıldı: ${badge.title}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.accentGold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '+${badge.rewardCoins} Rozet Ödülü • ${badge.description}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? Colors.white70 : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 4),
                    ],

                    // Alışkanlık Maddeleri
                    ...dayHabits.map((habit) {
                      final isCompleted = habit.isCompletedOnDate(selectedDate);
                      final habitColor =
                          AppColors.getHabitTextAndIconColor(habit.id, habit.color);
                      final habitBg =
                          AppColors.getHabitCardBackground(habit.id, habit.color);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isCompleted
                                ? habitColor.withValues(alpha: 0.45)
                                : borderColor,
                            width: isCompleted ? 1.2 : 1.0,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (habit.isArchived) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '„${habit.title}” silinmiş bir alışkanlıktır. Bu tarihteki başarı kaydınız korunmaktadır.',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }

                              habitCtrl.toggleHabitCompletion(
                                habit.id,
                                selectedDate,
                              );
                              badgeCtrl.syncProgressWithHabits(
                                habits: habitCtrl.habits,
                              );
                              // Alışkanlık tamamlandığında pet XP'si kazandır
                              final newlyCompleted =
                                  habit.isCompletedOnDate(selectedDate);
                              if (newlyCompleted) {
                                petCtrl.addExp(25);
                              }
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 11),
                              child: Row(
                                children: [
                                  // Alışkanlık İkonu
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: habitBg,
                                      border: Border.all(
                                        color: habitColor.withValues(alpha: 0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      habit.icon,
                                      size: 18,
                                      color: habitColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Alışkanlık Başlığı ve Bilgisi
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                habit.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: isDark
                                                      ? Colors.white
                                                      : const Color(0xFF273B34),
                                                ),
                                              ),
                                            ),
                                            if (habit.isArchived) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: isDark
                                                      ? const Color(0xFF352B1E)
                                                      : const Color(0xFFFFF3DC),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: const Color(0xFFEAA02D)
                                                        .withValues(alpha: 0.5),
                                                    width: 0.8,
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Geçmiş Kayıt',
                                                  style: TextStyle(
                                                    fontSize: 9.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFFD97706),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          habit.isArchived
                                              ? '${habit.target} • Silinen alışkanlığın başarısı korundu'
                                              : '${habit.target} • ${habit.currentStreak}. Gün Seri',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Durum Butonu / Rozeti
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: isCompleted
                                          ? habitColor.withValues(
                                              alpha: isDark ? 0.22 : 0.15)
                                          : (isDark
                                              ? Colors.white.withValues(alpha: 0.05)
                                              : const Color(0xFFF0F4F1)),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isCompleted
                                            ? habitColor
                                            : borderColor,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isCompleted
                                              ? (habit.isArchived
                                                  ? Icons.verified_rounded
                                                  : Icons.check_circle_rounded)
                                              : Icons.radio_button_unchecked_rounded,
                                          size: 14,
                                          color: isCompleted
                                              ? habitColor
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.color,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isCompleted
                                              ? (habit.isArchived
                                                  ? 'Kayıtlı'
                                                  : 'Tamamlandı')
                                              : 'Yapılmadı',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: isCompleted
                                                ? habitColor
                                                : Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              // Alt Buton
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: isDark
                          ? const Color(0xFF28362F)
                          : const Color(0xFF557C6B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Kapat',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
