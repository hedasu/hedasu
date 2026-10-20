import 'package:flutter/material.dart';
import '../controller/home_controller.dart';
import '../models/home_dashboard_model.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/startup_banner.dart';

class HomeView extends StatelessWidget {
  final HomeController controller;
  final VoidCallback onNavigateLegal;
  final VoidCallback onNavigateWorkspace;
  final VoidCallback onNavigateStartupForm;
  final VoidCallback onNavigatePersonalityTest;

  const HomeView({
    super.key,
    required this.controller,
    required this.onNavigateLegal,
    required this.onNavigateWorkspace,
    required this.onNavigateStartupForm,
    required this.onNavigatePersonalityTest,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HomeDashboardModel>(
      valueListenable: controller.dashboardData,
      builder: (context, data, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StartupBanner(dashboard: data, onTap: onNavigateStartupForm),
              const SizedBox(height: 16),
              _StatsGrid(data: data),
              const SizedBox(height: 20),
              _QuickActionsSection(
                onLegal: onNavigateLegal,
                onWorkspace: onNavigateWorkspace,
                onStartupForm: onNavigateStartupForm,
                onPersonalityTest: onNavigatePersonalityTest,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final HomeDashboardModel data;

  const _StatsGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatCard(
          title: 'Eşleşen Mentor',
          value: '${data.matchedMentorsCount}',
          icon: Icons.person_search_rounded,
        ),
        const SizedBox(width: 8),
        StatCard(
          title: 'Aktif Başvuru',
          value: '${data.activeApplicationsCount}',
          icon: Icons.assignment_outlined,
        ),
        const SizedBox(width: 8),
        StatCard(
          title: 'Açık Fırsat',
          value: '${data.availableOpportunitiesCount}',
          icon: Icons.workspace_premium_rounded,
        ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  final VoidCallback onLegal;
  final VoidCallback onWorkspace;
  final VoidCallback onStartupForm;
  final VoidCallback onPersonalityTest;

  const _QuickActionsSection({
    required this.onLegal,
    required this.onWorkspace,
    required this.onStartupForm,
    required this.onPersonalityTest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hızlı İşlemler',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        QuickActionCard(
          title: 'Hukuki Süreç Yol Haritası',
          subtitle: 'Şirketleşme, vergi ve tescil rehberinizi inceleyin',
          icon: Icons.gavel_rounded,
          onTap: onLegal,
        ),
        QuickActionCard(
          title: 'Proje Çalışma Alanı',
          subtitle: 'Ekip görevleri, kilometre taşları ve ilerleme',
          icon: Icons.dashboard_customize_rounded,
          onTap: onWorkspace,
        ),
        QuickActionCard(
          title: 'Girişim Bilgilerini Güncelle',
          subtitle: 'Hedefler, aşama ve ekip ihtiyaçlarını düzenleyin',
          icon: Icons.edit_note_rounded,
          onTap: onStartupForm,
        ),
        QuickActionCard(
          title: 'Kişilik ve Çalışma Tarzı Testi',
          subtitle: 'Ekip uyumluluğunu artırmak için testi tamamlayın',
          icon: Icons.psychology_outlined,
          onTap: onPersonalityTest,
        ),
      ],
    );
  }
}
