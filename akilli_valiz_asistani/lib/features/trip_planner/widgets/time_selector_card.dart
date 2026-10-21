import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/glass_container.dart';
import '../controllers/trip_planner_controller.dart';

class TimeSelectorCard extends StatelessWidget {
  final TripPlannerController controller;

  const TimeSelectorCard({super.key, required this.controller});

  Future<void> _pickTime(BuildContext context, bool isArrival) async {
    final cur = isArrival
        ? (controller.arrivalTime.value ?? const TimeOfDay(hour: 10, minute: 0))
        : (controller.departureTime.value ?? const TimeOfDay(hour: 18, minute: 0));

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    final picked = await showTimePicker(
      context: context,
      initialTime: cur,
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
      if (isArrival) {
        controller.setArrivalTime(picked);
      } else {
        controller.setDepartureTime(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final secondaryColor = isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final selectedBg = isDark ? AppColors.darkSelected : AppColors.lightSelected;
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.lightCard;

    return ValueListenableBuilder<bool>(
      valueListenable: controller.provideSpecificTimes,
      builder: (context, provideTimes, _) {
        return GlassContainer(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: secondaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.access_time_rounded,
                      color: secondaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppStrings.timePromptTitle,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.timePromptQuestion,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),

              // Choice Buttons
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: Center(
                        child: Text(
                          AppStrings.btnYesTime,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: provideTimes ? FontWeight.w600 : FontWeight.w500,
                            color: provideTimes ? primaryColor : textPrimary,
                          ),
                        ),
                      ),
                      selected: provideTimes,
                      selectedColor: selectedBg,
                      backgroundColor: surfaceColor,
                      side: BorderSide(
                        color: provideTimes ? primaryColor : borderColor,
                        width: provideTimes ? 1.5 : 1.0,
                      ),
                      onSelected: (val) {
                        controller.provideSpecificTimes.value = true;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      label: Center(
                        child: Text(
                          AppStrings.btnSkipTime,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: !provideTimes ? FontWeight.w600 : FontWeight.w500,
                            color: !provideTimes ? primaryColor : textPrimary,
                          ),
                        ),
                      ),
                      selected: !provideTimes,
                      selectedColor: selectedBg,
                      backgroundColor: surfaceColor,
                      side: BorderSide(
                        color: !provideTimes ? primaryColor : borderColor,
                        width: !provideTimes ? 1.5 : 1.0,
                      ),
                      onSelected: (val) {
                        controller.provideSpecificTimes.value = false;
                      },
                    ),
                  ),
                ],
              ),

              if (provideTimes) ...[
                const SizedBox(height: 16),
                Divider(height: 1, color: borderColor),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<TimeOfDay?>(
                        valueListenable: controller.arrivalTime,
                        builder: (context, arrTime, _) {
                          final label = arrTime != null
                              ? '${arrTime.hour.toString().padLeft(2, '0')}:${arrTime.minute.toString().padLeft(2, '0')}'
                              : '10:00';
                          return _buildTimePickerTile(
                            context: context,
                            title: 'Varış Saati',
                            timeStr: label,
                            icon: Icons.flight_land_rounded,
                            onTap: () => _pickTime(context, true),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ValueListenableBuilder<TimeOfDay?>(
                        valueListenable: controller.departureTime,
                        builder: (context, depTime, _) {
                          final label = depTime != null
                              ? '${depTime.hour.toString().padLeft(2, '0')}:${depTime.minute.toString().padLeft(2, '0')}'
                              : '18:00';
                          return _buildTimePickerTile(
                            context: context,
                            title: 'Ayrılış Saati',
                            timeStr: label,
                            icon: Icons.flight_takeoff_rounded,
                            onTap: () => _pickTime(context, false),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimePickerTile({
    required BuildContext context,
    required String title,
    required String timeStr,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final surfaceColor = isDark ? AppColors.darkSelected : AppColors.lightSelected;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: primaryColor),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              timeStr,
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
