import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/trip_planner_controller.dart';

class DestinationSelector extends StatefulWidget {
  final TripPlannerController controller;

  const DestinationSelector({super.key, required this.controller});

  @override
  State<DestinationSelector> createState() => _DestinationSelectorState();
}

class _DestinationSelectorState extends State<DestinationSelector> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchCtrl.text = widget.controller.destination.value;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final selectedBg = isDark ? AppColors.darkSelected : AppColors.lightSelected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gidilecek Lokasyon',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // Search Input
        TextField(
          controller: _searchCtrl,
          onChanged: (val) => widget.controller.searchDestination(val),
          decoration: InputDecoration(
            hintText: 'Şehir veya ülke ara (Örn: Paris, Antalya)...',
            prefixIcon: Icon(Icons.search_rounded, color: primaryColor, size: 20),
            suffixIcon: ValueListenableBuilder<bool>(
              valueListenable: widget.controller.isSearching,
              builder: (context, searching, _) {
                if (searching) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),

        // Live API search results dropdown if active
        ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: widget.controller.searchResults,
          builder: (context, results, _) {
            if (results.isEmpty) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: results.length,
                separatorBuilder: (_, index) => Divider(height: 1, color: borderColor),
                itemBuilder: (context, idx) {
                  final item = results[idx];
                  return ListTile(
                    dense: true,
                    leading: Icon(Icons.location_on_outlined, color: primaryColor, size: 20),
                    title: Text(
                      item['name'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    onTap: () {
                      _searchCtrl.text = item['name'] as String;
                      widget.controller.setDestination(
                        name: item['name'] as String,
                        lat: item['lat'] as double,
                        lon: item['lon'] as double,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),

        const SizedBox(height: 14),

        // Popular Quick Chips
        Text(
          'Popüler Rotalar',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AppConstants.popularDestinations.map((dest) {
              return ValueListenableBuilder<String>(
                valueListenable: widget.controller.destination,
                builder: (context, curDest, _) {
                  final isSelected = curDest == dest['name'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        dest['name'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? primaryColor : textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: selectedBg,
                      backgroundColor: surfaceColor,
                      side: BorderSide(
                        color: isSelected ? primaryColor : borderColor,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      onSelected: (val) {
                        _searchCtrl.text = dest['name'] as String;
                        widget.controller.setDestination(
                          name: dest['name'] as String,
                          lat: (dest['lat'] as num).toDouble(),
                          lon: (dest['lon'] as num).toDouble(),
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
