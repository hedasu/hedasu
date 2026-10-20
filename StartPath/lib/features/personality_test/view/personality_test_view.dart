import 'package:flutter/material.dart';
import '../controller/personality_test_controller.dart';
import '../models/personality_test_model.dart';
import '../widgets/personality_notice_card.dart';

class PersonalityTestView extends StatelessWidget {
  final PersonalityTestController controller;
  final VoidCallback? onTestFinished;

  const PersonalityTestView({
    super.key,
    required this.controller,
    this.onTestFinished,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Çalışma Tarzı ve Uyum Testi')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const PersonalityNoticeCard(),
            const SizedBox(height: 16),
            ...controller.questions.map(
              (q) => _QuestionCard(question: q, controller: controller),
            ),
            const SizedBox(height: 16),
            _FinishSection(controller: controller, onFinished: onTestFinished),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final TestQuestionModel question;
  final PersonalityTestController controller;

  const _QuestionCard({required this.question, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Soru ${question.id}: ${question.question}',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<Map<int, int>>(
              valueListenable: controller.selectedAnswers,
              builder: (context, answers, _) {
                final selected = answers[question.id];
                return Column(
                  children: List.generate(question.options.length, (idx) {
                    final isSelected = selected == idx;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(alpha: 0.5),
                        ),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          isSelected
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          color: isSelected ? theme.colorScheme.primary : null,
                          size: 18,
                        ),
                        title: Text(question.options[idx], style: const TextStyle(fontSize: 13)),
                        onTap: () => controller.selectOption(question.id, idx),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FinishSection extends StatelessWidget {
  final PersonalityTestController controller;
  final VoidCallback? onFinished;

  const _FinishSection({required this.controller, this.onFinished});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isCompleted,
      builder: (context, done, _) {
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: done
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Test başarıyla kaydedildi! Profil doluluğu %100 oldu.'),
                      ),
                    );
                    onFinished?.call();
                  }
                : null,
            child: const Text('Testi Tamamla ve Kaydet'),
          ),
        );
      },
    );
  }
}
