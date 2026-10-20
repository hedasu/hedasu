import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import 'router/app_router.dart';
import '../features/home/view/main_shell_view.dart';

/// otoVia uygulamasının kök (root) widget bileşeni.
///
/// Material 3 tasarım dilini, dinamik açık/koyu tema yönetimini
/// ve merkezi rota yönetimini (AppRouter) yapılandırır.
class OtoViaApp extends StatelessWidget {
  const OtoViaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema değişikliklerini dinamik olarak dinleyip arayüzü yeniden çizmek için
    // ListenableBuilder kullanıyoruz.
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'otoVia',
          debugShowCheckedModeBanner: false,

          // Açık ve koyu tema yapılandırmaları
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.value,

          // Sayfa yönlendirme (routing) sistemi
          onGenerateRoute: AppRouter.onGenerateRoute,

          // Uygulama açılış ekranı: Alt navigasyon çubuğu barındıran ana kabuk
          home: const MainShellView(),
        );
      },
    );
  }
}
