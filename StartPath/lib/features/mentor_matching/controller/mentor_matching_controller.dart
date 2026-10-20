import 'package:flutter/foundation.dart';
import '../models/mentor_profile_model.dart';

/// Mentor Eşleştirme ve Randevu Kontrolcüsü
class MentorMatchingController {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);
  final ValueNotifier<List<MentorProfileModel>> mentors =
      ValueNotifier<List<MentorProfileModel>>(MentorProfileModel.samples);
  final ValueNotifier<String> selectedSector = ValueNotifier<String>('Tümü');

  List<MentorProfileModel> get filteredMentors {
    if (selectedSector.value == 'Tümü') return mentors.value;
    return mentors.value
        .where((m) => m.sector.toLowerCase() == selectedSector.value.toLowerCase())
        .toList();
  }

  void filterSector(String sector) {
    selectedSector.value = sector;
  }

  Future<void> reload() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      mentors.value = MentorProfileModel.samples;
    } catch (e) {
      errorMessage.value = 'Mentor listesi yüklenemedi.';
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    isLoading.dispose();
    errorMessage.dispose();
    mentors.dispose();
    selectedSector.dispose();
  }
}
