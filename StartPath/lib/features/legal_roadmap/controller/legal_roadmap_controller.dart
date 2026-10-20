import 'package:flutter/foundation.dart';
import '../models/legal_step_model.dart';

/// Hukuki Yol Haritası Kontrolcüsü
class LegalRoadmapController {
  final ValueNotifier<List<LegalStepModel>> steps =
      ValueNotifier<List<LegalStepModel>>(LegalStepModel.defaults);

  int get completedCount => steps.value.where((s) => s.isCompleted).length;
  double get progressPercentage =>
      steps.value.isEmpty ? 0.0 : completedCount / steps.value.length;

  void toggleStep(String id) {
    steps.value = steps.value.map((s) {
      if (s.id == id) {
        return s.copyWith(isCompleted: !s.isCompleted);
      }
      return s;
    }).toList();
  }

  void dispose() {
    steps.dispose();
  }
}
