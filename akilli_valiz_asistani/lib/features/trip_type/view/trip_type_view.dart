import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../controllers/trip_type_controller.dart';
import '../widgets/trip_type_selector_card.dart';

class TripTypeView extends StatefulWidget {
  final TripRepository tripRepository;
  final String tripId;

  const TripTypeView({
    super.key,
    required this.tripRepository,
    required this.tripId,
  });

  @override
  State<TripTypeView> createState() => _TripTypeViewState();
}

class _TripTypeViewState extends State<TripTypeView> {
  late final TripTypeController controller;

  @override
  void initState() {
    super.initState();
    controller = TripTypeController(
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
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tripTypeTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Wizard Progress (Step 3/5)
              Row(
                children: [
                  _buildStepIndicator(step: 1, isActive: true, isDone: true, isDark: isDark),
                  _buildStepConnector(isDone: true, borderColor: borderColor),
                  _buildStepIndicator(step: 2, isActive: true, isDone: true, isDark: isDark),
                  _buildStepConnector(isDone: true, borderColor: borderColor),
                  _buildStepIndicator(step: 3, isActive: true, isDone: false, isDark: isDark),
                  _buildStepConnector(isDone: false, borderColor: borderColor),
                  _buildStepIndicator(step: 4, isActive: false, isDone: false, isDark: isDark),
                  _buildStepConnector(isDone: false, borderColor: borderColor),
                  _buildStepIndicator(step: 5, isActive: false, isDone: false, isDark: isDark),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                'Seyahat Türünüzü Belirleyin',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.tripTypeSubtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: textSecondary,
                ),
              ),

              const SizedBox(height: 18),

              // Trip Type Options List
              ValueListenableBuilder<String>(
                valueListenable: controller.selectedType,
                builder: (context, currentType, _) {
                  return ValueListenableBuilder<String?>(
                    valueListenable: controller.selectedSubType,
                    builder: (context, currentSubType, _) {
                      return Column(
                        children: controller.options.map((opt) {
                          final isSelected = currentType == opt.title;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TripTypeSelectorCard(
                              option: opt,
                              isSelected: isSelected,
                              selectedSubType: currentSubType,
                              onSelect: () => controller.selectType(opt.title),
                              onSubTypeSelect: (sub) => controller.selectSubType(sub),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // Continue Button
              AppButton(
                text: 'Akıllı Önerileri İncele',
                icon: Icons.auto_awesome_rounded,
                onPressed: () async {
                  await controller.saveTripType();
                  if (context.mounted) {
                    context.push('/recommendations?tripId=${widget.tripId}');
                  }
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
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
