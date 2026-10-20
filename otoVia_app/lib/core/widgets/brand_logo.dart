import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = 32,
    this.showText = true,
    this.fontSize = 20,
  });

  final double size;
  final bool showText;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLogoImage(),
        if (showText) ...[
          const SizedBox(width: 10),
          _buildBrandText(context),
        ],
      ],
    );
  }

  Widget _buildLogoImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.25),
      child: Image.asset(
        AppAssets.logo,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
          child: Center(
            child: Text(
              'oV',
              style: TextStyle(
                color: const Color(0xFFC0B09A),
                fontWeight: FontWeight.bold,
                fontSize: size * 0.45,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandText(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'oto',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          TextSpan(
            text: 'Via',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
