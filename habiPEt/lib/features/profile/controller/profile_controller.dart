import 'package:flutter/material.dart';

class ProfileController extends ChangeNotifier {
  bool _soundEnabled = true;
  bool _dailyReminders = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);

  bool get soundEnabled => _soundEnabled;
  bool get dailyReminders => _dailyReminders;
  TimeOfDay get reminderTime => _reminderTime;

  void toggleSound(bool value) {
    _soundEnabled = value;
    notifyListeners();
  }

  void toggleDailyReminders(bool value) {
    _dailyReminders = value;
    notifyListeners();
  }

  void setReminderTime(TimeOfDay time) {
    _reminderTime = time;
    notifyListeners();
  }
}
