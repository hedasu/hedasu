import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/glass_container.dart';
import '../controllers/trip_planner_controller.dart';

class DateRangePickerCard extends StatelessWidget {
  final TripPlannerController controller;

  const DateRangePickerCard({super.key, required this.controller});

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final currentStart = controller.startDate.value ?? now.add(const Duration(days: 1));
    final currentEnd = controller.endDate.value ?? now.add(const Duration(days: 5));

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 730)),
      initialDateRange: DateTimeRange(start: currentStart, end: currentEnd),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: primaryColor,
                    onPrimary: const Color(0xFF101C1B),
                    surface: surfaceColor,
                    onSurface: textColor,
                  )
                : ColorScheme.light(
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    surface: surfaceColor,
                    onSurface: textColor,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.setDates(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seyahat Tarihleri',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<DateTime?>(
          valueListenable: controller.startDate,
          builder: (context, start, _) {
            return ValueListenableBuilder<DateTime?>(
              valueListenable: controller.endDate,
              builder: (context, end, _) {
                final hasDates = start != null && end != null;
                final duration = hasDates ? AppDateUtils.calculateDurationDays(start, end) : 0;

                return GlassContainer(
                  padding: const EdgeInsets.all(16),
                  onTap: () => _pickDateRange(context),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: primaryColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasDates
                                  ? AppDateUtils.formatDateRange(start, end)
                                  : 'Tarih Aralığı Seçilmedi',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              hasDates
                                  ? '$duration Günlük Seyahat Ajandası'
                                  : 'Başlangıç ve bitiş tarihlerini belirlemek için dokunun',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
