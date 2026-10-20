import 'package:flutter/material.dart';
import '../../../core/widgets/app_empty_view.dart';
import '../../../core/widgets/app_loading_view.dart';
import '../controller/team_matching_controller.dart';
import '../models/team_post_model.dart';
import '../widgets/team_post_card.dart';

class TeamMatchingView extends StatelessWidget {
  final TeamMatchingController controller;
  final ValueChanged<TeamPostModel> onApplyPost;

  const TeamMatchingView({
    super.key,
    required this.controller,
    required this.onApplyPost,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ekip Bul'),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.refreshPosts,
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.isLoading,
          builder: (context, loading, _) {
            if (loading) return const AppLoadingView();
            return _PostListBody(controller: controller, onApplyPost: onApplyPost);
          },
        ),
      ),
    );
  }
}

class _PostListBody extends StatelessWidget {
  final TeamMatchingController controller;
  final ValueChanged<TeamPostModel> onApplyPost;

  const _PostListBody({required this.controller, required this.onApplyPost});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([controller.posts, controller.selectedSector]),
      builder: (context, _) {
        final list = controller.filteredPosts;
        if (list.isEmpty) {
          return const AppEmptyView(
            icon: Icons.group_off_outlined,
            title: 'İlan Bulunamadı',
            subtitle: 'Kriterlerinize uygun açık ekip ilanı henüz eklenmedi.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final post = list[index];
            return TeamPostCard(
              post: post,
              onApply: () => onApplyPost(post),
            );
          },
        );
      },
    );
  }
}
