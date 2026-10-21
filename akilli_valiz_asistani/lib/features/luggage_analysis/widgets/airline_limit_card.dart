import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_container.dart';

class AirlineLimitCard extends StatelessWidget {
  final bool isOverLimit;

  const AirlineLimitCard({super.key, required this.isOverLimit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final statusColor = isOverLimit ? AppColors.warning : AppColors.success;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderColor: statusColor.withValues(alpha: 0.4),
      backgroundColor: statusColor.withValues(alpha: isDark ? 0.12 : 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isOverLimit ? Icons.warning_amber_rounded : Icons.verified_rounded,
                color: statusColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isOverLimit ? 'Kabin Bagajı Sınır Uyarısı' : 'Kabin Bagajı Uyumlu',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isOverLimit
                ? 'Eşyalarınızın tahmini toplam ağırlığı veya hacmi 8 kg / 40 L kabin limitini aşıyor. Valizinizi uçak altı kargo bagajı olarak vermeniz gerekebilir.'
                : 'Seçtiğiniz eşyalar standart havayolu kabin bagajı (55x40x23 cm) kurallarına uygundur. Uçağa el bagajı olarak rahatlıkla alabilirsiniz.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kabin Limiti:', style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
              Text('8 kg / 40 Litre', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kayıtlı Bagaj Limiti:', style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
              Text('23 kg / 85 Litre', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}
