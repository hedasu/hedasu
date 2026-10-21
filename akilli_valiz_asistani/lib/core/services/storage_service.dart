import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../features/auth/models/user_model.dart';
import '../../features/packing_list/models/packing_item_model.dart';
import '../../features/shopping/models/shopping_item_model.dart';
import '../../features/trip_planner/models/trip_planner_model.dart';
import '../constants/app_constants.dart';

class StorageService {
  static const _keyTrips = 'packpilot_trips';
  static const _keyActiveTripId = 'packpilot_active_trip_id';
  static const _keyUser = 'packpilot_user';
  static const _keyShopping = 'packpilot_shopping';

  late SharedPreferences _prefs;

  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey(_keyTrips)) {
      await _seedInitialData();
    }
    // Kullanıcının tema tercihini başlat
    final user = getUser();
    themeModeNotifier.value = _resolveThemeMode(user.themePreference);
  }

  ThemeMode _resolveThemeMode(String pref) {
    switch (pref) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  // User Profile
  UserModel getUser() {
    final str = _prefs.getString(_keyUser);
    if (str != null) {
      try {
        return UserModel.fromJson(jsonDecode(str) as Map<String, dynamic>);
      } catch (_) {}
    }
    return const UserModel(
      id: 'pilot_user_1',
      name: 'Seyahat Sever',
      email: 'pilot@packpilot.app',
      themePreference: 'light',
      notificationsEnabled: true,
      cycleTrackingEnabled: true,
      cycleLengthDays: 28,
    );
  }

  Future<void> saveUser(UserModel user) async {
    await _prefs.setString(_keyUser, jsonEncode(user.toJson()));
    themeModeNotifier.value = _resolveThemeMode(user.themePreference);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeModeNotifier.value = mode;
    final user = getUser().copyWith(themePreference: mode.name);
    await _prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  // Trips Management
  List<TripPlannerModel> getTrips() {
    final str = _prefs.getString(_keyTrips);
    if (str == null || str.isEmpty) return [];
    try {
      final list = jsonDecode(str) as List<dynamic>;
      return list
          .map((e) => TripPlannerModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTrip(TripPlannerModel trip) async {
    final trips = getTrips();
    final idx = trips.indexWhere((t) => t.id == trip.id);
    if (idx >= 0) {
      trips[idx] = trip;
    } else {
      trips.insert(0, trip);
    }
    await _saveTripsList(trips);

    // If no active trip or this is the first, make it active
    if (getActiveTripId() == null || trips.length == 1) {
      await setActiveTripId(trip.id);
    }
  }

  Future<void> deleteTrip(String tripId) async {
    final trips = getTrips();
    trips.removeWhere((t) => t.id == tripId);
    await _saveTripsList(trips);

    if (getActiveTripId() == tripId) {
      if (trips.isNotEmpty) {
        await setActiveTripId(trips.first.id);
      } else {
        await _prefs.remove(_keyActiveTripId);
      }
    }
  }

  String? getActiveTripId() {
    return _prefs.getString(_keyActiveTripId);
  }

  Future<void> setActiveTripId(String tripId) async {
    await _prefs.setString(_keyActiveTripId, tripId);
  }

  TripPlannerModel? getActiveTrip() {
    final activeId = getActiveTripId();
    final trips = getTrips();
    if (trips.isEmpty) return null;
    if (activeId != null) {
      final found = trips.where((t) => t.id == activeId).toList();
      if (found.isNotEmpty) return found.first;
    }
    return trips.first;
  }

  Future<void> _saveTripsList(List<TripPlannerModel> trips) async {
    final str = jsonEncode(trips.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyTrips, str);
  }

  // Shopping List
  List<ShoppingItemModel> getShoppingItems() {
    final str = _prefs.getString(_keyShopping);
    if (str == null || str.isEmpty) return [];
    try {
      final list = jsonDecode(str) as List<dynamic>;
      return list
          .map((e) => ShoppingItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveShoppingItem(ShoppingItemModel item) async {
    final items = getShoppingItems();
    final idx = items.indexWhere((i) => i.id == item.id);
    if (idx >= 0) {
      items[idx] = item;
    } else {
      items.add(item);
    }
    await _prefs.setString(
      _keyShopping,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> deleteShoppingItem(String id) async {
    final items = getShoppingItems();
    items.removeWhere((i) => i.id == id);
    await _prefs.setString(
      _keyShopping,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  // Seed Rich Sample Data for wow factor
  Future<void> _seedInitialData() async {
    const uuid = Uuid();
    final now = DateTime.now();
    final start = now.add(const Duration(days: 2));
    final end = start.add(const Duration(days: 4));

    final sampleItems = [
      // Sağlık
      const PackingItemModel(
        id: 'item_1',
        name: 'Güneş Kremi (SPF 50)',
        category: AppConstants.categoryHealth,
        quantity: 1,
        unitWeightKg: 0.2,
        unitVolumeLiters: 0.3,
        isPacked: true,
      ),
      const PackingItemModel(
        id: 'item_2',
        name: 'Temel İlaçlar ve Ağrı Kesici',
        category: AppConstants.categoryHealth,
        quantity: 1,
        unitWeightKg: 0.15,
        unitVolumeLiters: 0.4,
        isPacked: false,
      ),

      // Giyim
      const PackingItemModel(
        id: 'item_3',
        name: 'Pamuklu Tişört',
        category: AppConstants.categoryClothing,
        quantity: 4,
        unitWeightKg: 0.2,
        unitVolumeLiters: 0.8,
        isPacked: true,
      ),
      const PackingItemModel(
        id: 'item_4',
        name: 'Keten Pantolon & Şort',
        category: AppConstants.categoryClothing,
        quantity: 2,
        unitWeightKg: 0.4,
        unitVolumeLiters: 1.5,
        isPacked: false,
      ),
      const PackingItemModel(
        id: 'item_5',
        name: 'Hafif Akşam Ceketi',
        category: AppConstants.categoryClothing,
        quantity: 1,
        unitWeightKg: 0.6,
        unitVolumeLiters: 2.2,
        isPacked: false,
      ),

      // Teknolojik Ürünler
      const PackingItemModel(
        id: 'item_6',
        name: 'Telefon Hızlı Şarj Cihazı',
        category: AppConstants.categoryTech,
        quantity: 1,
        unitWeightKg: 0.15,
        unitVolumeLiters: 0.3,
        isPacked: true,
      ),
      const PackingItemModel(
        id: 'item_7',
        name: 'Powerbank (20.000 mAh)',
        category: AppConstants.categoryTech,
        quantity: 1,
        unitWeightKg: 0.35,
        unitVolumeLiters: 0.4,
        isPacked: false,
      ),

      // Kişisel Bakım
      const PackingItemModel(
        id: 'item_8',
        name: 'Seyahat Diş Bakım Seti',
        category: AppConstants.categoryPersonalCare,
        quantity: 1,
        unitWeightKg: 0.12,
        unitVolumeLiters: 0.3,
        isPacked: true,
      ),

      // Dinamik: Plaj & Tatil
      const PackingItemModel(
        id: 'item_9',
        name: 'Yüzme Mayosu / Şortu',
        category: AppConstants.categoryBeach,
        quantity: 2,
        unitWeightKg: 0.2,
        unitVolumeLiters: 0.6,
        isPacked: false,
      ),
      const PackingItemModel(
        id: 'item_10',
        name: 'Hızlı Kuruyan Plaj Havlusu',
        category: AppConstants.categoryBeach,
        quantity: 1,
        unitWeightKg: 0.45,
        unitVolumeLiters: 1.8,
        isPacked: false,
      ),
    ];

    final sampleTrip = TripPlannerModel(
      id: uuid.v4(),
      destination: 'Antalya, Türkiye',
      latitude: 36.8969,
      longitude: 30.7133,
      startDate: start,
      endDate: end,
      arrivalHour: 10,
      arrivalMinute: 30,
      departureHour: 18,
      departureMinute: 0,
      tripType: AppConstants.tripTypeVacation,
      tripSubType: 'Yaz Tatili',
      items: sampleItems,
      createdAt: now,
    );

    await _saveTripsList([sampleTrip]);
    await setActiveTripId(sampleTrip.id);

    // Sample shopping items
    final sampleShopping = [
      const ShoppingItemModel(
        id: 'shop_1',
        title: 'Seyahat Boy Güneş Kremi',
        category: 'Kişisel Bakım',
        isPurchased: false,
        estimatedPrice: 220.0,
      ),
      const ShoppingItemModel(
        id: 'shop_2',
        title: 'Su Geçirmez Telefon Kılıfı',
        category: 'Aksesuar',
        isPurchased: true,
        estimatedPrice: 150.0,
      ),
      const ShoppingItemModel(
        id: 'shop_3',
        title: 'Kulak Tıkacı & Göz Bandı',
        category: 'Seyahat Konforu',
        isPurchased: false,
        estimatedPrice: 85.0,
      ),
    ];

    await _prefs.setString(
      _keyShopping,
      jsonEncode(sampleShopping.map((e) => e.toJson()).toList()),
    );
  }
}
