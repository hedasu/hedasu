import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../models/trip_type_model.dart';

class TripTypeSelectorCard extends StatelessWidget {
  final TripTypeOption option;
  final bool isSelected;
  final String? selectedSubType;
  final VoidCallback onSelect;
  final Function(String subType) onSubTypeSelect;

  const TripTypeSelectorCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.selectedSubType,
    required this.onSelect,
    required this.onSubTypeSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final cardBg = isDark
        ? (isSelected ? AppColors.darkSelected : AppColors.darkCard)
        : (isSelected ? AppColors.lightSelected : AppColors.lightCard);
    final cardBorder = isSelected ? primaryColor : borderColor;

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderColor: cardBorder,
      backgroundColor: cardBg,
      onTap: onSelect,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(option.icon, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      option.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                color: isSelected ? primaryColor : textSecondary,
                size: 22,
              ),
            ],
          ),

          if (isSelected && option.subTypes.isNotEmpty) ...[
            const SizedBox(height: 14),
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 10),
            Text(
              'Alt Tür Seçimi:',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: option.subTypes.map((sub) {
                final isSubSelected = selectedSubType == sub;
                return ChoiceChip(
                  label: Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSubSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSubSelected ? primaryColor : textPrimary,
                    ),
                  ),
                  selected: isSubSelected,
                  selectedColor: isDark ? AppColors.darkSelected : AppColors.lightSelected,
                  backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                  side: BorderSide(
                    color: isSubSelected ? primaryColor : borderColor,
                    width: isSubSelected ? 1.5 : 1.0,
                  ),
                  onSelected: (_) => onSubTypeSelect(sub),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
