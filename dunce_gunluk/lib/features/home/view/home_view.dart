import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../calendar/controller/calendar_controller.dart';
import '../../calendar/view/calendar_view.dart';
import '../../diary/controller/diary_controller.dart';
import '../../diary/view/diary_editor_view.dart';
import '../../settings/controller/theme_controller.dart';
import '../../settings/view/settings_view.dart';
import '../../settings/widgets/theme_toggle_button.dart';

/// Ana gezinme ve sekme yönetim ekranı.
class HomeView extends StatefulWidget {
  final ThemeController themeController;
  final DiaryController diaryController;
  final VoidCallback onShowSplash;

  const HomeView({
    super.key,
    required this.themeController,
    required this.diaryController,
    required this.onShowSplash,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  late final CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildCurrentTab(),
      floatingActionButton: _currentIndex == 0 ? _buildAddEntryFab() : null,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(AppStrings.appLogoPath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            AppStrings.appName,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Dünce Ne Demek?',
          icon: const Icon(Icons.info_outline),
          onPressed: widget.onShowSplash,
        ),
        ThemeToggleButton(themeController: widget.themeController),
      ],
    );
  }

  Widget _buildCurrentTab() {
    if (_currentIndex == 0) {
      return CalendarView(
        calendarController: _calendarController,
        diaryController: widget.diaryController,
      );
    }
    return SettingsView(
      themeController: widget.themeController,
    );
  }

  Widget _buildAddEntryFab() {
    return FloatingActionButton(
      heroTag: 'home_add_fab',
      tooltip: AppStrings.newEntry,
      child: const Icon(Icons.edit_calendar_outlined),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiaryEditorView(
              selectedDate: _calendarController.selectedDate,
              diaryController: widget.diaryController,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.auto_stories_outlined),
          selectedIcon: Icon(Icons.auto_stories),
          label: 'Ajanda & Defter',
        ),
        NavigationDestination(
          icon: Icon(Icons.tune_outlined),
          selectedIcon: Icon(Icons.tune),
          label: 'Görünüm & Ayarlar',
        ),
      ],
    );
  }
}
