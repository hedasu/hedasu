import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/sticker_item.dart';
import '../../../core/constants/app_colors.dart';

/// Sayfa üzerinde sürüklenebilir ve çift dokunulduğunda silinebilir dijital çıkartma.
class StickerWidget extends StatelessWidget {
  final StickerItem sticker;
  final ValueChanged<Offset> onPositionChanged;
  final VoidCallback onRemove;

  const StickerWidget({
    super.key,
    required this.sticker,
    required this.onPositionChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: sticker.x,
      top: sticker.y,
      child: GestureDetector(
        onPanUpdate: (details) {
          onPositionChanged(
            Offset(sticker.x + details.delta.dx, sticker.y + details.delta.dy),
          );
        },
        onDoubleTap: onRemove,
        child: Transform.rotate(
          angle: sticker.rotation,
          child: Transform.scale(
            scale: sticker.scale,
            child: _buildStickerContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildStickerContent(BuildContext context) {
    if (sticker.type == 'text') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF4E6),
          border: Border.all(color: AppColors.lightBorder, width: 1),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 3,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Text(
          sticker.value,
          style: GoogleFonts.caveat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5A3825),
          ),
        ),
      );
    }

    // Emoji / İkon Çıkartması
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Text(
        sticker.value,
        style: const TextStyle(fontSize: 34),
      ),
    );
  }
}
