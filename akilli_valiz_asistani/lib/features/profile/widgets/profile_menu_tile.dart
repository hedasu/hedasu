import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool isDestructive;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultIconColor = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary);

    final effectiveIconColor = iconColor ?? defaultIconColor;

    final textColor = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: effectiveIconColor.withValues(alpha: isDark ? 0.2 : 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: effectiveIconColor,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: secondaryTextColor,
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right_rounded,
                  color: secondaryTextColor,
                  size: 20,
                )
              : null),
      onTap: onTap,
    );
  }
}
