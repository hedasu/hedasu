import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_header.dart';

class AuthView extends StatelessWidget {
  final AuthController controller;
  final VoidCallback? onLoginSuccess;

  const AuthView({
    super.key,
    required this.controller,
    this.onLoginSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AuthHeader(),
                const SizedBox(height: 32),
                _LoginForm(controller: controller, onLoginSuccess: onLoginSuccess),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final AuthController controller;
  final VoidCallback? onLoginSuccess;

  const _LoginForm({required this.controller, this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'E-posta',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 16),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Şifre',
            prefixIcon: Icon(Icons.lock_outline_rounded),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              controller.loginAsDemo();
              onLoginSuccess?.call();
            },
            child: const Text('Giriş Yap'),
          ),
        ),
      ],
    );
  }
}
