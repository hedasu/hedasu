import 'package:flutter/material.dart';
import '../../../core/widgets/app_empty_view.dart';
import '../../../core/widgets/app_loading_view.dart';
import '../controller/mentor_matching_controller.dart';
import '../models/mentor_profile_model.dart';
import '../widgets/mentor_card.dart';

class MentorMatchingView extends StatelessWidget {
  final MentorMatchingController controller;
  final ValueChanged<MentorProfileModel> onBookSession;

  const MentorMatchingView({
    super.key,
    required this.controller,
    required this.onBookSession,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentorlar'),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.reload,
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.isLoading,
          builder: (context, loading, _) {
            if (loading) return const AppLoadingView();
            return _MentorListBody(controller: controller, onBookSession: onBookSession);
          },
        ),
      ),
    );
  }
}

class _MentorListBody extends StatelessWidget {
  final MentorMatchingController controller;
  final ValueChanged<MentorProfileModel> onBookSession;

  const _MentorListBody({required this.controller, required this.onBookSession});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([controller.mentors, controller.selectedSector]),
      builder: (context, _) {
        final list = controller.filteredMentors;
        if (list.isEmpty) {
          return const AppEmptyView(
            icon: Icons.person_off_outlined,
            title: 'Mentor Bulunamadı',
            subtitle: 'Seçili kriterlerde aktif mentor bulunamadı.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final mentor = list[index];
            return MentorCard(
              mentor: mentor,
              onBookSession: () => onBookSession(mentor),
            );
          },
        );
      },
    );
  }
}
