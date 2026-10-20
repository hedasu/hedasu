import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../applications/controller/applications_controller.dart';
import '../../applications/view/applications_view.dart';
import '../../legal_roadmap/controller/legal_roadmap_controller.dart';
import '../../legal_roadmap/view/legal_roadmap_view.dart';
import '../../mentor_matching/controller/mentor_matching_controller.dart';
import '../../mentor_matching/view/mentor_matching_view.dart';
import '../../messaging/controller/messaging_controller.dart';
import '../../messaging/view/messaging_view.dart';
import '../../notifications/controller/notifications_controller.dart';
import '../../notifications/view/notifications_view.dart';
import '../../opportunities/controller/opportunities_controller.dart';
import '../../opportunities/view/opportunities_view.dart';
import '../../personality_test/controller/personality_test_controller.dart';
import '../../personality_test/view/personality_test_view.dart';
import '../../profile/controller/profile_controller.dart';
import '../../profile/view/profile_view.dart';
import '../../project_workspace/controller/project_workspace_controller.dart';
import '../../project_workspace/view/project_workspace_view.dart';
import '../../settings/controller/settings_controller.dart';
import '../../settings/view/settings_view.dart';
import '../../startup/controller/startup_controller.dart';
import '../../startup/view/startup_form_view.dart';
import '../../team_matching/controller/team_matching_controller.dart';
import '../../team_matching/view/team_matching_view.dart';
import '../controller/home_controller.dart';
import 'home_view.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late final HomeController _homeCtrl;
  late final TeamMatchingController _teamCtrl;
  late final MentorMatchingController _mentorCtrl;
  late final OpportunitiesController _oppCtrl;
  late final ProfileController _profileCtrl;
  late final LegalRoadmapController _legalCtrl;
  late final ProjectWorkspaceController _workspaceCtrl;
  late final StartupController _startupCtrl;
  late final PersonalityTestController _testCtrl;
  late final ApplicationsController _appCtrl;
  late final NotificationsController _notifCtrl;
  late final MessagingController _msgCtrl;
  late final SettingsController _settingsCtrl;

  @override
  void initState() {
    super.initState();
    _homeCtrl = HomeController();
    _teamCtrl = TeamMatchingController();
    _mentorCtrl = MentorMatchingController();
    _oppCtrl = OpportunitiesController();
    _profileCtrl = ProfileController();
    _legalCtrl = LegalRoadmapController();
    _workspaceCtrl = ProjectWorkspaceController();
    _startupCtrl = StartupController();
    _testCtrl = PersonalityTestController();
    _appCtrl = ApplicationsController();
    _notifCtrl = NotificationsController();
    _msgCtrl = MessagingController();
    _settingsCtrl = SettingsController();
  }

  @override
  void dispose() {
    _homeCtrl.dispose();
    _teamCtrl.dispose();
    _mentorCtrl.dispose();
    _oppCtrl.dispose();
    _profileCtrl.dispose();
    _legalCtrl.dispose();
    _workspaceCtrl.dispose();
    _startupCtrl.dispose();
    _testCtrl.dispose();
    _appCtrl.dispose();
    _notifCtrl.dispose();
    _msgCtrl.dispose();
    _settingsCtrl.dispose();
    super.dispose();
  }

  void _pushPage(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildTabBody(int tab) {
    switch (tab) {
      case 0:
        return HomeView(
          controller: _homeCtrl,
          onNavigateLegal: () => _pushPage(LegalRoadmapView(controller: _legalCtrl)),
          onNavigateWorkspace: () => _pushPage(ProjectWorkspaceView(controller: _workspaceCtrl)),
          onNavigateStartupForm: () => _pushPage(StartupFormView(controller: _startupCtrl)),
          onNavigatePersonalityTest: () => _pushPage(
            PersonalityTestView(
              controller: _testCtrl,
              onTestFinished: () => Navigator.pop(context),
            ),
          ),
        );
      case 1:
        return TeamMatchingView(
          controller: _teamCtrl,
          onApplyPost: (post) {
            _appCtrl.submitApplication(
              startupName: post.startupName,
              roleApplied: post.roleNeeded,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${post.startupName} ilanına başvurunuz iletildi!')),
            );
          },
        );
      case 2:
        return MentorMatchingView(
          controller: _mentorCtrl,
          onBookSession: (mentor) => _pushPage(
            MessagingView(controller: _msgCtrl, title: '${mentor.fullName} (Mentor)'),
          ),
        );
      case 3:
        return OpportunitiesView(
          controller: _oppCtrl,
          onSelectOpportunity: (opp) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${opp.title} detayları inceleniyor.')),
            );
          },
        );
      case 4:
      default:
        return ProfileView(
          controller: _profileCtrl,
          onNavigateSettings: () => _pushPage(SettingsView(controller: _settingsCtrl)),
          onNavigateApplications: () => _pushPage(ApplicationsView(controller: _appCtrl)),
          onNavigateNotifications: () => _pushPage(NotificationsView(controller: _notifCtrl)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _homeCtrl.currentTab,
      builder: (context, currentTab, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.appName),
            actions: [
              IconButton(
                tooltip: 'Sohbet',
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                onPressed: () => _pushPage(MessagingView(controller: _msgCtrl)),
              ),
              IconButton(
                tooltip: 'Bildirimler',
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _pushPage(NotificationsView(controller: _notifCtrl)),
              ),
            ],
          ),
          body: _buildTabBody(currentTab),
          bottomNavigationBar: _BottomNav(currentTab: currentTab, onSelect: _homeCtrl.setTab),
        );
      },
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentTab;
  final ValueChanged<int> onSelect;

  const _BottomNav({required this.currentTab, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentTab,
      onDestinationSelected: onSelect,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label: AppStrings.navHome,
        ),
        NavigationDestination(
          icon: Icon(Icons.group_work_outlined),
          selectedIcon: Icon(Icons.group_work_rounded),
          label: AppStrings.navTeam,
        ),
        NavigationDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school_rounded),
          label: AppStrings.navMentors,
        ),
        NavigationDestination(
          icon: Icon(Icons.workspace_premium_outlined),
          selectedIcon: Icon(Icons.workspace_premium_rounded),
          label: AppStrings.navOpportunities,
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: AppStrings.navProfile,
        ),
      ],
    );
  }
}
