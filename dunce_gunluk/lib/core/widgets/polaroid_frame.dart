import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'washi_tape.dart';

/// Nostaljik polaroid çerçeve bileşeni.
class PolaroidFrame extends StatelessWidget {
  final String? imagePath;
  final String? caption;
  final double width;
  final double rotation;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PolaroidFrame({
    super.key,
    this.imagePath,
    this.caption,
    this.width = 180,
    this.rotation = -0.03,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          _buildPolaroidCard(context),
          const Positioned(
            top: -8,
            child: WashiTape(width: 50, height: 16, rotation: 0.04),
          ),
          if (onDelete != null) _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildPolaroidCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 24),
        decoration: BoxDecoration(
          color: AppColors.polaroidBorder,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPhotoArea(),
            if (caption != null && caption!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                caption!,
                style: GoogleFonts.caveat(
                  fontSize: 16,
                  color: const Color(0xFF333333),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return Container(
      height: width * 0.9,
      width: double.infinity,
      color: const Color(0xFFEBE6DC),
      child: imagePath != null && File(imagePath!).existsSync()
          ? Image.file(
              File(imagePath!),
              fit: BoxFit.cover,
            )
          : const Center(
              child: Icon(
                Icons.photo_camera_back_outlined,
                size: 36,
                color: Color(0xFF9E9283),
              ),
            ),
    );
  }

  Widget _buildDeleteButton() {
    return Positioned(
      top: 4,
      right: 4,
      child: GestureDetector(
        onTap: onDelete,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: AppColors.stampRed,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            size: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
