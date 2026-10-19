import 'package:flutter/material.dart';
import '../controller/theme_controller.dart';
import '../../../core/constants/app_colors.dart';

/// AppBar üzerinde yer alan ve tek tıkla aydınlık/koyu mod geçişi sağlayan buton.
class ThemeToggleButton extends StatelessWidget {
  final ThemeController themeController;

  const ThemeToggleButton({
    super.key,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        final isDark = themeController.isDarkMode;
        return IconButton(
          tooltip: isDark ? 'Nostaljik Deftere Geç' : 'Antika Kitaba Geç',
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                RotationTransition(turns: animation, child: child),
            child: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              key: ValueKey<bool>(isDark),
              color: isDark ? AppColors.darkGold : AppColors.lightAccent,
            ),
          ),
          onPressed: () => themeController.toggleTheme(),
        );
      },
    );
  }
}
