import '../models/cupboard_item_model.dart';
import '../../market/models/food_model.dart';

class CupboardRepository {
  List<CupboardItemModel> getInitialItems() {
    return const [
      CupboardItemModel(
        food: FoodModel(
          id: 'food_apple',
          name: 'Kırmızı Elma',
          emoji: '🍎',
          description: 'Taze, sulu ve vitamin dolu gevrek elma.',
          priceInBadges: 10,
          satietyBoost: 12,
          expBoost: 15,
        ),
        quantity: 3,
      ),
      CupboardItemModel(
        food: FoodModel(
          id: 'food_milk',
          name: 'Taze Süt',
          emoji: '🥛',
          description: 'Kalsiyum deposu, kemikleri ve zihni güçlendirir.',
          priceInBadges: 15,
          satietyBoost: 18,
          expBoost: 22,
        ),
        quantity: 2,
      ),
      CupboardItemModel(
        food: FoodModel(
          id: 'food_fish',
          name: 'Taze Somon',
          emoji: '🐟',
          description: 'Kedilerin rüyalarını süsleyen leziz omega-3 balık.',
          priceInBadges: 25,
          satietyBoost: 30,
          expBoost: 40,
        ),
        quantity: 1,
      ),
    ];
  }
}
