import 'package:flutter/material.dart';
import '../../../core/widgets/brand_logo.dart';
import 'login_view.dart';
import 'register_view.dart';

/// otoVia Karşılama (Onboarding / Welcome) Ekranı
///
/// Kullanıcı uygulamayı ilk açtığında veya çıkış yaptığında markayı tanıtan
/// minimalist bir başlık, açıklama ve "Üye Girişi" / "Üye Ol" seçenekleri sunar.
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              // Marka logosu ve başlığı
              const BrandLogo(size: 56, fontSize: 32),
              const SizedBox(height: 20),
              _buildHeadline(theme),
              const SizedBox(height: 12),
              _buildSubhead(theme),
              const Spacer(),
              // Aksiyon butonları (Giriş Yap ve Kayıt Ol)
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Karşılama ekranı ana başlığı
  Widget _buildHeadline(ThemeData theme) {
    return Text(
      'Ayrıcalıklı Sürüş\nDeneyimi.',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -1,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  /// Karşılama ekranı alt açıklama metni
  Widget _buildSubhead(ThemeData theme) {
    return Text(
      'Motosikletten lüks SUV ve ticari araçlara kadar dilediğiniz aracı saatlik veya günlük rezerve edin.',
      style: TextStyle(
        fontSize: 15,
        height: 1.4,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Üye Girişi ve Üye Ol yönlendirme butonları
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginView()),
            ),
            child: const Text('Üye Girişi'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterView()),
            ),
            child: const Text('Üye Ol'),
          ),
        ),
      ],
    );
  }
}
