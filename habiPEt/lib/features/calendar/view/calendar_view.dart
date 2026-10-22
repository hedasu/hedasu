import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/extensions/date_extensions.dart';
import '../models/calendar_day_model.dart';
import '../widgets/calendar_day.dart';
import '../widgets/calendar_habit_item.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarCtrl = AppScope.of(context).calendarController;
    final habitCtrl = AppScope.of(context).habitController;
    final badgeCtrl = AppScope.of(context).badgeController;

    return ListenableBuilder(
      listenable: Listenable.merge([calendarCtrl, habitCtrl, badgeCtrl]),
      builder: (context, _) {
        final days = calendarCtrl.generateMonthDays(
          habits: habitCtrl.habits,
          badges: badgeCtrl.allBadges,
        );

        final selectedDayModel = days.firstWhere(
          (d) => d.date.isSameDay(calendarCtrl.selectedDate),
          orElse: () => CalendarDayModel(
            date: calendarCtrl.selectedDate,
            isCurrentMonth: true,
            isToday: true,
          ),
        );

        return Scaffold(
          appBar: AppBar(title: const Text('Alışkanlık Takvimi')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                _MonthNavigationHeader(
                  displayedMonth: calendarCtrl.displayedMonth,
                  onPrev: calendarCtrl.previousMonth,
                  onNext: calendarCtrl.nextMonth,
                ),
                const SizedBox(height: 12),
                const _WeekdayHeader(),
                const SizedBox(height: 8),
                _CalendarGrid(
                  days: days,
                  selectedDate: calendarCtrl.selectedDate,
                  onSelectDate: calendarCtrl.selectDate,
                ),
                const SizedBox(height: 20),
                _SelectedDayActivitySection(dayModel: selectedDayModel),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MonthNavigationHeader extends StatelessWidget {
  final DateTime displayedMonth;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthNavigationHeader({
    required this.displayedMonth,
    required this.onPrev,
    required this.onNext,
  });

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${months[displayedMonth.month - 1]} ${displayedMonth.year}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: onPrev,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: onNext,
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
        childAspectRatio: 1.0,
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

class _SelectedDayActivitySection extends StatelessWidget {
  final CalendarDayModel dayModel;

  const _SelectedDayActivitySection({required this.dayModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dayModel.date.toFormattedFullDate(),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (dayModel.completedHabits.isEmpty && dayModel.badgesEarned.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Bu tarihte tamamlanan bir alışkanlık kaydı yok.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          )
        else ...[
          ...dayModel.completedHabits.map((habit) {
            return CalendarHabitItem(habit: habit);
          }),
          ...dayModel.badgesEarned.map((badge) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
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
                  const Text('🏆', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Rozet Kazanıldı: ${badge.title}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentGold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
