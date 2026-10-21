import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/packpilot_logo.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_form_card.dart';

class AuthView extends StatefulWidget {
  final StorageService storageService;

  const AuthView({super.key, required this.storageService});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late final AuthController controller;

  @override
  void initState() {
    super.initState();
    controller = AuthController(storageService: widget.storageService);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'app_logo',
                    child: PackPilotLogo(size: 72, showText: true, isLight: !isDark),
                  ),
                  const SizedBox(height: 24),
                  AuthFormCard(
                    controller: controller,
                    onSuccess: () {
                      context.go('/home');
                    },
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'PackPilot © 2026 • Atlas & Sage',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
