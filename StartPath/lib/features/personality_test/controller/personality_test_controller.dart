import 'package:flutter/foundation.dart';
import '../models/personality_test_model.dart';

/// Kişilik ve Çalışma Tarzı Test Kontrolcüsü
class PersonalityTestController {
  final List<TestQuestionModel> questions = TestQuestionModel.defaultQuestions;
  final ValueNotifier<Map<int, int>> selectedAnswers =
      ValueNotifier<Map<int, int>>({});
  final ValueNotifier<bool> isCompleted = ValueNotifier<bool>(false);

  void selectOption(int questionId, int optionIndex) {
    final updated = Map<int, int>.from(selectedAnswers.value);
    updated[questionId] = optionIndex;
    selectedAnswers.value = updated;
    if (updated.length == questions.length) {
      isCompleted.value = true;
    }
  }

  void reset() {
    selectedAnswers.value = {};
    isCompleted.value = false;
  }

  void dispose() {
    selectedAnswers.dispose();
    isCompleted.dispose();
  }
}
