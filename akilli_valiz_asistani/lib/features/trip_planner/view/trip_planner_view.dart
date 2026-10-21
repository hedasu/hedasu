import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/weather_service.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/trip_planner_controller.dart';
import '../repositories/trip_repository.dart';
import '../widgets/date_range_picker_card.dart';
import '../widgets/destination_selector.dart';
import '../widgets/time_selector_card.dart';

class TripPlannerView extends StatefulWidget {
  final TripRepository tripRepository;
  final WeatherService weatherService;
  final String? editTripId;

  const TripPlannerView({
    super.key,
    required this.tripRepository,
    required this.weatherService,
    this.editTripId,
  });

  @override
  State<TripPlannerView> createState() => _TripPlannerViewState();
}

class _TripPlannerViewState extends State<TripPlannerView> {
  late final TripPlannerController controller;

  @override
  void initState() {
    super.initState();
    controller = TripPlannerController(
      tripRepository: widget.tripRepository,
      weatherService: widget.weatherService,
      editTripId: widget.editTripId,
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
    final isEditing = widget.editTripId != null;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Seyahati Düzenle' : AppStrings.newTripTitle),
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
              // Step progress indicator (Step 1/5)
              Row(
                children: [
                  _buildStepIndicator(step: 1, title: 'Konum', isActive: true, isDark: isDark),
                  _buildStepConnector(borderColor: borderColor),
                  _buildStepIndicator(step: 2, title: 'Hava', isActive: false, isDark: isDark),
                  _buildStepConnector(borderColor: borderColor),
                  _buildStepIndicator(step: 3, title: 'Tür', isActive: false, isDark: isDark),
                  _buildStepConnector(borderColor: borderColor),
                  _buildStepIndicator(step: 4, title: 'Liste', isActive: false, isDark: isDark),
                  _buildStepConnector(borderColor: borderColor),
                  _buildStepIndicator(step: 5, title: 'Kontrol', isActive: false, isDark: isDark),
                ],
              ),

              const SizedBox(height: 20),

              // Destination selector
              DestinationSelector(controller: controller),

              const SizedBox(height: 20),

              // Date Range Picker
              DateRangePickerCard(controller: controller),

              const SizedBox(height: 20),

              // Optional Time Selector
              TimeSelectorCard(controller: controller),

              const SizedBox(height: 16),

              // Validation Error
              ValueListenableBuilder<String?>(
                valueListenable: controller.validationError,
                builder: (context, error, _) {
                  if (error == null) return const SizedBox.shrink();
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            error,
                            style: GoogleFonts.inter(color: AppColors.error, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // Continue Button
              AppButton(
                text: 'Hava Durumu ve Ajandaya Geç',
                icon: Icons.wb_sunny_outlined,
                onPressed: () async {
                  if (controller.validateStep1()) {
                    final draft = controller.buildDraftTrip();
                    await widget.tripRepository.saveTrip(draft);
                    if (context.mounted) {
                      context.push('/weather-agenda?tripId=${draft.id}');
                    }
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
    required String title,
    required bool isActive,
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
        color: isActive ? primaryColor : inactiveBg,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? primaryColor : inactiveBorder,
        ),
      ),
      child: Center(
        child: Text(
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

  Widget _buildStepConnector({required Color borderColor}) {
    return Expanded(
      child: Container(
        height: 1.5,
        color: borderColor,
        margin: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
