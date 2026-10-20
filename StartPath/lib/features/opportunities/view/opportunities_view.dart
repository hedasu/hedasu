import 'package:flutter/material.dart';
import '../../../core/widgets/app_empty_view.dart';
import '../../../core/widgets/app_loading_view.dart';
import '../controller/opportunities_controller.dart';
import '../models/opportunity_model.dart';
import '../widgets/opportunity_card.dart';

class OpportunitiesView extends StatelessWidget {
  final OpportunitiesController controller;
  final ValueChanged<OpportunityModel> onSelectOpportunity;

  const OpportunitiesView({
    super.key,
    required this.controller,
    required this.onSelectOpportunity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Girişimcilik Fırsatları'),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.refresh,
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.isLoading,
          builder: (context, loading, _) {
            if (loading) return const AppLoadingView();
            return _ListBody(controller: controller, onSelect: onSelectOpportunity);
          },
        ),
      ),
    );
  }
}

class _ListBody extends StatelessWidget {
  final OpportunitiesController controller;
  final ValueChanged<OpportunityModel> onSelect;

  const _ListBody({required this.controller, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([controller.opportunities, controller.selectedFilter]),
      builder: (context, _) {
        final list = controller.filteredList;
        if (list.isEmpty) {
          return const AppEmptyView(
            icon: Icons.campaign_outlined,
            title: 'Fırsat Bulunamadı',
            subtitle: 'Arama kriterlerinize uygun hibe veya destek bulunamadı.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final opp = list[index];
            return OpportunityCard(
              opportunity: opp,
              onDetails: () => onSelect(opp),
            );
          },
        );
      },
    );
  }
}
