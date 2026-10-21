import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_container.dart';

class QuickStatsCard extends StatelessWidget {
  final int totalTrips;
  final int totalPacked;
  final int totalUnpacked;
  final int pendingShopping;
  final VoidCallback onShoppingTap;
  final VoidCallback onTripsTap;

  const QuickStatsCard({
    super.key,
    required this.totalTrips,
    required this.totalPacked,
    required this.totalUnpacked,
    required this.pendingShopping,
    required this.onShoppingTap,
    required this.onTripsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final secondaryColor = isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Row(
      children: [
        Expanded(
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            onTap: onTripsTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.flight_takeoff_rounded,
                        size: 18,
                        color: primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$totalTrips',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Kayıtlı Seyahat',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$totalPacked hazır / $totalUnpacked bekleyen',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            onTap: onShoppingTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: secondaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 18,
                        color: secondaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$pendingShopping',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Alınacak Eşya',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Alışveriş listesinde bekliyor',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
