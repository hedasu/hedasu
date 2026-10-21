import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/glass_container.dart';
import '../../packing_list/models/packing_item_model.dart';
import 'checklist_item_tile.dart';

class PackedItemsSection extends StatelessWidget {
  final List<PackingItemModel> items;
  final Function(String id) onToggle;

  const PackedItemsSection({
    super.key,
    required this.items,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
            const SizedBox(width: 8),
            Text(
              '${AppStrings.packedSection} (${items.length})',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Henüz valize yerleştirilen eşya yok. Yukarıdaki eşyaları işaretleyerek buraya taşıyabilirsiniz.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, index) => const SizedBox(height: 8),
            itemBuilder: (context, idx) {
              final it = items[idx];
              return ChecklistItemTile(
                item: it,
                onToggle: () => onToggle(it.id),
              );
            },
          ),
      ],
    );
  }
}
