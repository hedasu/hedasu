import 'package:flutter/material.dart';

// ==============================================================================
// StartPath Referans Ekran Örneği (Sample Screen)
// project.md & SKILL.md kurallarına tam uyumludur:
// 1. const kullanımı
// 2. build() metodlarının 40 satırı geçmemesi
// 3. ValueListenableBuilder ile reaktif ve scoped render
// 4. Material 3 Modern Professional tema renklerinin kullanımı
// ==============================================================================

/// Örnek Mentor Profili Modeli
class SampleMentorModel {
  final String id;
  final String name;
  final String role;
  final String company;
  final double rating;
  final bool isVerified;
  final List<String> tags;

  const SampleMentorModel({
    required this.id,
    required this.name,
    required this.role,
    required this.company,
    required this.rating,
    required this.isVerified,
    required this.tags,
  });
}

/// Örnek Controller (ValueNotifier)
class SampleMentorController {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<SampleMentorModel>> mentors =
      ValueNotifier<List<SampleMentorModel>>([
    const SampleMentorModel(
      id: 'm1',
      name: 'Selim Arslan',
      role: 'Kıdemli Girişim Danışmanı',
      company: 'ScaleX Capital',
      rating: 4.95,
      isVerified: true,
      tags: ['SaaS', 'Yatırım', 'GTM Stratejisi'],
    ),
    const SampleMentorModel(
      id: 'm2',
      name: 'Deniz Kaya',
      role: 'Fintek Kurucu Ortağı',
      company: 'PayFlow Tech',
      rating: 4.88,
      isVerified: true,
      tags: ['Fintek', 'B2B', 'Şirketleşme'],
    ),
  ]);

  void dispose() {
    isLoading.dispose();
    mentors.dispose();
  }
}

/// Ana Ekran (View) - build metodu < 40 satır
class SampleMentorScreen extends StatelessWidget {
  final SampleMentorController controller;

  const SampleMentorScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Keşfet'),
        centerTitle: false,
        actions: const [
          _NotificationBadgeButton(),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.isLoading,
          builder: (context, loading, _) {
            if (loading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            return _MentorListView(controller: controller);
          },
        ),
      ),
    );
  }
}

/// Liste Gövdesi Widget'ı - build < 40 satır
class _MentorListView extends StatelessWidget {
  final SampleMentorController controller;

  const _MentorListView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SampleMentorModel>>(
      valueListenable: controller.mentors,
      builder: (context, mentors, _) {
        if (mentors.isEmpty) {
          return const Center(child: Text('Kayıtlı mentor bulunamadı.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: mentors.length,
          itemBuilder: (context, index) {
            return _SampleMentorCard(mentor: mentors[index]);
          },
        );
      },
    );
  }
}

/// Modüler Mentor Kartı - build < 40 satır
class _SampleMentorCard extends StatelessWidget {
  final SampleMentorModel mentor;

  const _SampleMentorCard({required this.mentor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHeader(mentor: mentor, colorScheme: colorScheme, theme: theme),
            const SizedBox(height: 6),
            Text(
              '${mentor.role} • ${mentor.company}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _TagWrap(tags: mentor.tags),
          ],
        ),
      ),
    );
  }
}

/// Kart Başlık Bölümü - build < 40 satır
class _CardHeader extends StatelessWidget {
  final SampleMentorModel mentor;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _CardHeader({
    required this.mentor,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                mentor.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (mentor.isVerified) ...[
                const SizedBox(width: 6),
                Icon(Icons.verified_rounded, size: 18, color: colorScheme.primary),
              ],
            ],
          ),
        ),
        Icon(Icons.star_rounded, size: 18, color: Colors.amber.shade700),
        const SizedBox(width: 4),
        Text(
          mentor.rating.toStringAsFixed(2),
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// Etiketler Bölümü - build < 40 satır
class _TagWrap extends StatelessWidget {
  final List<String> tags;

  const _TagWrap({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tags.map((t) {
        return Chip(
          label: Text(t, style: const TextStyle(fontSize: 12)),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}

/// AppBar Aksiyon Butonu
class _NotificationBadgeButton extends StatelessWidget {
  const _NotificationBadgeButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications_none_rounded),
      tooltip: 'Bildirimler',
      onPressed: () {},
    );
  }
}
