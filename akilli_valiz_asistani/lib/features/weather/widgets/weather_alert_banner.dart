import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class WeatherAlertBanner extends StatelessWidget {
  final List<String> alerts;

  const WeatherAlertBanner({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final alertColor = isDark ? AppColors.darkAccent : AppColors.lightSecondary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: alertColor.withValues(alpha: isDark ? 0.16 : 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: alertColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: alertColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_active_rounded,
              color: alertColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hava Durumu Değişiklik Bildirimi',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: alertColor,
                  ),
                ),
                const SizedBox(height: 3),
                ...alerts.map(
                  (alt) => Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '• $alt',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textPrimary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
