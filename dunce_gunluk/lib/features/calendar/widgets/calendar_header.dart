import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controller/calendar_controller.dart';
import '../../../core/constants/app_colors.dart';

/// Takvim başlığı: Ay/yıl göstergesi, hızlı ay/yıl seçici ve ay geçiş butonları.
class CalendarHeader extends StatelessWidget {
  final CalendarController controller;

  const CalendarHeader({
    super.key,
    required this.controller,
  });

  static const List<String> _months = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final monthStr =
            DateFormat('MMMM yyyy', 'tr_TR').format(controller.focusedDate);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Önceki Ay',
                onPressed: controller.previousMonth,
              ),
              _buildMonthTitle(context, monthStr),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTodayButton(context),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    tooltip: 'Sonraki Ay',
                    onPressed: controller.nextMonth,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthTitle(BuildContext context, String title) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _showMonthYearPicker(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.toUpperCase(),
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkGold : AppColors.lightAccent;

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor, width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: const Icon(Icons.today, size: 14),
      label: const Text(
        'Bugün',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      onPressed: controller.goToToday,
    );
  }

  void _showMonthYearPicker(BuildContext context) {
    int selectedYear = controller.focusedDate.year;
    int selectedMonth = controller.focusedDate.month;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPickerHeader(selectedYear, (newYear) {
                    setModalState(() => selectedYear = newYear);
                  }),
                  const Divider(),
                  _buildMonthGrid(selectedMonth, (newMonth) {
                    controller.setYearAndMonth(selectedYear, newMonth);
                    Navigator.pop(ctx);
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPickerHeader(int currentYear, ValueChanged<int> onYearChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => onYearChanged(currentYear - 1),
        ),
        Text(
          '$currentYear',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => onYearChanged(currentYear + 1),
        ),
      ],
    );
  }

  Widget _buildMonthGrid(int activeMonth, ValueChanged<int> onSelect) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final monthIndex = index + 1;
        final isSelected = monthIndex == activeMonth;
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected
                ? AppColors.lightAccent.withValues(alpha: 0.15)
                : null,
            side: BorderSide(
              color: isSelected ? AppColors.lightAccent : Colors.grey.shade400,
            ),
            padding: EdgeInsets.zero,
          ),
          onPressed: () => onSelect(monthIndex),
          child: Text(
            _months[index],
            style: GoogleFonts.lora(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      },
    );
  }
}
