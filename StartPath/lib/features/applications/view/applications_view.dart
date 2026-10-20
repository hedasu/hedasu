import 'package:flutter/material.dart';
import '../../../core/widgets/app_empty_view.dart';
import '../controller/applications_controller.dart';
import '../models/application_model.dart';
import '../widgets/application_card.dart';

class ApplicationsView extends StatelessWidget {
  final ApplicationsController controller;

  const ApplicationsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ekip Başvurularım')),
      body: SafeArea(
        child: ValueListenableBuilder<List<ApplicationModel>>(
          valueListenable: controller.applications,
          builder: (context, list, _) {
            if (list.isEmpty) {
              return const AppEmptyView(
                icon: Icons.inbox_outlined,
                title: 'Henüz Başvuru Yok',
                subtitle: 'Ekip Bul sekmesinden açık ilanları inceleyip başvurabilirsiniz.',
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ApplicationCard(application: list[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
