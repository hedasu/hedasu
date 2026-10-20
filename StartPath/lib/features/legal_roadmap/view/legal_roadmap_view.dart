import 'package:flutter/material.dart';
import '../controller/legal_roadmap_controller.dart';
import '../models/legal_step_model.dart';
import '../widgets/legal_disclaimer_card.dart';
import '../widgets/legal_step_card.dart';

class LegalRoadmapView extends StatelessWidget {
  final LegalRoadmapController controller;

  const LegalRoadmapView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hukuki Süreç Rehberi')),
      body: SafeArea(
        child: ValueListenableBuilder<List<LegalStepModel>>(
          valueListenable: controller.steps,
          builder: (context, steps, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const LegalDisclaimerCard(),
                const SizedBox(height: 16),
                _ProgressHeader(controller: controller),
                const SizedBox(height: 14),
                ...steps.map(
                  (step) => LegalStepCard(
                    step: step,
                    onToggle: () => controller.toggleStep(step.id),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final LegalRoadmapController controller;

  const _ProgressHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (controller.progressPercentage * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Yol Haritası Tamamlanma Durumu',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '%$percent',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: controller.progressPercentage,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }
}
