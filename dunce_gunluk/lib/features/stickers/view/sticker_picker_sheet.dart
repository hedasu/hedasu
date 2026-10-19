import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../models/sticker_item.dart';

/// Nostaljik çıkartma seçici alt sayfası.
class StickerPickerSheet extends StatefulWidget {
  final ValueChanged<StickerItem> onStickerSelected;

  const StickerPickerSheet({
    super.key,
    required this.onStickerSelected,
  });

  @override
  State<StickerPickerSheet> createState() => _StickerPickerSheetState();
}

class _StickerPickerSheetState extends State<StickerPickerSheet> {
  final TextEditingController _customTextController = TextEditingController();

  static const List<String> _vintageIcons = [
    '📜', '✒️', '☕', '🕯️', '⏳', '🍂',
    '🗝️', '💌', '🌸', '🏷️', '✨', '🌙',
    '🕊️', '📻', '🎞️', '🕰️', '🎨', '📖',
    '🦋', '🌻', '🧸', '🎻', '🪐', '⛅',
  ];

  static const List<String> _vintageLabels = [
    'Unutulmaz Gün',
    'Günün Düşüncesi',
    'Tatlı Hatıra',
    'Nostalji',
    'Ruhun Sayfası',
    'Bir Zamanlar...',
  ];

  @override
  void dispose() {
    _customTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 420,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkPaper : AppColors.lightPaper,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(),
          _buildHeader(),
          const SizedBox(height: 12),
          _buildCustomTextInput(),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                _buildSectionTitle('Nostaljik Figürler'),
                _buildIconGrid(),
                const SizedBox(height: 16),
                _buildSectionTitle('Etiket & Mühürler'),
                _buildLabelChips(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      AppStrings.stickerLibrary,
      style: GoogleFonts.playfairDisplay(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCustomTextInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _customTextController,
            decoration: InputDecoration(
              hintText: 'Özel not çıkartması yaz...',
              hintStyle: GoogleFonts.lora(fontSize: 13),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _handleAddCustomText,
          child: const Text('Ekle'),
        ),
      ],
    );
  }

  void _handleAddCustomText() {
    final text = _customTextController.text.trim();
    if (text.isEmpty) return;
    widget.onStickerSelected(
      StickerItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: 'text',
        value: text,
      ),
    );
    Navigator.pop(context);
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: GoogleFonts.lora(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildIconGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: _vintageIcons.map((icon) {
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            widget.onStickerSelected(
              StickerItem(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                type: 'icon',
                value: icon,
              ),
            );
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            child: Text(icon, style: const TextStyle(fontSize: 28)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLabelChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _vintageLabels.map((label) {
        return ActionChip(
          label: Text(
            label,
            style: GoogleFonts.caveat(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            widget.onStickerSelected(
              StickerItem(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                type: 'text',
                value: label,
              ),
            );
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }
}
