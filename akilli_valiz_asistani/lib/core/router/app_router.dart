import 'package:go_router/go_router.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';
import '../../features/trip_planner/repositories/trip_repository.dart';

import '../../features/auth/view/auth_view.dart';
import '../../features/home/view/home_view.dart';
import '../../features/trip_planner/view/trip_planner_view.dart';
import '../../features/weather/view/weather_agenda_view.dart';
import '../../features/trip_type/view/trip_type_view.dart';
import '../../features/recommendations/view/recommendations_view.dart';
import '../../features/packing_list/view/packing_list_view.dart';
import '../../features/luggage_analysis/view/luggage_analysis_view.dart';
import '../../features/checklist/view/checklist_view.dart';
import '../../features/agenda/view/agenda_view.dart';
import '../../features/shopping/view/shopping_view.dart';
import '../../features/cycle_tracking/view/cycle_tracking_view.dart';
import '../../features/profile/view/profile_view.dart';

class AppRouter {
  final StorageService storageService;
  final WeatherService weatherService;
  final TripRepository tripRepository;

  late final GoRouter router;

  AppRouter({
    required this.storageService,
    required this.weatherService,
    required this.tripRepository,
  }) {
    router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/auth',
          builder: (context, state) => AuthView(storageService: storageService),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeView(
            storageService: storageService,
            tripRepository: tripRepository,
          ),
        ),
        GoRoute(
          path: '/trip-planner',
          builder: (context, state) {
            final editId = state.uri.queryParameters['editId'];
            return TripPlannerView(
              tripRepository: tripRepository,
              weatherService: weatherService,
              editTripId: editId,
            );
          },
        ),
        GoRoute(
          path: '/weather-agenda',
          builder: (context, state) {
            final tripId = state.uri.queryParameters['tripId'] ?? '';
            return WeatherAgendaView(
              weatherService: weatherService,
              tripRepository: tripRepository,
              tripId: tripId,
            );
          },
        ),
        GoRoute(
          path: '/trip-type',
          builder: (context, state) {
            final tripId = state.uri.queryParameters['tripId'] ?? state.uri.queryParameters['editId'] ?? '';
            return TripTypeView(
              tripRepository: tripRepository,
              tripId: tripId,
            );
          },
        ),
        GoRoute(
          path: '/recommendations',
          builder: (context, state) {
            final tripId = state.uri.queryParameters['tripId'] ?? '';
            return RecommendationsView(
              tripRepository: tripRepository,
              weatherService: weatherService,
              tripId: tripId,
            );
          },
        ),
        GoRoute(
          path: '/packing-list',
          builder: (context, state) {
            final tripId = state.uri.queryParameters['tripId'] ?? state.uri.queryParameters['editId'] ?? '';
            return PackingListView(
              tripRepository: tripRepository,
              tripId: tripId,
            );
          },
        ),
        GoRoute(
          path: '/luggage-analysis',
          builder: (context, state) {
            final tripId = state.uri.queryParameters['tripId'] ?? '';
            return LuggageAnalysisView(
              tripRepository: tripRepository,
              tripId: tripId,
            );
          },
        ),
        GoRoute(
          path: '/checklist',
          builder: (context, state) {
            final tripId = state.uri.queryParameters['tripId'] ?? '';
            return ChecklistView(
              tripRepository: tripRepository,
              tripId: tripId,
            );
          },
        ),
        GoRoute(
          path: '/agenda',
          builder: (context, state) => AgendaView(tripRepository: tripRepository),
        ),
        GoRoute(
          path: '/shopping',
          builder: (context, state) => ShoppingView(storageService: storageService),
        ),
        GoRoute(
          path: '/cycle-tracking',
          builder: (context, state) => CycleTrackingView(
            storageService: storageService,
            tripRepository: tripRepository,
          ),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileView(storageService: storageService),
        ),
      ],
    );
  }
}
