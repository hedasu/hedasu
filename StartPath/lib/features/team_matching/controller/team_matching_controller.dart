import 'package:flutter/foundation.dart';
import '../models/team_post_model.dart';

/// Ekip Bulma ve İlan Kontrolcüsü
class TeamMatchingController {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);
  final ValueNotifier<List<TeamPostModel>> posts =
      ValueNotifier<List<TeamPostModel>>(TeamPostModel.samples);
  final ValueNotifier<String> selectedSector = ValueNotifier<String>('Tümü');

  List<TeamPostModel> get filteredPosts {
    if (selectedSector.value == 'Tümü') return posts.value;
    return posts.value
        .where((p) => p.sector.toLowerCase().contains(selectedSector.value.toLowerCase()))
        .toList();
  }

  void filterSector(String sector) {
    selectedSector.value = sector;
  }

  Future<void> refreshPosts() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      posts.value = TeamPostModel.samples;
    } catch (e) {
      errorMessage.value = 'İlanlar yüklenirken bir sorun oluştu.';
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    isLoading.dispose();
    errorMessage.dispose();
    posts.dispose();
    selectedSector.dispose();
  }
}
