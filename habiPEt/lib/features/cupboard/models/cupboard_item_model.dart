import '../../market/models/food_model.dart';

class CupboardItemModel {
  final FoodModel food;
  final int quantity;

  const CupboardItemModel({
    required this.food,
    required this.quantity,
  });

  CupboardItemModel copyWith({
    FoodModel? food,
    int? quantity,
  }) {
    return CupboardItemModel(
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
    );
  }
}
