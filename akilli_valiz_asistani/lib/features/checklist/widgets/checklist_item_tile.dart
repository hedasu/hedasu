import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../packing_list/models/packing_item_model.dart';

class ChecklistItemTile extends StatelessWidget {
  final PackingItemModel item;
  final VoidCallback onToggle;

  const ChecklistItemTile({
    super.key,
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final selectedColor = isDark ? AppColors.darkSelected : AppColors.lightSelected;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: item.isPacked ? selectedColor.withValues(alpha: isDark ? 0.4 : 0.6) : surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.isPacked ? borderColor : primaryColor.withValues(alpha: isDark ? 0.3 : 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: item.isPacked ? AppColors.success : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: item.isPacked ? AppColors.success : borderColor,
                  width: 1.8,
                ),
              ),
              child: item.isPacked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: item.isPacked ? TextDecoration.lineThrough : null,
                      color: item.isPacked ? textSecondary : textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.category} • ${item.quantity} adet • ${item.totalWeightKg.toStringAsFixed(1)} kg',
                    style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                item.isPacked ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
                color: item.isPacked ? textSecondary : primaryColor,
                size: 20,
              ),
              onPressed: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}
