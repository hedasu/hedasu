import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/packpilot_logo.dart';

class HomeAppBar extends StatelessWidget {
  final String userName;
  final VoidCallback onProfileTap;

  const HomeAppBar({
    super.key,
    required this.userName,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Row(
      children: [
        PackPilotLogo(size: 42, showText: true, isLight: !isDark),
        const Spacer(),
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onProfileTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                  child: Icon(Icons.person_rounded, size: 16, color: primaryColor),
                ),
                const SizedBox(width: 8),
                Text(
                  userName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
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
