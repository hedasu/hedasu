import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

/// otoVia Marka Logosu Bileşeni
///
/// Uygulama üst çubuğu (AppBar), karşılama ekranı ve giriş pencerelerinde
/// marka kimliğini tutarlı boyutta ve şık bir tipografiyle sergiler.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = 32,
    this.showText = true,
    this.fontSize = 20,
  });

  /// Logo simgesinin piksel boyutu (kare)
  final double size;

  /// Marka metninin ("otoVia") logonun yanında gösterilip gösterilmeyeceği
  final bool showText;

  /// Marka metninin punto büyüklüğü
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

  /// Logo görselini oluşturan yardımcı metot (görsel yüklenemezse şık harf ikonu gösterir)
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

  /// 'oto' (hafif) ve 'Via' (kalın) kısımlarını stilize eden zengin metin (RichText)
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
