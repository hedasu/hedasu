import 'package:flutter/foundation.dart';
import '../models/opportunity_model.dart';

/// Hibe ve Fırsatlar Kontrolcüsü
class OpportunitiesController {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<OpportunityModel>> opportunities =
      ValueNotifier<List<OpportunityModel>>(OpportunityModel.samples);
  final ValueNotifier<String> selectedFilter = ValueNotifier<String>('Tümü');

  List<OpportunityModel> get filteredList {
    if (selectedFilter.value == 'Tümü') return opportunities.value;
    return opportunities.value
        .where((o) =>
            o.supportType.toLowerCase().contains(selectedFilter.value.toLowerCase()) ||
            o.organization.toLowerCase().contains(selectedFilter.value.toLowerCase()))
        .toList();
  }

  void filterBy(String filter) {
    selectedFilter.value = filter;
  }

  Future<void> refresh() async {
    isLoading.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      opportunities.value = OpportunityModel.samples;
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    isLoading.dispose();
    opportunities.dispose();
    selectedFilter.dispose();
  }
}
