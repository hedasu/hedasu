import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// Günün duygu durumunu mühür şeklinde seçmeyi sağlayan bileşen.
class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final ValueChanged<String> onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  static const List<_MoodItem> _moods = [
    _MoodItem(key: 'happy', label: 'Huzurlu', emoji: '🌿', color: AppColors.sageGreen),
    _MoodItem(key: 'thoughtful', label: 'Dalgın', emoji: '☕', color: AppColors.lightAccent),
    _MoodItem(key: 'melancholy', label: 'Melankolik', emoji: '🍂', color: Color(0xFF9E6240)),
    _MoodItem(key: 'excited', label: 'Coşkulu', emoji: '✨', color: AppColors.lightGold),
    _MoodItem(key: 'grateful', label: 'Müteşekkir', emoji: '💌', color: AppColors.dustyRose),
    _MoodItem(key: 'tired', label: 'Yorgun', emoji: '🌙', color: AppColors.vintageBlue),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _moods.map((item) => _buildMoodChip(item)).toList(),
      ),
    );
  }

  Widget _buildMoodChip(_MoodItem item) {
    final isSelected = selectedMood == item.key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: isSelected,
        avatar: Text(item.emoji, style: const TextStyle(fontSize: 16)),
        label: Text(
          item.label,
          style: GoogleFonts.lora(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onSelected: (_) => onMoodSelected(item.key),
      ),
    );
  }
}

class _MoodItem {
  final String key;
  final String label;
  final String emoji;
  final Color color;

  const _MoodItem({
    required this.key,
    required this.label,
    required this.emoji,
    required this.color,
  });
}
