import 'package:flutter/material.dart';

/// Kayıt Rol Seçeneği Modeli
class OnboardingRoleModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  const OnboardingRoleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  static List<OnboardingRoleModel> get defaultRoles => const [
        OnboardingRoleModel(
          id: 'idea',
          title: 'Fikrim Var',
          description:
              'Bir iş fikrim var; ekibimi kurmak, hukuki yol haritamı çizmek ve mentor desteği almak istiyorum.',
          icon: Icons.lightbulb_outline_rounded,
        ),
        OnboardingRoleModel(
          id: 'no_idea',
          title: 'Fikrim Yok',
          description:
              'Yetkinliklerimi değerlendirmek, mevcut girişimlere katılmak ve bir projenin parçası olmak istiyorum.',
          icon: Icons.group_work_outlined,
        ),
        OnboardingRoleModel(
          id: 'mentor',
          title: 'Mentor Olmak İstiyorum',
          description:
              'Sektörel tecrübemle erken aşama girişimcilere rehberlik etmek ve ekosisteme katkı sağlamak istiyorum.',
          icon: Icons.school_outlined,
        ),
      ];
}
