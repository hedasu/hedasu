import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'features/diary/controller/diary_controller.dart';
import 'features/home/view/home_view.dart';
import 'features/settings/controller/theme_controller.dart';
import 'features/splash/view/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);

  runApp(const DunceApp());
}

/// Dünce Anı & Duygu Günlüğü Ana Uygulama Widget'ı.
class DunceApp extends StatefulWidget {
  const DunceApp({super.key});

  @override
  State<DunceApp> createState() => _DunceAppState();
}

class _DunceAppState extends State<DunceApp> {
  late final ThemeController _themeController;
  late final DiaryController _diaryController;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
    _diaryController = DiaryController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    _diaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Dünce',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeController.themeMode,
          locale: const Locale('tr', 'TR'),
          supportedLocales: const [
            Locale('tr', 'TR'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: _showSplash
              ? SplashView(
                  onStart: () => setState(() => _showSplash = false),
                )
              : HomeView(
                  themeController: _themeController,
                  diaryController: _diaryController,
                  onShowSplash: () => setState(() => _showSplash = true),
                ),
        );
      },
    );
  }
}
