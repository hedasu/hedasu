import 'package:flutter/material.dart';

/// Ajanda takvimi gezinme ve tarih seçimi durumunu yöneten kontrolcü.
class CalendarController extends ChangeNotifier {
  DateTime _focusedDate;
  DateTime _selectedDate;

  CalendarController({DateTime? initialDate})
      : _focusedDate = initialDate ?? DateTime.now(),
        _selectedDate = initialDate ?? DateTime.now();

  DateTime get focusedDate => _focusedDate;
  DateTime get selectedDate => _selectedDate;

  void selectDate(DateTime date) {
    _selectedDate = date;
    _focusedDate = date;
    notifyListeners();
  }

  void previousMonth() {
    _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1);
    notifyListeners();
  }

  void nextMonth() {
    _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
    notifyListeners();
  }

  void goToToday() {
    final now = DateTime.now();
    _focusedDate = DateTime(now.year, now.month, 1);
    _selectedDate = DateTime(now.year, now.month, now.day);
    notifyListeners();
  }

  void setYearAndMonth(int year, int month) {
    _focusedDate = DateTime(year, month, 1);
    notifyListeners();
  }
}
