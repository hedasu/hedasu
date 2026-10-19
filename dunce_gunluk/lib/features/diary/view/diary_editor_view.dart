import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/paper_background.dart';
import '../../../core/widgets/polaroid_frame.dart';
import '../../../core/widgets/washi_tape.dart';
import '../../stickers/models/sticker_item.dart';
import '../../stickers/view/sticker_picker_sheet.dart';
import '../../stickers/widgets/sticker_widget.dart';
import '../controller/diary_controller.dart';
import '../models/diary_entry.dart';
import '../widgets/mood_selector.dart';

/// Günlük anı yazma, düzenleme ve süsleme ekranı.
class DiaryEditorView extends StatefulWidget {
  final DateTime selectedDate;
  final DiaryEntry? existingEntry;
  final DiaryController diaryController;

  const DiaryEditorView({
    super.key,
    required this.selectedDate,
    this.existingEntry,
    required this.diaryController,
  });

  @override
  State<DiaryEditorView> createState() => _DiaryEditorViewState();
}

class _DiaryEditorViewState extends State<DiaryEditorView> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  String _mood = 'thoughtful';
  String? _imagePath;
  List<StickerItem> _stickers = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingEntry?.title ?? '');
    _contentController =
        TextEditingController(text: widget.existingEntry?.content ?? '');
    _mood = widget.existingEntry?.mood ?? 'thoughtful';
    _imagePath = widget.existingEntry?.imagePath;
    _stickers = widget.existingEntry != null
        ? List.from(widget.existingEntry!.stickers)
        : [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('d MMMM yyyy, EEEE', 'tr_TR').format(widget.selectedDate);

    return Scaffold(
      appBar: _buildAppBar(formattedDate),
      floatingActionButton: _buildStickerFab(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              MoodSelector(
                selectedMood: _mood,
                onMoodSelected: (val) => setState(() => _mood = val),
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildTextScrapbookPage()),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String formattedDate) {
    return AppBar(
      title: Column(
        children: [
          Text(
            widget.existingEntry == null
                ? AppStrings.newEntry
                : AppStrings.editEntry,
            style: GoogleFonts.playfairDisplay(fontSize: 18),
          ),
          Text(
            formattedDate,
            style: GoogleFonts.lora(fontSize: 12, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: AppStrings.saveEntry,
          icon: const Icon(Icons.check_circle_outline),
          onPressed: _saveEntry,
        ),
      ],
    );
  }

  Widget _buildTextScrapbookPage() {
    return Stack(
      children: [
        PaperBackground(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              const Center(child: WashiTape(width: 80, height: 20)),
              const SizedBox(height: 12),
              _buildTitleField(),
              const SizedBox(height: 12),
              _buildPhotoSection(),
              const SizedBox(height: 12),
              _buildContentField(),
            ],
          ),
        ),
        ..._stickers.map((s) => StickerWidget(
              sticker: s,
              onPositionChanged: (pos) {
                setState(() {
                  s.x = pos.dx;
                  s.y = pos.dy;
                });
              },
              onRemove: () {
                setState(() => _stickers.remove(s));
              },
            )),
      ],
    );
  }

  Widget _buildTitleField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: _titleController,
      style: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      decoration: InputDecoration(
        hintText: AppStrings.titleHint,
        hintStyle: TextStyle(
          color: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
              .withValues(alpha: 0.7),
        ),
        border: InputBorder.none,
        isDense: true,
      ),
    );
  }

  Widget _buildContentField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: _contentController,
      maxLines: null,
      style: GoogleFonts.caveat(
        fontSize: 20,
        height: 1.4,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      decoration: InputDecoration(
        hintText: AppStrings.contentHint,
        hintStyle: TextStyle(
          color: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
              .withValues(alpha: 0.7),
        ),
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildPhotoSection() {
    if (_imagePath == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          icon: const Icon(Icons.add_a_photo_outlined, size: 18),
          label: const Text(AppStrings.addPhoto),
          onPressed: _pickPhoto,
        ),
      );
    }

    return Center(
      child: PolaroidFrame(
        imagePath: _imagePath,
        caption: DateFormat('dd.MM.yyyy').format(widget.selectedDate),
        onDelete: () => setState(() => _imagePath = null),
        onTap: _pickPhoto,
      ),
    );
  }

  Future<void> _pickPhoto() async {
    try {
      final XFile? file =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() => _imagePath = file.path);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.photoPermissionDenied)),
        );
      }
    }
  }

  Widget _buildStickerFab() {
    return FloatingActionButton.small(
      heroTag: 'sticker_fab',
      tooltip: AppStrings.selectSticker,
      child: const Icon(Icons.auto_awesome),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (ctx) => StickerPickerSheet(
            onStickerSelected: (stk) {
              setState(() => _stickers.add(stk));
            },
          ),
        );
      },
    );
  }

  void _saveEntry() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty && _imagePath == null && _stickers.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final dateKey = DiaryController.formatDateKey(widget.selectedDate);
    final entry = DiaryEntry(
      id: widget.existingEntry?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      dateKey: dateKey,
      title: title.isEmpty ? 'İsimsiz Hatıra' : title,
      content: content,
      mood: _mood,
      imagePath: _imagePath,
      stickers: _stickers,
      updatedAt: DateTime.now(),
    );

    widget.diaryController.saveEntry(entry);
    Navigator.pop(context);
  }
}
