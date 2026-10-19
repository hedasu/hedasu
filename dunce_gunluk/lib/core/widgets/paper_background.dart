import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Defter çizgileri ve kâğıt dokusu hissi veren arka plan bileşeni.
class PaperBackground extends StatelessWidget {
  final Widget child;
  final bool showLines;
  final EdgeInsetsGeometry padding;

  const PaperBackground({
    super.key,
    required this.child,
    this.showLines = true,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paperColor = isDark ? AppColors.darkPaper : AppColors.lightPaper;
    final lineColor = isDark ? AppColors.darkLine : AppColors.lightLine;

    return Container(
      decoration: BoxDecoration(
        color: paperColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          painter: showLines ? _LinedPaperPainter(lineColor: lineColor) : null,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _LinedPaperPainter extends CustomPainter {
  final Color lineColor;
  static const double lineSpacing = 28.0;

  const _LinedPaperPainter({
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.8;

    double y = lineSpacing + 10;
    while (y < size.height) {
      canvas.drawLine(Offset(12, y), Offset(size.width - 12, y), paint);
      y += lineSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant _LinedPaperPainter oldDelegate) =>
      oldDelegate.lineColor != lineColor;
}
