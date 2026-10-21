import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../models/recommendation_model.dart';

class RecommendationCard extends StatelessWidget {
  final RecommendationItem item;
  final bool isAlreadyAdded;
  final VoidCallback onAdd;

  const RecommendationCard({
    super.key,
    required this.item,
    required this.isAlreadyAdded,
    required this.onAdd,
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
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.isWeatherBased
                  ? primaryColor.withValues(alpha: isDark ? 0.2 : 0.12)
                  : badgeBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              size: 20,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    if (item.isWeatherBased)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Hava Bazlı',
                          style: GoogleFonts.inter(fontSize: 10, color: primaryColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  item.reason,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.category,
                        style: GoogleFonts.inter(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(
                          color: isAlreadyAdded ? AppColors.success : primaryColor,
                        ),
                        foregroundColor: isAlreadyAdded ? AppColors.success : primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: isAlreadyAdded ? null : onAdd,
                      icon: Icon(
                        isAlreadyAdded ? Icons.check_circle_rounded : Icons.add_rounded,
                        size: 14,
                      ),
                      label: Text(
                        isAlreadyAdded ? 'Listede' : 'Listeme Ekle',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
