import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/weather_service.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../controllers/weather_controller.dart';
import '../models/weather_model.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/hourly_forecast_card.dart';
import '../widgets/weather_alert_banner.dart';

class WeatherAgendaView extends StatefulWidget {
  final WeatherService weatherService;
  final TripRepository tripRepository;
  final String tripId;

  const WeatherAgendaView({
    super.key,
    required this.weatherService,
    required this.tripRepository,
    required this.tripId,
  });

  @override
  State<WeatherAgendaView> createState() => _WeatherAgendaViewState();
}

class _WeatherAgendaViewState extends State<WeatherAgendaView> {
  late final WeatherController controller;

  @override
  void initState() {
    super.initState();
    controller = WeatherController(
      weatherService: widget.weatherService,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seyahat Ajandası & Hava Durumu'),
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
              return const AppLoading(message: 'Hava durumu ve seyahat ajandası analiz ediliyor...');
            }

            return ValueListenableBuilder<String?>(
              valueListenable: controller.error,
              builder: (context, error, _) {
                if (error != null) {
                  return AppError(
                    message: error,
                    onRetry: controller.loadWeatherData,
                  );
                }

                return ValueListenableBuilder<TripPlannerModel?>(
                  valueListenable: controller.currentTrip,
                  builder: (context, trip, _) {
                    if (trip == null) return const SizedBox.shrink();

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Wizard Progress (Step 2/5)
                          Row(
                            children: [
                              _buildStepIndicator(step: 1, isActive: true, isDone: true, isDark: isDark),
                              _buildStepConnector(isDone: true, borderColor: borderColor),
                              _buildStepIndicator(step: 2, isActive: true, isDone: false, isDark: isDark),
                              _buildStepConnector(isDone: false, borderColor: borderColor),
                              _buildStepIndicator(step: 3, isActive: false, isDone: false, isDark: isDark),
                              _buildStepConnector(isDone: false, borderColor: borderColor),
                              _buildStepIndicator(step: 4, isActive: false, isDone: false, isDark: isDark),
                              _buildStepConnector(isDone: false, borderColor: borderColor),
                              _buildStepIndicator(step: 5, isActive: false, isDone: false, isDark: isDark),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Weather Alerts if any
                          ValueListenableBuilder<List<String>>(
                            valueListenable: controller.alerts,
                            builder: (context, alerts, _) {
                              return WeatherAlertBanner(alerts: alerts);
                            },
                          ),

                          // Hourly forecast
                          ValueListenableBuilder<List<HourlyWeatherItem>>(
                            valueListenable: controller.hourlyItems,
                            builder: (context, hourly, _) {
                              return HourlyForecastCard(items: hourly);
                            },
                          ),

                          const SizedBox(height: 20),

                          // Daily Forecast & Agenda
                          ValueListenableBuilder<List<DailyWeatherItem>>(
                            valueListenable: controller.dailyItems,
                            builder: (context, daily, _) {
                              return DailyForecastCard(
                                items: daily,
                                destination: trip.destination,
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // Next Step Button
                          AppButton(
                            text: 'Seyahat Türü Seçimine Geç',
                            icon: Icons.category_rounded,
                            onPressed: () {
                              context.push('/trip-type?tripId=${trip.id}');
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
