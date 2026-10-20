import 'package:flutter/foundation.dart';
import '../models/home_dashboard_model.dart';

/// Ana Sayfa ve Alt Navigasyon Kontrolcüsü
class HomeController {
  final ValueNotifier<int> currentTab = ValueNotifier<int>(0);
  final ValueNotifier<HomeDashboardModel> dashboardData =
      ValueNotifier<HomeDashboardModel>(HomeDashboardModel.sample());

  void setTab(int index) {
    currentTab.value = index;
  }

  void dispose() {
    currentTab.dispose();
    dashboardData.dispose();
  }
}
