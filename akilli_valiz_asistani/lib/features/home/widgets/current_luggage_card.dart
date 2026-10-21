import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/glass_container.dart';
import '../../trip_planner/models/trip_planner_model.dart';

enum EditTripOption {
  changeDateLocation,
  changeType,
  addItems,
  openChecklist,
}

class CurrentLuggageCard extends StatelessWidget {
  final TripPlannerModel trip;
  final Function(EditTripOption option) onEditOptionSelected;
  final VoidCallback onDelete;
  final VoidCallback onOpenChecklist;

  const CurrentLuggageCard({
    super.key,
    required this.trip,
    required this.onEditOptionSelected,
    required this.onDelete,
    required this.onOpenChecklist,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final secondaryColor = isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final badgeBg = isDark ? AppColors.darkSelected : AppColors.lightSelected;

    final progress = trip.packedRatio;
    final percentInt = (progress * 100).toInt();

    return GlassContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with tag and actions
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.luggage_rounded, size: 14, color: primaryColor),
                    const SizedBox(width: 6),
                    Text(
                      trip.tripType,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    if (trip.tripSubType != null) ...[
                      Text(' • ', style: TextStyle(color: primaryColor)),
                      Text(
                        trip.tripSubType!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              // Edit Popup Menu
              PopupMenuButton<EditTripOption>(
                icon: Icon(Icons.more_vert_rounded, color: textSecondary, size: 22),
                color: surfaceColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: borderColor),
                ),
                onSelected: onEditOptionSelected,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: EditTripOption.changeDateLocation,
                    child: Row(
                      children: [
                        Icon(Icons.edit_calendar_rounded, size: 18, color: primaryColor),
                        const SizedBox(width: 10),
                        Text('Tarihi / Lokasyonu Değiştir', style: GoogleFonts.inter(fontSize: 13, color: textPrimary)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: EditTripOption.changeType,
                    child: Row(
                      children: [
                        Icon(Icons.category_outlined, size: 18, color: secondaryColor),
                        const SizedBox(width: 10),
                        Text('Türü Değiştir', style: GoogleFonts.inter(fontSize: 13, color: textPrimary)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: EditTripOption.addItems,
                    child: Row(
                      children: [
                        Icon(Icons.add_shopping_cart_rounded, size: 18, color: isDark ? AppColors.darkAccent : AppColors.lightAccent),
                        const SizedBox(width: 10),
                        Text('Eşya Ekle', style: GoogleFonts.inter(fontSize: 13, color: textPrimary)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: EditTripOption.openChecklist,
                    child: Row(
                      children: [
                        const Icon(Icons.checklist_rounded, size: 18, color: AppColors.success),
                        const SizedBox(width: 10),
                        Text('Kontrol Ekranı', style: GoogleFonts.inter(fontSize: 13, color: textPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Destination
          Text(
            trip.destination,
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 6),

          // Dates and hours
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 14, color: textSecondary),
              const SizedBox(width: 6),
              Text(
                AppDateUtils.formatDateRange(trip.startDate, trip.endDate),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${trip.durationDays} Gün',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ),
            ],
          ),

          if (trip.hasSpecificHours) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 14, color: textSecondary),
                const SizedBox(width: 6),
                Text(
                  'Varış: ${trip.arrivalHour?.toString().padLeft(2, '0') ?? '--'}:${trip.arrivalMinute?.toString().padLeft(2, '0') ?? '00'}   •   Ayrılış: ${trip.departureHour?.toString().padLeft(2, '0') ?? '--'}:${trip.departureMinute?.toString().padLeft(2, '0') ?? '00'}',
                  style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // Progress Bar & Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Valiz Hazırlık Durumu',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
              Text(
                '${trip.packedCount} / ${trip.totalItemsCount} Eşya (%$percentInt)',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0 ? AppColors.success : primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Weight & Volume Badges
          Row(
            children: [
              _buildMetricBadge(
                context: context,
                icon: Icons.scale_outlined,
                label: '${trip.totalWeightKg.toStringAsFixed(1)} kg',
                isWarning: trip.totalWeightKg > 8.0,
              ),
              const SizedBox(width: 10),
              _buildMetricBadge(
                context: context,
                icon: Icons.view_in_ar_rounded,
                label: '${trip.totalVolumeLiters.toStringAsFixed(1)} Litre',
                isWarning: trip.totalVolumeLiters > 40.0,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Actions Row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onOpenChecklist,
                  icon: const Icon(Icons.checklist_rounded, size: 18),
                  label: const Text('Valiz Kontrol Ekranı'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: isDark ? const Color(0xFF101C1B) : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.outlined(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                tooltip: 'Aktiviteyi Sil',
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBadge({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isWarning,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeBg = isDark ? AppColors.darkSelected : AppColors.lightSelected;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isWarning ? AppColors.warning.withValues(alpha: 0.12) : badgeBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isWarning ? AppColors.warning.withValues(alpha: 0.4) : border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: isWarning ? AppColors.warning : text,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isWarning ? AppColors.warning : text,
            ),
          ),
        ],
      ),
    );
  }
}
