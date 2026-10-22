class FoodModel {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final int priceInBadges;
  final int satietyBoost;
  final int expBoost;

  const FoodModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.priceInBadges,
    required this.satietyBoost,
    required this.expBoost,
  });
}
