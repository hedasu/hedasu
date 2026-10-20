import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/services/theme_service.dart';
import 'core/theme/app_theme.dart';
import 'features/home/view/main_navigation_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StartPathApp());
}

/// StartPath Ana Uygulama Kökü (<40 satır build kuralı)
class StartPathApp extends StatelessWidget {
  const StartPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const MainNavigationShell(),
        );
      },
    );
  }
}
