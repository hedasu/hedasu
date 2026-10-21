import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/glass_container.dart';
import '../../trip_planner/models/trip_planner_model.dart';

class TripAgendaCard extends StatelessWidget {
  final TripPlannerModel trip;
  final VoidCallback onTap;

  const TripAgendaCard({
    super.key,
    required this.trip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final badgeBg = isDark ? AppColors.darkSelected : AppColors.lightSelected;

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.flight_takeoff_rounded, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.destination,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppDateUtils.formatDateRange(trip.startDate, trip.endDate),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        trip.tripType,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${trip.packedCount}/${trip.totalItemsCount} eşya hazır',
                      style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: textSecondary, size: 20),
        ],
      ),
    );
  }
}
