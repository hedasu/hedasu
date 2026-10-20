import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import 'router/app_router.dart';
import '../features/home/view/main_shell_view.dart';

class OtoViaApp extends StatelessWidget {
  const OtoViaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'otoVia',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.value,
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: const MainShellView(),
        );
      },
    );
  }
}
