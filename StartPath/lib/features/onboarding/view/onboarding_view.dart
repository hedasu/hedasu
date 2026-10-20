import 'package:flutter/material.dart';
import '../controller/onboarding_controller.dart';
import '../widgets/role_selection_card.dart';

class OnboardingView extends StatelessWidget {
  final OnboardingController controller;
  final ValueChanged<String>? onRoleConfirmed;

  const OnboardingView({
    super.key,
    required this.controller,
    this.onRoleConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Girişim Yolculuğun')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const _IntroSection(),
              const SizedBox(height: 16),
              Expanded(child: _RoleList(controller: controller)),
              _ConfirmButton(controller: controller, onRoleConfirmed: onRoleConfirmed),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroSection extends StatelessWidget {
  const _IntroSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'StartPath\'e Hoş Geldin',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Platform deneyimini kişiselleştirmek için başlangıç rolünü seç:',
          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _RoleList extends StatelessWidget {
  final OnboardingController controller;

  const _RoleList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: controller.selectedRoleId,
      builder: (context, selectedId, _) {
        return ListView.builder(
          itemCount: controller.roles.length,
          itemBuilder: (context, index) {
            final role = controller.roles[index];
            return RoleSelectionCard(
              role: role,
              isSelected: selectedId == role.id,
              onTap: () => controller.selectRole(role.id),
            );
          },
        );
      },
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final OnboardingController controller;
  final ValueChanged<String>? onRoleConfirmed;

  const _ConfirmButton({required this.controller, this.onRoleConfirmed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          final id = controller.selectedRoleId.value ?? 'idea';
          onRoleConfirmed?.call(id);
        },
        child: const Text('Devam Et'),
      ),
    );
  }
}
