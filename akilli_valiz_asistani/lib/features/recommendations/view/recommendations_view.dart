import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/weather_service.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../controllers/recommendations_controller.dart';
import '../models/recommendation_model.dart';
import '../widgets/recommendation_card.dart';

class RecommendationsView extends StatefulWidget {
  final TripRepository tripRepository;
  final WeatherService weatherService;
  final String tripId;

  const RecommendationsView({
    super.key,
    required this.tripRepository,
    required this.weatherService,
    required this.tripId,
  });

  @override
  State<RecommendationsView> createState() => _RecommendationsViewState();
}

class _RecommendationsViewState extends State<RecommendationsView> {
  late final RecommendationsController controller;

  @override
  void initState() {
    super.initState();
    controller = RecommendationsController(
      tripRepository: widget.tripRepository,
      weatherService: widget.weatherService,
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
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.recommendationsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.isLoading,
          builder: (context, loading, _) {
            if (loading) {
              return const AppLoading(message: 'Hava ve aktiviteye özel öneriler derleniyor...');
            }

            return ValueListenableBuilder<TripPlannerModel?>(
              valueListenable: controller.trip,
              builder: (context, trip, _) {
                if (trip == null) {
                  return const Center(child: Text('Seyahat bulunamadı.'));
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Wizard Progress (Step 4/5)
                      Row(
                        children: [
                          _buildStepIndicator(step: 1, isActive: true, isDone: true, isDark: isDark),
                          _buildStepConnector(isDone: true, borderColor: borderColor),
                          _buildStepIndicator(step: 2, isActive: true, isDone: true, isDark: isDark),
                          _buildStepConnector(isDone: true, borderColor: borderColor),
                          _buildStepIndicator(step: 3, isActive: true, isDone: true, isDark: isDark),
                          _buildStepConnector(isDone: true, borderColor: borderColor),
                          _buildStepIndicator(step: 4, isActive: true, isDone: false, isDark: isDark),
                          _buildStepConnector(isDone: false, borderColor: borderColor),
                          _buildStepIndicator(step: 5, isActive: false, isDone: false, isDark: isDark),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Red Line Rule Explanatory Banner
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: isDark ? 0.16 : 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded, color: primaryColor, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'PackPilot size akıllı öneriler sunar, valiz listenizi onayınız olmadan otomatik doldurmaz. İhtiyacınız olan eşyaları "Listeme Ekle" ile listenize dahil edebilirsiniz.',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: textPrimary,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Önerilen Eşyalar & Ekipmanlar',
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${trip.destination} için ${trip.tripType} seyahatine uygun akıllı seçimler',
                        style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                      ),

                      const SizedBox(height: 16),

                      ValueListenableBuilder<List<RecommendationItem>>(
                        valueListenable: controller.recommendations,
                        builder: (context, recs, _) {
                          return ValueListenableBuilder<Set<String>>(
                            valueListenable: controller.addedItemNames,
                            builder: (context, added, _) {
                              return Column(
                                children: recs.map((rec) {
                                  final isAdded = added.contains(rec.title);
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: RecommendationCard(
                                      item: rec,
                                      isAlreadyAdded: isAdded,
                                      onAdd: () => controller.addItemToTrip(rec),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      AppButton(
                        text: 'Eşya Listesi Oluşturmaya Geç',
                        icon: Icons.format_list_bulleted_rounded,
                        onPressed: () {
                          context.push('/packing-list?tripId=${trip.id}');
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
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
