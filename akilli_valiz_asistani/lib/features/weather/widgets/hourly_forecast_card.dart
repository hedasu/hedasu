import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/weather_model.dart';

class HourlyForecastCard extends StatelessWidget {
  final List<HourlyWeatherItem> items;

  const HourlyForecastCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time_filled_rounded, size: 16, color: primaryColor),
            const SizedBox(width: 8),
            Text(
              'Saatlik Hava Durumu Analizi',
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 105,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, index) => const SizedBox(width: 8),
            itemBuilder: (context, idx) {
              final h = items[idx];
              final hourStr = '${h.time.hour.toString().padLeft(2, '0')}:00';
              final dayStr = '${h.time.day}/${h.time.month}';

              return Container(
                width: 76,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$hourStr\n$dayStr',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: textSecondary,
                        height: 1.2,
                      ),
                    ),
                    Icon(h.icon, size: 20, color: primaryColor),
                    Text(
                      '${h.temperature.toStringAsFixed(0)}°C',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
