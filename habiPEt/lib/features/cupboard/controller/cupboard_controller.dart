import 'package:flutter/material.dart';
import '../models/cupboard_item_model.dart';
import '../repository/cupboard_repository.dart';
import '../../market/models/food_model.dart';

class CupboardController extends ChangeNotifier {
  final CupboardRepository _repository;
  late List<CupboardItemModel> _items;
  bool _isCupboardOpen = true;

  CupboardController({CupboardRepository? repository})
      : _repository = repository ?? CupboardRepository() {
    _items = List<CupboardItemModel>.from(_repository.getInitialItems());
  }

  List<CupboardItemModel> get items => List.unmodifiable(_items);
  bool get isCupboardOpen => _isCupboardOpen;
  int get totalFoodCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void toggleCupboard() {
    _isCupboardOpen = !_isCupboardOpen;
    notifyListeners();
  }

  void openCupboard() {
    if (!_isCupboardOpen) {
      _isCupboardOpen = true;
      notifyListeners();
    }
  }

  void addFood(FoodModel food, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.food.id == food.id);
    if (index >= 0) {
      final existing = _items[index];
      _items[index] = existing.copyWith(quantity: existing.quantity + quantity);
    } else {
      _items.add(CupboardItemModel(food: food, quantity: quantity));
    }
    notifyListeners();
  }

  FoodModel? consumeFood(String foodId) {
    final index = _items.indexWhere((item) => item.food.id == foodId);
    if (index < 0) return null;

    final item = _items[index];
    if (item.quantity <= 1) {
      _items.removeAt(index);
    } else {
      _items[index] = item.copyWith(quantity: item.quantity - 1);
    }

    notifyListeners();
    return item.food;
  }
}
