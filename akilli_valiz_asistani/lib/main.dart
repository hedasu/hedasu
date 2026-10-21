import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/services/storage_service.dart';
import 'core/services/weather_service.dart';
import 'core/theme/app_theme.dart';
import 'features/trip_planner/repositories/trip_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Core Services
  final storageService = StorageService();
  await storageService.init();

  final weatherService = WeatherService();
  final tripRepository = TripRepository(storageService: storageService);

  // Initialize App Router
  final appRouter = AppRouter(
    storageService: storageService,
    weatherService: weatherService,
    tripRepository: tripRepository,
  );

  runApp(
    PackPilotApp(
      appRouter: appRouter,
      storageService: storageService,
    ),
  );
}

class PackPilotApp extends StatelessWidget {
  final AppRouter appRouter;
  final StorageService storageService;

  const PackPilotApp({
    super.key,
    required this.appRouter,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: storageService.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: appRouter.router,
        );
      },
    );
  }
}
