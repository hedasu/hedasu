import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../controllers/packing_list_controller.dart';
import '../models/packing_item_model.dart';

class CategorySectionCard extends StatelessWidget {
  final String categoryTitle;
  final List<PackingItemModel> items;
  final PackingListController controller;
  final VoidCallback onAddItem;

  const CategorySectionCard({
    super.key,
    required this.categoryTitle,
    required this.items,
    required this.controller,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildCategoryIcon(categoryTitle, isDark),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  categoryTitle,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline_rounded, color: primaryColor, size: 22),
                tooltip: 'Bu Kategoriye Eşya Ekle',
                onPressed: onAddItem,
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Bu kategoride henüz eşya yok. "+" ikonuna basarak ekleyin.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, index) => Divider(height: 1, color: borderColor),
              itemBuilder: (context, idx) {
                final item = items[idx];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.totalWeightKg.toStringAsFixed(1)} kg • ${item.totalVolumeLiters.toStringAsFixed(1)} L',
                              style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline, size: 20, color: textSecondary),
                            onPressed: () => controller.updateItemQuantity(item.id, -1),
                          ),
                          Text(
                            '${item.quantity}',
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline, size: 20, color: primaryColor),
                            onPressed: () => controller.updateItemQuantity(item.id, 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                            onPressed: () => controller.deleteItem(item.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(String cat, bool isDark) {
    IconData icon = Icons.inventory_2_outlined;
    Color color = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    if (cat.contains('Giyim')) {
      icon = Icons.checkroom_rounded;
    } else if (cat.contains('Sağlık')) {
      icon = Icons.medical_services_outlined;
      color = AppColors.error;
    } else if (cat.contains('Teknolojik')) {
      icon = Icons.devices_rounded;
      color = isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    } else if (cat.contains('Aksesuar')) {
      icon = Icons.watch_outlined;
      color = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    } else if (cat.contains('Kişisel Bakım')) {
      icon = Icons.clean_hands_outlined;
      color = AppColors.success;
    } else if (cat.contains('İş')) {
      icon = Icons.business_center_outlined;
      color = isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    } else if (cat.contains('Kamp')) {
      icon = Icons.forest_outlined;
      color = AppColors.success;
    } else if (cat.contains('Plaj') || cat.contains('Yüzme')) {
      icon = Icons.beach_access_rounded;
      color = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    } else if (cat.contains('Kayak')) {
      icon = Icons.downhill_skiing_outlined;
      color = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
