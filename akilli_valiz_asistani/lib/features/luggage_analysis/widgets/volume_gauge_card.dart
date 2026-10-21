import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_container.dart';

class VolumeGaugeCard extends StatelessWidget {
  final double currentLiters;
  final double limitLiters;

  const VolumeGaugeCard({
    super.key,
    required this.currentLiters,
    required this.limitLiters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final ratio = (currentLiters / limitLiters).clamp(0.0, 1.0);
    final isOver = currentLiters > limitLiters;

    final secondaryColor = isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    final warningColor = AppColors.warning;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final progressBg = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: (isOver ? warningColor : secondaryColor).withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.view_in_ar_rounded,
                  color: isOver ? warningColor : secondaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tahmini Hacim',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      'Kabin valizi kapasitesi: 40 L',
                      style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                '${currentLiters.toStringAsFixed(1)} L',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isOver ? warningColor : secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: progressBg,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOver ? warningColor : secondaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0 L', style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
              Text(
                isOver ? 'Kapasite Aşıldı (+${(currentLiters - limitLiters).toStringAsFixed(1)} L)' : 'Hacim İdeal',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isOver ? warningColor : AppColors.success,
                ),
              ),
              Text('${limitLiters.toStringAsFixed(0)} L sınır', style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
