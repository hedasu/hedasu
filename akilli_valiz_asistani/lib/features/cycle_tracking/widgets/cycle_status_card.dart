import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../models/cycle_model.dart';

class CycleStatusCard extends StatelessWidget {
  final CyclePredictionModel prediction;

  const CycleStatusCard({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlap = prediction.hasOverlapWithTrip;

    final statusColor = overlap ? AppColors.warning : AppColors.success;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderColor: statusColor.withValues(alpha: 0.4),
      backgroundColor: statusColor.withValues(alpha: isDark ? 0.12 : 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  overlap ? Icons.event_busy_rounded : Icons.event_available_rounded,
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      overlap ? 'Seyahat Tarihi Çakışması' : 'Döngü & Seyahat Uyumu',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tahmini Dönem: ${prediction.nextEstimatedStart.day}/${prediction.nextEstimatedStart.month} - ${prediction.nextEstimatedEnd.day}/${prediction.nextEstimatedEnd.month}',
                      style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            prediction.advisoryMessage,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
