import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// Takvimde tek bir günü ve o günün anı başlığını temsil eden hücre bileşeni.
class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final bool hasEntry;
  final String? entryTitle;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.hasEntry,
    this.entryTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
        decoration: _buildDecoration(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDayHeader(context),
            if (entryTitle != null && entryTitle!.isNotEmpty)
              _buildTitleBadge(context),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isSelected) {
      return BoxDecoration(
        color: (isDark ? AppColors.darkGold : AppColors.lightGold)
            .withValues(alpha: 0.25),
        border: Border.all(
          color: isDark ? AppColors.darkGold : AppColors.lightGold,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      );
    }
    if (isToday) {
      return BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      );
    }
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildDayHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDayText(context),
        if (hasEntry) ...[
          const SizedBox(width: 2),
          const Icon(
            Icons.circle,
            size: 5,
            color: AppColors.stampRed,
          ),
        ],
      ],
    );
  }

  Widget _buildDayText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = !isCurrentMonth
        ? (isDark ? const Color(0xFF6E5F55) : Colors.grey.withValues(alpha: 0.4))
        : isSelected
            ? (isDark ? AppColors.darkGold : AppColors.lightAccent)
            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    return Text(
      '${date.day}',
      style: GoogleFonts.lora(
        fontSize: 13,
        fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.w500,
        color: textColor,
      ),
    );
  }

  Widget _buildTitleBadge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkGold.withValues(alpha: 0.2)
            : AppColors.lightAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: isDark
              ? AppColors.darkGold.withValues(alpha: 0.4)
              : AppColors.lightAccent.withValues(alpha: 0.25),
          width: 0.5,
        ),
      ),
      child: Text(
        entryTitle!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.lora(
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkGold : AppColors.lightAccent,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
