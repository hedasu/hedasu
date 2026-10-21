import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Atlas & Sage — Sade, zarif, 18px yuvarlatılmış ve ince kenarlıklı kart bileşeni
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Gradient? gradient;
  final bool isSelected;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 18,
    this.backgroundColor,
    this.borderColor,
    this.gradient,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBg = isDark
        ? (isSelected ? AppColors.darkSelected : AppColors.darkCard)
        : (isSelected ? AppColors.lightSelected : AppColors.lightCard);

    final defaultBorder = isDark
        ? (isSelected ? AppColors.darkPrimary : AppColors.darkBorder)
        : (isSelected ? AppColors.lightPrimary : AppColors.lightBorder);

    final bg = backgroundColor ?? defaultBg;
    final border = borderColor ?? defaultBorder;

    final boxDecoration = BoxDecoration(
      color: gradient == null ? bg : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: border,
        width: isSelected ? 1.5 : 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.14)
              : Colors.black.withValues(alpha: 0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );

    if (onTap != null) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        margin: margin,
        decoration: boxDecoration,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onTap,
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      margin: margin,
      padding: padding,
      decoration: boxDecoration,
      child: child,
    );
  }
}
