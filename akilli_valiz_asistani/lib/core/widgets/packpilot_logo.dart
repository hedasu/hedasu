import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class PackPilotLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isLight;

  const PackPilotLogo({
    super.key,
    this.size = 48,
    this.showText = false,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.24),
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: isLight ? AppColors.lightPrimary : AppColors.darkPrimary,
              borderRadius: BorderRadius.circular(size * 0.24),
              boxShadow: [
                BoxShadow(
                  color: (isLight ? AppColors.lightPrimary : AppColors.darkPrimary).withValues(alpha: 0.25),
                  blurRadius: size * 0.2,
                  offset: Offset(0, size * 0.08),
                ),
              ],
            ),
            child: Icon(
              Icons.luggage_rounded,
              color: isLight ? Colors.white : const Color(0xFF101C1B),
              size: size * 0.56,
            ),
          );
        },
      ),
    );

    if (!showText) return imageWidget;

    final primaryColor = isLight ? AppColors.lightPrimary : AppColors.darkPrimary;
    final textColor = isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary;
    final secondaryTextColor = isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        imageWidget,
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                style: GoogleFonts.manrope(
                  fontSize: size * 0.44,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: textColor,
                ),
                children: [
                  const TextSpan(text: 'Pack'),
                  TextSpan(
                    text: 'Pilot',
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              ),
            ),
            Text(
              'AKILLI SEYAHAT ASİSTANI',
              style: GoogleFonts.inter(
                fontSize: size * 0.17,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
