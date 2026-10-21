import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/glass_container.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../controllers/home_controller.dart';
import '../widgets/current_luggage_card.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/quick_stats_card.dart';

class HomeView extends StatefulWidget {
  final StorageService storageService;
  final TripRepository tripRepository;

  const HomeView({
    super.key,
    required this.storageService,
    required this.tripRepository,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = HomeController(
      tripRepository: widget.tripRepository,
      storageService: widget.storageService,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showDeleteDialog(BuildContext context, TripPlannerModel trip) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: borderColor),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
            const SizedBox(width: 10),
            Text(
              'Aktiviteyi Sil',
              style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Text(
          '${trip.destination} seyahatini ve bağlı valiz listesini silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
          style: GoogleFonts.inter(fontSize: 14, color: textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Vazgeç',
              style: GoogleFonts.inter(color: textSecondary, fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              await controller.deleteActiveTrip();
              if (mounted) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Seyahat başarıyla silindi.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
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

    final user = widget.storageService.getUser();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar with Logo & User Profile
              HomeAppBar(
                userName: user.name,
                onProfileTap: () => context.push('/profile').then((_) {
                  if (mounted) setState(() {});
                }),
              ),

              const SizedBox(height: 20),

              // Hero Greeting Banner (Atlas & Sage Style)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSelected : AppColors.lightPrimary,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightPrimary,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.15)
                          : AppColors.lightPrimary.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'İyi yolculuklar, Gezgin!',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkPrimary : AppColors.lightAccent,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Valizinizi Akıllıca\nHazırlayın',
                            style: GoogleFonts.manrope(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : Colors.white,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? AppColors.darkPrimary : Colors.white,
                              foregroundColor: isDark ? const Color(0xFF101C1B) : AppColors.lightPrimary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              context.push('/trip-planner').then((_) => controller.refresh());
                            },
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: Text(
                              AppStrings.startFirstTrip,
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.flight_takeoff_rounded,
                            color: isDark ? AppColors.darkPrimary : Colors.white,
                            size: 38,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Quick Stats Row
              ValueListenableBuilder<List<TripPlannerModel>>(
                valueListenable: controller.allTrips,
                builder: (context, trips, _) {
                  return ValueListenableBuilder<int>(
                    valueListenable: controller.shoppingItemsCount,
                    builder: (context, shopCount, _) {
                      final packed = trips.fold(0, (acc, t) => acc + t.packedCount);
                      final total = trips.fold(0, (acc, t) => acc + t.totalItemsCount);
                      return QuickStatsCard(
                        totalTrips: trips.length,
                        totalPacked: packed,
                        totalUnpacked: (total - packed).clamp(0, 9999),
                        pendingShopping: shopCount,
                        onTripsTap: () => context.push('/agenda').then((_) => controller.refresh()),
                        onShoppingTap: () => context.push('/shopping').then((_) => controller.refresh()),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              // Current Luggage Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.currentLuggage,
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => context.push('/agenda').then((_) => controller.refresh()),
                    icon: Icon(Icons.history_rounded, size: 16, color: primaryColor),
                    label: Text(
                      'Tüm Ajandam',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Current Luggage Card or Empty State
              ValueListenableBuilder<TripPlannerModel?>(
                valueListenable: controller.activeTrip,
                builder: (context, trip, _) {
                  if (trip == null) {
                    return GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.luggage_outlined, size: 38, color: primaryColor),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            AppStrings.noActiveTrip,
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Gideceğiniz şehri ve tarihleri seçerek akıllı valizinizi hemen hazırlayın.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                          ),
                          const SizedBox(height: 18),
                          AppButton(
                            text: AppStrings.startFirstTrip,
                            icon: Icons.add_location_alt_outlined,
                            onPressed: () {
                              context.push('/trip-planner').then((_) => controller.refresh());
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return CurrentLuggageCard(
                    trip: trip,
                    onOpenChecklist: () {
                      context.push('/checklist?tripId=${trip.id}').then((_) => controller.refresh());
                    },
                    onDelete: () => _showDeleteDialog(context, trip),
                    onEditOptionSelected: (opt) {
                      switch (opt) {
                        case EditTripOption.changeDateLocation:
                          context.push('/trip-planner?editId=${trip.id}').then((_) => controller.refresh());
                          break;
                        case EditTripOption.changeType:
                          context.push('/trip-type?editId=${trip.id}').then((_) => controller.refresh());
                          break;
                        case EditTripOption.addItems:
                          context.push('/packing-list?editId=${trip.id}').then((_) => controller.refresh());
                          break;
                        case EditTripOption.openChecklist:
                          context.push('/checklist?tripId=${trip.id}').then((_) => controller.refresh());
                          break;
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(top: BorderSide(color: borderColor, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentNavIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: primaryColor,
          unselectedItemColor: textSecondary,
          selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() => _currentNavIndex = index);
            if (index == 0) {
              controller.refresh();
            } else if (index == 1) {
              context.push('/agenda').then((_) {
                if (mounted) {
                  setState(() => _currentNavIndex = 0);
                  controller.refresh();
                }
              });
            } else if (index == 2) {
              context.push('/shopping').then((_) {
                if (mounted) {
                  setState(() => _currentNavIndex = 0);
                  controller.refresh();
                }
              });
            } else if (index == 3) {
              context.push('/profile').then((_) {
                if (mounted) {
                  setState(() => _currentNavIndex = 0);
                  controller.refresh();
                }
              });
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Ana Ekran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Ajandam',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Alışveriş',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
