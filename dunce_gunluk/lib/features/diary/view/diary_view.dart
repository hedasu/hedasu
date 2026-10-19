import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../controller/diary_controller.dart';
import '../models/diary_entry.dart';
import '../widgets/diary_card.dart';
import 'diary_editor_view.dart';

/// Tüm anı ve günlük sayfalarının kronolojik listesi.
class DiaryView extends StatelessWidget {
  final DiaryController diaryController;

  const DiaryView({
    super.key,
    required this.diaryController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: diaryController,
      builder: (context, _) {
        final entriesList = diaryController.entries.values.toList()
          ..sort((a, b) => b.dateKey.compareTo(a.dateKey));

        if (entriesList.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: entriesList.length,
          itemBuilder: (context, index) {
            final entry = entriesList[index];
            return DiaryCard(
              entry: entry,
              onTap: () => _openEditor(context, entry),
              onDelete: () => _confirmDelete(context, entry.dateKey),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_stories_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Henüz Kayıtlı Bir Hatıra Yok',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Dünün ve bugünün hislerini zamanın sayfalarına mühürlemek için yeni bir sayfa aç.',
              style: GoogleFonts.lora(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit_note),
              label: const Text(AppStrings.startJournaling),
              onPressed: () {
                _openEditor(context, null);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openEditor(BuildContext context, DiaryEntry? entry) {
    final targetDate = entry != null
        ? DateTime.parse(entry.dateKey)
        : DateTime.now();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiaryEditorView(
          selectedDate: targetDate,
          existingEntry: entry,
          diaryController: diaryController,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String dateKey) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteConfirmTitle),
        content: const Text(AppStrings.deleteConfirmMessage),
        actions: [
          TextButton(
            child: const Text(AppStrings.cancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(AppStrings.delete),
            onPressed: () {
              diaryController.deleteEntry(dateKey);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
