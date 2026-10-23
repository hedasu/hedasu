import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool withBackground;

  const AppLogo({
    super.key,
    this.size = 32,
    this.withBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    if (withBackground) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.22),
        child: Image.asset(
          'assets/images/app_logo_full.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    return Image.asset(
      'assets/images/app_logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
