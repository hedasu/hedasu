import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../trip_planner/models/trip_planner_model.dart';
import '../../trip_planner/repositories/trip_repository.dart';
import '../controllers/agenda_controller.dart';
import '../widgets/trip_agenda_card.dart';

class AgendaView extends StatefulWidget {
  final TripRepository tripRepository;

  const AgendaView({super.key, required this.tripRepository});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> with SingleTickerProviderStateMixin {
  late final AgendaController controller;
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    controller = AgendaController(tripRepository: widget.tripRepository);
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    controller.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seyahat Ajandam'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: primaryColor,
          indicatorWeight: 2.5,
          labelColor: primaryColor,
          unselectedLabelColor: textSecondary,
          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Geçmiş'),
            Tab(text: 'Güncel'),
            Tab(text: 'Gelecek'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _buildTripList(controller.pastTrips, 'Geçmiş seyahat bulunamadı.', isDark),
          _buildTripList(controller.currentTrips, 'Şu anda aktif bir seyahatiniz yok.', isDark),
          _buildTripList(controller.upcomingTrips, 'Planlanan gelecek seyahat bulunamadı.', isDark),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        foregroundColor: isDark ? const Color(0xFF101C1B) : Colors.white,
        elevation: 2,
        onPressed: () {
          context.push('/trip-planner').then((_) => controller.classifyTrips());
        },
        icon: const Icon(Icons.add_rounded, size: 20),
        label: Text(
          'Yeni Seyahat Planla',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildTripList(ValueNotifier<List<TripPlannerModel>> notifier, String emptyMsg, bool isDark) {
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return ValueListenableBuilder<List<TripPlannerModel>>(
      valueListenable: notifier,
      builder: (context, trips, _) {
        if (trips.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy_rounded, size: 44, color: textSecondary),
                  const SizedBox(height: 12),
                  Text(
                    emptyMsg,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          itemCount: trips.length,
          separatorBuilder: (_, index) => const SizedBox(height: 12),
          itemBuilder: (context, idx) {
            final t = trips[idx];
            return TripAgendaCard(
              trip: t,
              onTap: () {
                context.push('/checklist?tripId=${t.id}').then((_) => controller.classifyTrips());
              },
            );
          },
        );
      },
    );
  }
}
