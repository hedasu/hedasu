import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diary_entry.dart';

/// Günlük kayıtlarının durumunu ve yerel veritabanı kalıcılığını yöneten kontrolcü.
class DiaryController extends ChangeNotifier {
  static const String _storageKey = 'dunce_diary_entries_v1';
  final Map<String, DiaryEntry> _entries = {};
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  Map<String, DiaryEntry> get entries => Map.unmodifiable(_entries);

  DiaryController() {
    loadEntries();
  }

  static String formatDateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  DiaryEntry? getEntryForDate(DateTime date) {
    final key = formatDateKey(date);
    return _entries[key];
  }

  bool hasEntryOnDate(DateTime date) {
    final key = formatDateKey(date);
    return _entries.containsKey(key);
  }

  Future<void> loadEntries() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(jsonString);
        _entries.clear();
        decoded.forEach((key, value) {
          _entries[key] = DiaryEntry.fromJson(value as Map<String, dynamic>);
        });
      }
    } catch (_) {
      // Ayrıştırma hatasında mevcut durumu koru
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveEntry(DiaryEntry entry) async {
    _entries[entry.dateKey] = entry;
    notifyListeners();
    await _persist();
  }

  Future<void> deleteEntry(String dateKey) async {
    if (_entries.containsKey(dateKey)) {
      _entries.remove(dateKey);
      notifyListeners();
      await _persist();
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> map = {};
    _entries.forEach((key, value) {
      map[key] = value.toJson();
    });
    await prefs.setString(_storageKey, jsonEncode(map));
  }
}
