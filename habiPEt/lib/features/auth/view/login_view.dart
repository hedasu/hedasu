import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/router/app_router.dart';
import '../widgets/auth_text_field.dart';
import '../../../core/widgets/app_logo.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController(text: 'deniz@habipet.app');
  final _passwordController = TextEditingController(text: '123456');
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final auth = AppScope.of(context).authController;
    auth.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    Navigator.of(context).pushReplacementNamed(AppRouter.initialRoute);
  }

  void _guestLogin() {
    final auth = AppScope.of(context).authController;
    auth.loginAsGuest();
    Navigator.of(context).pushReplacementNamed(AppRouter.initialRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _AuthHeaderSection(),
                const SizedBox(height: 32),
                AuthTextField(
                  controller: _emailController,
                  label: 'E-posta',
                  hint: 'ornek@habipet.app',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Şifre',
                  hint: '••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                ),
                const SizedBox(height: 24),
                _AuthActionButtons(
                  isLogin: _isLogin,
                  onSubmit: _submit,
                  onGuestLogin: _guestLogin,
                ),
                const SizedBox(height: 16),
                _ToggleAuthModeButton(
                  isLogin: _isLogin,
                  onToggle: () => setState(() => _isLogin = !_isLogin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthHeaderSection extends StatelessWidget {
  const _AuthHeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.darkMint.withValues(alpha: 0.28),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const AppLogo(size: 92),
        ),
        const SizedBox(height: 16),
        const Text(
          'habiPEt',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Alışkanlıklarını Büyüt, Evcil Hayvanını Geliştir',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}

class _AuthActionButtons extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onSubmit;
  final VoidCallback onGuestLogin;

  const _AuthActionButtons({
    required this.isLogin,
    required this.onSubmit,
    required this.onGuestLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: onSubmit,
          child: Text(isLogin ? 'Giriş Yap' : 'Kayıt Ol'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onGuestLogin,
          child: const Text('Misafir Olarak Keşfet'),
        ),
      ],
    );
  }
}

class _ToggleAuthModeButton extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggle;

  const _ToggleAuthModeButton({
    required this.isLogin,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onToggle,
      child: Text(
        isLogin
            ? 'Hesabın yok mu? Hemen Kayıt Ol'
            : 'Zaten hesabın var mı? Giriş Yap',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
