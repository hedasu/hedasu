import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../controllers/luggage_analysis_controller.dart';
import '../models/luggage_analysis_model.dart';
import '../widgets/airline_limit_card.dart';
import '../widgets/volume_gauge_card.dart';
import '../widgets/weight_gauge_card.dart';

class LuggageAnalysisView extends StatefulWidget {
  final TripRepository tripRepository;
  final String tripId;

  const LuggageAnalysisView({
    super.key,
    required this.tripRepository,
    required this.tripId,
  });

  @override
  State<LuggageAnalysisView> createState() => _LuggageAnalysisViewState();
}

class _LuggageAnalysisViewState extends State<LuggageAnalysisView> {
  late final LuggageAnalysisController controller;

  @override
  void initState() {
    super.initState();
    controller = LuggageAnalysisController(
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
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.analysisTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<LuggageAnalysisModel?>(
          valueListenable: controller.analysis,
          builder: (context, analysis, _) {
            if (analysis == null) {
              return const AppLoading(message: 'Ağırlık ve hacim hesaplanıyor...');
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tahmini Valiz Kapasite Raporu',
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Eşyalarınızın referans ağırlık ve hacim modellerine göre hesaplanan değerleri:',
                    style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                  ),

                  const SizedBox(height: 18),

                  // Weight Card
                  WeightGaugeCard(
                    currentKg: analysis.totalWeightKg,
                    limitKg: analysis.cabinMaxWeightKg,
                  ),

                  const SizedBox(height: 14),

                  // Volume Card
                  VolumeGaugeCard(
                    currentLiters: analysis.totalVolumeLiters,
                    limitLiters: analysis.cabinMaxVolumeLiters,
                  ),

                  const SizedBox(height: 14),

                  // Airline limit notification
                  AirlineLimitCard(isOverLimit: analysis.isCabinExceeded),

                  const SizedBox(height: 24),

                  // Go to Checklist Screen
                  AppButton(
                    text: 'Valiz Kontrol Ekranına Geç',
                    icon: Icons.checklist_rounded,
                    onPressed: () {
                      context.push('/checklist?tripId=${widget.tripId}');
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
