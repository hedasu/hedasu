import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_container.dart';

class WeightGaugeCard extends StatelessWidget {
  final double currentKg;
  final double limitKg;

  const WeightGaugeCard({
    super.key,
    required this.currentKg,
    required this.limitKg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final ratio = (currentKg / limitKg).clamp(0.0, 1.0);
    final isOver = currentKg > limitKg;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
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
                  color: (isOver ? warningColor : primaryColor).withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.scale_rounded,
                  color: isOver ? warningColor : primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tahmini Ağırlık',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      'Kabin bagajı sınırı: 8.0 kg',
                      style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                '${currentKg.toStringAsFixed(1)} kg',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isOver ? warningColor : primaryColor,
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
                isOver ? warningColor : primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0 kg', style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
              Text(
                isOver ? 'Sınır Aşıldı (+${(currentKg - limitKg).toStringAsFixed(1)} kg)' : 'Kabin Limitinde',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isOver ? warningColor : AppColors.success,
                ),
              ),
              Text('${limitKg.toStringAsFixed(0)} kg limit', style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
