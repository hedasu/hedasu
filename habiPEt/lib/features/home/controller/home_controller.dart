import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  bool _welcomeDialogShown = false;

  bool get welcomeDialogShown => _welcomeDialogShown;

  void markWelcomeDialogShown() {
    _welcomeDialogShown = true;
    notifyListeners();
  }

  void resetWelcomeDialog() {
    _welcomeDialogShown = false;
    notifyListeners();
  }
}
