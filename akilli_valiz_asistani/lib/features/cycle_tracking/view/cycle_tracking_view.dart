import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/glass_container.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../controllers/cycle_tracking_controller.dart';
import '../models/cycle_model.dart';
import '../widgets/cycle_status_card.dart';

class CycleTrackingView extends StatefulWidget {
  final StorageService storageService;
  final TripRepository tripRepository;

  const CycleTrackingView({
    super.key,
    required this.storageService,
    required this.tripRepository,
  });

  @override
  State<CycleTrackingView> createState() => _CycleTrackingViewState();
}

class _CycleTrackingViewState extends State<CycleTrackingView> {
  late final CycleTrackingController controller;

  @override
  void initState() {
    super.initState();
    controller = CycleTrackingController(
      storageService: widget.storageService,
      tripRepository: widget.tripRepository,
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
    final secondaryColor = isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Döngü & Seyahat Takibi'),
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
              // Privacy & Voluntary Consent Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: secondaryColor.withValues(alpha: isDark ? 0.16 : 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: secondaryColor.withValues(alpha: 0.25)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.shield_outlined, color: secondaryColor, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sağlık Verisi Güvenliği & Gizlilik',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Döngü takibi tamamen isteğe bağlıdır. Verileriniz yalnızca cihazınızda güvenle işlenir, kesin tıbbi teşhis içermez ve seyahat hazırlığınızı kolaylaştırmayı amaçlar.',
                            style: GoogleFonts.inter(fontSize: 12, color: textPrimary, height: 1.35),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Enable/Disable Switch
              ValueListenableBuilder<bool>(
                valueListenable: controller.isEnabled,
                builder: (context, enabled, _) {
                  return GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Döngü Takibini Etkinleştir',
                              style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                            ),
                            Text(
                              'Seyahat tarihleriyle çakışma uyarıları alın',
                              style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                            ),
                          ],
                        ),
                        Switch(
                          value: enabled,
                          activeTrackColor: primaryColor,
                          onChanged: (val) => controller.toggleEnabled(val),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 18),

              ValueListenableBuilder<bool>(
                valueListenable: controller.isEnabled,
                builder: (context, enabled, _) {
                  if (!enabled) {
                    return GlassContainer(
                      padding: const EdgeInsets.all(22),
                      child: Center(
                        child: Text(
                          'Döngü takibi kapalıdır. Seyahat tarihlerinize özel hatırlatma ve valiz tavsiyesi almak için yukarıdaki anahtarı açabilirsiniz.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Date Selector
                      ValueListenableBuilder<DateTime>(
                        valueListenable: controller.lastPeriodDate,
                        builder: (context, date, _) {
                          return GlassContainer(
                            padding: const EdgeInsets.all(16),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime.now().subtract(const Duration(days: 90)),
                                lastDate: DateTime.now().add(const Duration(days: 90)),
                              );
                              if (picked != null) {
                                controller.setLastPeriodDate(picked);
                              }
                            },
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_rounded, color: primaryColor, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Son Döngü Başlangıç Tarihi',
                                        style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        AppDateUtils.formatSingleDate(date),
                                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.edit_calendar_rounded, size: 20, color: textSecondary),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // Cycle length
                      ValueListenableBuilder<int>(
                        valueListenable: controller.cycleLength,
                        builder: (context, len, _) {
                          return GlassContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ortalama Döngü Süresi',
                                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
                                ),
                                DropdownButton<int>(
                                  value: len,
                                  dropdownColor: surfaceColor,
                                  underline: const SizedBox.shrink(),
                                  items: List.generate(15, (i) => i + 21).map((val) {
                                    return DropdownMenuItem(
                                      value: val,
                                      child: Text('$val Gün', style: GoogleFonts.inter(color: textPrimary)),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) controller.setCycleLength(val);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      // Prediction result card
                      ValueListenableBuilder<CyclePredictionModel?>(
                        valueListenable: controller.prediction,
                        builder: (context, pred, _) {
                          if (pred == null) return const SizedBox.shrink();
                          return CycleStatusCard(prediction: pred);
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
