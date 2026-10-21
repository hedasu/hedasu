import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../controllers/packing_list_controller.dart';
import '../models/packing_item_model.dart';
import '../widgets/add_item_dialog.dart';
import '../widgets/category_section_card.dart';

class PackingListView extends StatefulWidget {
  final TripRepository tripRepository;
  final String tripId;

  const PackingListView({
    super.key,
    required this.tripRepository,
    required this.tripId,
  });

  @override
  State<PackingListView> createState() => _PackingListViewState();
}

class _PackingListViewState extends State<PackingListView> {
  late final PackingListController controller;

  @override
  void initState() {
    super.initState();
    controller = PackingListController(
      tripRepository: widget.tripRepository,
      tripId: widget.tripId,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _openAddItemDialog([String? category]) {
    showDialog(
      context: context,
      builder: (_) => AddItemDialog(controller: controller, initialCategory: category),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final badgeBg = isDark ? AppColors.darkSelected : AppColors.lightSelected;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.packingListTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded, color: primaryColor, size: 22),
            tooltip: 'Yeni Eşya Ekle',
            onPressed: () => _openAddItemDialog(),
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<TripPlannerModel?>(
          valueListenable: controller.trip,
          builder: (context, trip, _) {
            if (trip == null) {
              return const Center(child: Text('Seyahat bulunamadı.'));
            }

            return ValueListenableBuilder<List<PackingItemModel>>(
              valueListenable: controller.items,
              builder: (context, itemsList, _) {
                return ValueListenableBuilder<List<String>>(
                  valueListenable: controller.availableCategories,
                  builder: (context, categories, _) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Wizard Progress (Step 5/5)
                          Row(
                            children: [
                              _buildStepIndicator(step: 1, isActive: true, isDone: true, isDark: isDark),
                              _buildStepConnector(isDone: true, borderColor: borderColor),
                              _buildStepIndicator(step: 2, isActive: true, isDone: true, isDark: isDark),
                              _buildStepConnector(isDone: true, borderColor: borderColor),
                              _buildStepIndicator(step: 3, isActive: true, isDone: true, isDark: isDark),
                              _buildStepConnector(isDone: true, borderColor: borderColor),
                              _buildStepIndicator(step: 4, isActive: true, isDone: true, isDark: isDark),
                              _buildStepConnector(isDone: true, borderColor: borderColor),
                              _buildStepIndicator(step: 5, isActive: true, isDone: false, isDark: isDark),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${trip.destination} Valizi',
                                    style: GoogleFonts.manrope(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Toplam ${itemsList.length} farklı eşya tanımlı',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: badgeBg,
                                  foregroundColor: primaryColor,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () => _openAddItemDialog(),
                                icon: const Icon(Icons.add, size: 16),
                                label: Text(
                                  'Eşya Ekle',
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Render categories
                          ...categories.map((cat) {
                            final catItems = controller.getItemsForCategory(cat);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CategorySectionCard(
                                categoryTitle: cat,
                                items: catItems,
                                controller: controller,
                                onAddItem: () => _openAddItemDialog(cat),
                              ),
                            );
                          }),

                          const SizedBox(height: 18),

                          // Confirm List Button -> Luggage Analysis
                          AppButton(
                            text: AppStrings.btnConfirmList,
                            icon: Icons.check_circle_outline_rounded,
                            onPressed: () {
                              context.push('/luggage-analysis?tripId=${trip.id}');
                            },
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

  Widget _buildStepIndicator({
    required int step,
    required bool isActive,
    required bool isDone,
    required bool isDark,
  }) {
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final inactiveBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final inactiveBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final inactiveText = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.success
            : (isActive ? primaryColor : inactiveBg),
        shape: BoxShape.circle,
        border: Border.all(
          color: isDone
              ? AppColors.success
              : (isActive ? primaryColor : inactiveBorder),
        ),
      ),
      child: Center(
        child: isDone
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : Text(
                '$step',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isActive ? (isDark ? const Color(0xFF101C1B) : Colors.white) : inactiveText,
                ),
              ),
      ),
    );
  }

  Widget _buildStepConnector({required bool isDone, required Color borderColor}) {
    return Expanded(
      child: Container(
        height: 1.5,
        color: isDone ? AppColors.success : borderColor,
        margin: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
