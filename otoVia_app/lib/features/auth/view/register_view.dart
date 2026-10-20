import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../../home/view/main_shell_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Üye Ol')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildNameFields(),
                const SizedBox(height: 14),
                _buildContactFields(),
                const SizedBox(height: 14),
                _buildPasswordFields(),
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
          'Hesap Oluştur',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Ayrıcalıklı araç kiralama dünyasına katılın.',
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: AuthTextField(
            controller: _nameController,
            label: 'Ad',
            hintText: 'Adınız',
            icon: Icons.person_outline,
            validator: (val) => val == null || val.trim().isEmpty ? 'Gerekli' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AuthTextField(
            controller: _surnameController,
            label: 'Soyad',
            hintText: 'Soyadınız',
            icon: Icons.person_outline,
            validator: (val) => val == null || val.trim().isEmpty ? 'Gerekli' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildContactFields() {
    return Column(
      children: [
        AuthTextField(
          controller: _phoneController,
          label: 'Telefon Numarası',
          hintText: '05XX XXX XX XX',
          keyboardType: TextInputType.phone,
          icon: Icons.phone_outlined,
          validator: (val) => val == null || val.trim().length < 10 ? 'Geçerli telefon giriniz' : null,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          controller: _emailController,
          label: 'E-posta Adresi',
          hintText: 'ornek@otovia.com',
          keyboardType: TextInputType.emailAddress,
          icon: Icons.mail_outline,
          validator: (val) => val == null || !val.contains('@') ? 'Geçerli e-posta giriniz' : null,
        ),
      ],
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        AuthTextField(
          controller: _passwordController,
          label: 'Şifre',
          hintText: 'En az 6 karakter',
          isPassword: true,
          icon: Icons.lock_outline,
          validator: (val) => val == null || val.length < 6 ? 'En az 6 karakter' : null,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          controller: _confirmPasswordController,
          label: 'Şifre Tekrarı',
          hintText: 'Şifrenizi tekrar giriniz',
          isPassword: true,
          icon: Icons.lock_outline,
          validator: (val) {
            if (val != _passwordController.text) {
              return 'Şifreler uyuşmuyor';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return FilledButton(
      onPressed: _isLoading ? null : _handleRegister,
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Text('Üyeliği Tamamla'),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await authController.register(
      name: _nameController.text.trim(),
      surname: _surnameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShellView()),
      (route) => false,
    );
  }
}
