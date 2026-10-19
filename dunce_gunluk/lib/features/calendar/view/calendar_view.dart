import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/paper_background.dart';
import '../../../core/widgets/washi_tape.dart';
import '../controller/calendar_controller.dart';
import '../widgets/calendar_header.dart';
import '../widgets/calendar_day_cell.dart';
import '../../diary/controller/diary_controller.dart';
import '../../diary/models/diary_entry.dart';
import '../../diary/widgets/diary_card.dart';
import '../../diary/view/diary_editor_view.dart';

/// Ajanda takvimi ve Anı Defteri'nin aynı sayfada bütünleşik yer aldığı ana ekran.
class CalendarView extends StatelessWidget {
  final CalendarController calendarController;
  final DiaryController diaryController;

  const CalendarView({
    super.key,
    required this.calendarController,
    required this.diaryController,
  });

  static const List<String> _weekdays = ['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pz'];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([calendarController, diaryController]),
      builder: (context, _) {
        final selectedDate = calendarController.selectedDate;
        final selectedEntry = diaryController.getEntryForDate(selectedDate);
        final entriesList = diaryController.entries.values.toList()
          ..sort((a, b) => b.dateKey.compareTo(a.dateKey));

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            _buildCalendarContainer(context),
            const SizedBox(height: 14),
            _buildSelectedDaySummary(context, selectedDate, selectedEntry),
            const SizedBox(height: 20),
            _buildJournalSectionHeader(context),
            const SizedBox(height: 12),
            _buildJournalFeed(context, entriesList),
          ],
        );
      },
    );
  }

  Widget _buildCalendarContainer(BuildContext context) {
    return PaperBackground(
      showLines: false,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          CalendarHeader(controller: calendarController),
          _buildWeekdayHeader(context),
          const Divider(),
          _buildDaysGrid(context),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkTextSecondary : Colors.grey.shade600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: GoogleFonts.lora(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaysGrid(BuildContext context) {
    final focused = calendarController.focusedDate;
    final firstDayOfMonth = DateTime(focused.year, focused.month, 1);
    final daysInMonth = DateTime(focused.year, focused.month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday; // 1 = Pazartesi

    final totalCells = ((startingWeekday - 1) + daysInMonth <= 35) ? 35 : 42;
    final now = DateTime.now();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final dayOffset = index - (startingWeekday - 1);
        final cellDate = DateTime(focused.year, focused.month, dayOffset + 1);
        final isCurrentMonth = cellDate.month == focused.month;
        final isSelected = _isSameDay(cellDate, calendarController.selectedDate);
        final isToday = _isSameDay(cellDate, now);
        final entry = diaryController.getEntryForDate(cellDate);
        final hasEntry = entry != null;

        return CalendarDayCell(
          date: cellDate,
          isCurrentMonth: isCurrentMonth,
          isSelected: isSelected,
          isToday: isToday,
          hasEntry: hasEntry,
          entryTitle: entry?.title,
          onTap: () {
            calendarController.selectDate(cellDate);
            _openEditor(context, cellDate, entry);
          },
        );
      },
    );
  }

  Widget _buildSelectedDaySummary(
      BuildContext context, DateTime selectedDate, DiaryEntry? entry) {
    final formattedDate =
        DateFormat('d MMMM yyyy, EEEE', 'tr_TR').format(selectedDate);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            entry != null ? Icons.bookmark : Icons.edit_calendar,
            color: isDark ? AppColors.darkGold : AppColors.lightAccent,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate,
                  style: GoogleFonts.lora(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkGold : AppColors.lightAccent,
                  ),
                ),
                Text(
                  entry != null ? entry.title : 'Bu güne anı yazmak için dokun',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () => _openEditor(context, selectedDate, entry),
            child: Text(entry != null ? 'Düzenle' : 'Yaz'),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalSectionHeader(BuildContext context) {
    return Row(
      children: [
        const WashiTape(width: 40, height: 14),
        const SizedBox(width: 8),
        Text(
          'Anı Defteri & Hatıralar',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildJournalFeed(BuildContext context, List<DiaryEntry> entriesList) {
    if (entriesList.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: entriesList.map((entry) {
        return DiaryCard(
          entry: entry,
          onTap: () {
            final date = DateTime.parse(entry.dateKey);
            _openEditor(context, date, entry);
          },
          onDelete: () => _confirmDelete(context, entry.dateKey),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.menu_book_outlined, size: 40, color: Colors.grey),
              const SizedBox(height: 10),
              Text(
                'Henüz Bir Anı Kaydedilmedi',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Takvimden istediğin bir güne dokunarak o günün anısını yazmaya başla.',
                style: GoogleFonts.lora(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openEditor(BuildContext context, DateTime date, DiaryEntry? entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiaryEditorView(
          selectedDate: date,
          existingEntry: entry,
          diaryController: diaryController,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String dateKey) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteConfirmTitle),
        content: const Text(AppStrings.deleteConfirmMessage),
        actions: [
          TextButton(
            child: const Text(AppStrings.cancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(AppStrings.delete),
            onPressed: () {
              diaryController.deleteEntry(dateKey);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
