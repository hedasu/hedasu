import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Nostaljik mühür / duygu damgası bileşeni.
class VintageStamp extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final double size;
  final double rotation;

  const VintageStamp({
    super.key,
    required this.label,
    this.icon,
    this.color = AppColors.stampRed,
    this.size = 64,
    this.rotation = -0.08,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: 0.85),
            width: 2,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    size: size * 0.35,
                    color: color.withValues(alpha: 0.9),
                  ),
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: size * 0.16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                    color: color.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
