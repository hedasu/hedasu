import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/shopping_item_model.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItemModel item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const ShoppingItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: item.isPurchased ? selectedColor.withValues(alpha: isDark ? 0.35 : 0.5) : surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isPurchased ? borderColor : primaryColor.withValues(alpha: isDark ? 0.3 : 0.2),
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
          Checkbox(
            value: item.isPurchased,
            activeColor: primaryColor,
            checkColor: isDark ? const Color(0xFF101C1B) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onChanged: (_) => onToggle(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: item.isPurchased ? TextDecoration.lineThrough : null,
                    color: item.isPurchased ? textSecondary : textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      item.category,
                      style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                    ),
                    if (item.estimatedPrice != null) ...[
                      Text(' • ', style: TextStyle(color: textSecondary)),
                      Text(
                        '₺${item.estimatedPrice!.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkAccent : AppColors.lightSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
