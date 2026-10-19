import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/diary_entry.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/washi_tape.dart';
import '../../../core/widgets/polaroid_frame.dart';
import '../../../core/widgets/vintage_stamp.dart';

/// Günlük kaydının nostaljik scrapbook kartı görünümü.
class DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const DiaryCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildMainContainer(context),
          const Positioned(
            top: -6,
            left: 24,
            child: WashiTape(width: 60, height: 16),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: _buildMoodStamp(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContainer(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildTitleRow(context),
            const SizedBox(height: 8),
            if (entry.content.isNotEmpty) _buildContentSnippet(context),
            if (entry.imagePath != null) ...[
              const SizedBox(height: 12),
              _buildPhotoThumbnail(),
            ],
            const SizedBox(height: 12),
            _buildFooterRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 60),
      child: Text(
        entry.title,
        style: Theme.of(context).textTheme.titleLarge,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildContentSnippet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      entry.content,
      style: GoogleFonts.caveat(
        fontSize: 18,
        height: 1.4,
        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF3E2E20),
      ),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPhotoThumbnail() {
    return Center(
      child: PolaroidFrame(
        imagePath: entry.imagePath,
        width: 140,
        rotation: 0.02,
      ),
    );
  }

  Widget _buildMoodStamp() {
    return VintageStamp(
      label: entry.mood,
      size: 48,
      color: _getMoodColor(entry.mood),
    );
  }

  Widget _buildFooterRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (entry.stickers.isNotEmpty)
          Row(
            children: entry.stickers
                .take(3)
                .map((s) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(s.value, style: const TextStyle(fontSize: 16)),
                    ))
                .toList(),
          )
        else
          const SizedBox(),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.stampRed),
          tooltip: 'Sayfayı Kopar',
          onPressed: onDelete,
        ),
      ],
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'happy':
        return AppColors.sageGreen;
      case 'melancholy':
        return AppColors.stampRed;
      case 'excited':
        return AppColors.lightGold;
      case 'grateful':
        return AppColors.dustyRose;
      case 'tired':
        return AppColors.vintageBlue;
      default:
        return AppColors.lightAccent;
    }
  }
}
