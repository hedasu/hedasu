import 'package:flutter/material.dart';
import '../controller/profile_controller.dart';
import '../models/profile_details_model.dart';
import '../widgets/profile_header_card.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller;
  final VoidCallback onNavigateSettings;
  final VoidCallback onNavigateApplications;
  final VoidCallback onNavigateNotifications;

  const ProfileView({
    super.key,
    required this.controller,
    required this.onNavigateSettings,
    required this.onNavigateApplications,
    required this.onNavigateNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        actions: [
          IconButton(
            tooltip: 'Bildirimler',
            icon: const Icon(Icons.notifications_outlined),
            onPressed: onNavigateNotifications,
          ),
          IconButton(
            tooltip: 'Ayarlar',
            icon: const Icon(Icons.settings_outlined),
            onPressed: onNavigateSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<ProfileDetailsModel>(
          valueListenable: controller.profile,
          builder: (context, data, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProfileHeaderCard(profile: data),
                const SizedBox(height: 14),
                _MentorsCard(mentors: data.connectedMentors),
                const SizedBox(height: 14),
                _ActionList(onApplications: onNavigateApplications),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MentorsCard extends StatelessWidget {
  final List<String> mentors;

  const _MentorsCard({required this.mentors});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.handshake_outlined, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Mentorlarım',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...mentors.map(
              (m) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(m, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionList extends StatelessWidget {
  final VoidCallback onApplications;

  const _ActionList({required this.onApplications});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Ekip Başvurularım'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: onApplications,
          ),
        ],
      ),
    );
  }
}
