import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../../home/view/main_shell_view.dart';
import '../../../core/extensions/context_extensions.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'deniz.yilmaz@otovia.com');
  final _passwordController = TextEditingController(text: '123456');
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Üye Girişi')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 12),
                _buildForgotPassword(context),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tekrar Hoş Geldiniz',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Hesabınıza giriş yaparak kiralamanızı yönetin.',
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return AuthTextField(
      controller: _emailController,
      label: 'E-posta veya Telefon Numarası',
      hintText: 'ornek@otovia.com veya 0532...',
      icon: Icons.alternate_email,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'Lütfen e-posta veya telefon giriniz.';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return AuthTextField(
      controller: _passwordController,
      label: 'Şifre',
      hintText: '••••••••',
      icon: Icons.lock_outline,
      isPassword: true,
      validator: (val) {
        if (val == null || val.length < 6) {
          return 'Şifreniz en az 6 karakter olmalıdır.';
        }
        return null;
      },
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          context.showAppSnackBar('Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.');
        },
        child: const Text('Şifremi Unuttum'),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return FilledButton(
      onPressed: _isLoading ? null : _handleLogin,
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Text('Giriş Yap'),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await authController.login(_emailController.text, _passwordController.text);
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShellView()),
      (route) => false,
    );
  }
}
