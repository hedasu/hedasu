import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/glass_container.dart';
import '../../packing_list/models/packing_item_model.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../controllers/checklist_controller.dart';
import '../widgets/checklist_item_tile.dart';
import '../widgets/packed_items_section.dart';

class ChecklistView extends StatefulWidget {
  final TripRepository tripRepository;
  final String tripId;

  const ChecklistView({
    super.key,
    required this.tripRepository,
    required this.tripId,
  });

  @override
  State<ChecklistView> createState() => _ChecklistViewState();
}

class _ChecklistViewState extends State<ChecklistView> {
  late final ChecklistController controller;

  @override
  void initState() {
    super.initState();
    controller = ChecklistController(
      tripRepository: widget.tripRepository,
      tripId: widget.tripId,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final progressBg = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.checklistTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<TripPlannerModel?>(
          valueListenable: controller.trip,
          builder: (context, trip, _) {
            if (trip == null) {
              return const Center(child: Text('Seyahat bulunamadı.'));
            }

            return ValueListenableBuilder<List<PackingItemModel>>(
              valueListenable: controller.toPackItems,
              builder: (context, toPack, _) {
                return ValueListenableBuilder<List<PackingItemModel>>(
                  valueListenable: controller.packedItems,
                  builder: (context, packed, _) {
                    final total = toPack.length + packed.length;
                    final ratio = total == 0 ? 0.0 : packed.length / total;
                    final pct = (ratio * 100).toInt();

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Destination & progress banner
                          GlassContainer(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      trip.destination,
                                      style: GoogleFonts.manrope(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '%$pct Hazır',
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: ratio,
                                    minHeight: 7,
                                    backgroundColor: progressBg,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      ratio >= 1.0 ? AppColors.success : primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${packed.length} / $total eşya valize yerleştirildi',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // To Pack Section
                          Row(
                            children: [
                              Icon(Icons.radio_button_unchecked_rounded,
                                  color: primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${AppStrings.toPackSection} (${toPack.length})',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          if (toPack.isEmpty)
                            GlassContainer(
                              padding: const EdgeInsets.all(18),
                              child: Center(
                                child: Text(
                                  'Tebrikler! Bütün eşyalarınızı valize yerleştirdiniz.',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: toPack.length,
                              separatorBuilder: (_, index) => const SizedBox(height: 8),
                              itemBuilder: (context, idx) {
                                final item = toPack[idx];
                                return ChecklistItemTile(
                                  item: item,
                                  onToggle: () => controller.toggleItem(item.id),
                                );
                              },
                            ),

                          const SizedBox(height: 24),

                          // Packed Section (Alınanlar)
                          PackedItemsSection(
                            items: packed,
                            onToggle: (id) => controller.toggleItem(id),
                          ),

                          const SizedBox(height: 28),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: AppStrings.btnAddActivity,
                                  isOutlined: true,
                                  icon: Icons.add_circle_outline_rounded,
                                  onPressed: () {
                                    context.push('/packing-list?tripId=${trip.id}').then((_) {
                                      controller.loadData();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: AppButton(
                                  text: AppStrings.btnFinish,
                                  icon: Icons.check_circle_rounded,
                                  onPressed: () async {
                                    await controller.finishChecklist();
                                    if (context.mounted) {
                                      context.go('/home');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
