import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/glass_container.dart';
import '../controllers/auth_controller.dart';

class AuthFormCard extends StatefulWidget {
  final AuthController controller;
  final VoidCallback onSuccess;

  const AuthFormCard({
    super.key,
    required this.controller,
    required this.onSuccess,
  });

  @override
  State<AuthFormCard> createState() => _AuthFormCardState();
}

class _AuthFormCardState extends State<AuthFormCard> {
  final _emailCtrl = TextEditingController(text: 'gezgin@packpilot.app');
  final _passCtrl = TextEditingController(text: 'pilot1234');
  final _nameCtrl = TextEditingController(text: 'Gezgin Pilot');

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return ValueListenableBuilder<bool>(
      valueListenable: widget.controller.isLoginMode,
      builder: (context, isLogin, _) {
        return GlassContainer(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isLogin ? 'Hoş Geldiniz' : 'Hesap Oluşturun',
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isLogin
                    ? 'Seyahatlerinizi ve akıllı valizlerinizi yönetmek için giriş yapın.'
                    : 'Valiz hazırlık stresine son vermek için hemen katılın.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              if (!isLogin) ...[
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Ad Soyad',
                    prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-Posta Adresi',
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: Icon(Icons.lock_outline_rounded, size: 20),
                ),
              ),
              const SizedBox(height: 16),

              // Error display
              ValueListenableBuilder<String?>(
                valueListenable: widget.controller.errorMessage,
                builder: (context, error, _) {
                  if (error == null) return const SizedBox.shrink();
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      error,
                      style: GoogleFonts.inter(color: AppColors.error, fontSize: 13),
                    ),
                  );
                },
              ),

              // Submit button
              ValueListenableBuilder<bool>(
                valueListenable: widget.controller.isLoading,
                builder: (context, loading, _) {
                  return AppButton(
                    text: isLogin ? 'Giriş Yap' : 'Kayıt Ol',
                    isLoading: loading,
                    icon: isLogin ? Icons.login_rounded : Icons.person_add_rounded,
                    onPressed: () async {
                      final ok = await widget.controller.authenticate(
                        email: _emailCtrl.text,
                        password: _passCtrl.text,
                        name: isLogin ? null : _nameCtrl.text,
                      );
                      if (ok && mounted) {
                        widget.onSuccess();
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 12),

              // Guest button
              AppButton(
                text: 'Misafir Olarak Keşfet',
                isOutlined: true,
                icon: Icons.explore_outlined,
                onPressed: () async {
                  await widget.controller.continueAsGuest();
                  if (mounted) widget.onSuccess();
                },
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: widget.controller.toggleMode,
                child: Text(
                  isLogin
                      ? 'Hesabınız yok mu? Yeni Hesap Oluşturun'
                      : 'Zaten hesabınız var mı? Giriş Yapın',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
