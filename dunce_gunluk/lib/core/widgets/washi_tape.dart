import 'package:flutter/material.dart';

/// Nostaljik dekoratif yapışkan bant (Washi Tape) bileşeni.
class WashiTape extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final double rotation;

  const WashiTape({
    super.key,
    this.width = 70,
    this.height = 18,
    this.color,
    this.rotation = -0.05,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tapeColor = color ??
        (isDark ? const Color(0xBB795548) : const Color(0xCCE6D2B5));

    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: tapeColor,
          borderRadius: BorderRadius.circular(1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}
