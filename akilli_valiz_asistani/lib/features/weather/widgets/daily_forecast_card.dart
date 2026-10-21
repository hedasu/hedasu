import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/glass_container.dart';
import '../models/weather_model.dart';

class DailyForecastCard extends StatelessWidget {
  final List<DailyWeatherItem> items;
  final String destination;

  const DailyForecastCard({
    super.key,
    required this.items,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final iconBg = isDark ? AppColors.darkSelected : AppColors.lightSelected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.view_agenda_outlined, size: 16, color: primaryColor),
            const SizedBox(width: 8),
            Text(
              'Günlük Seyahat Ajandası & Hava Durumu',
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, index) => const SizedBox(height: 10),
          itemBuilder: (context, idx) {
            final day = items[idx];
            final dayName = AppDateUtils.formatDayName(day.date);
            final dateStr = AppDateUtils.formatShortDate(day.date);

            return GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(day.icon, color: primaryColor, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              dayName,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              dateStr,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          day.conditionDescription,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${day.maxTemp.toStringAsFixed(0)}°',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${day.minTemp.toStringAsFixed(0)}°',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                      if (day.precipitationProbability > 0) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.water_drop, size: 11, color: AppColors.info),
                            const SizedBox(width: 2),
                            Text(
                              '%${day.precipitationProbability}',
                              style: GoogleFonts.inter(fontSize: 11, color: AppColors.info, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
