import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../repository/market_repository.dart';
import '../../badges/controller/badge_controller.dart';
import '../../cupboard/controller/cupboard_controller.dart';

class MarketController extends ChangeNotifier {
  final MarketRepository _repository;
  late final List<FoodModel> _availableFoods;

  MarketController({MarketRepository? repository})
      : _repository = repository ?? MarketRepository() {
    _availableFoods = _repository.getAvailableFoods();
  }

  List<FoodModel> get availableFoods => List.unmodifiable(_availableFoods);

  bool buyFood({
    required FoodModel food,
    required BadgeController badgeController,
    required CupboardController cupboardController,
  }) {
    final success = badgeController.spendCoins(food.priceInBadges);
    if (!success) {
      return false;
    }

    cupboardController.addFood(food, quantity: 1);
    notifyListeners();
    return true;
  }
}
