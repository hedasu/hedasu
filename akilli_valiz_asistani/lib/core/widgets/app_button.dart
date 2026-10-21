import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Atlas & Sage — 14px yuvarlatılmış köşelere, 52-56px yüksekliğe ve yumuşak geçişe sahip buton bileşeni
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final bool isSecondary;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.isSecondary = false,
    this.width,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final disabled = onPressed == null || isLoading;

    // Renk hesaplamaları
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final secondaryColor = isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    final onPrimaryColor = isDark ? const Color(0xFF101C1B) : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            elevation: 0,
            side: BorderSide(color: borderColor, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          onPressed: disabled ? null : onPressed,
          child: _buildContent(context, textColor),
        ),
      );
    }

    final buttonBg = isSecondary
        ? secondaryColor
        : primaryColor;

    final contentColor = isSecondary ? Colors.white : onPrimaryColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: disabled ? (isDark ? AppColors.darkBorder : AppColors.lightBorder) : buttonBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: disabled
            ? []
            : [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.18)
                      : buttonBg.withValues(alpha: 0.16),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: disabled ? null : onPressed,
          child: Center(
            child: _buildContent(
              context,
              disabled ? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary) : contentColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color color) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    final textWidget = Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          textWidget,
        ],
      );
    }

    return textWidget;
  }
}
