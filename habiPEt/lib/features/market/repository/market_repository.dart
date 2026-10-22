import '../models/food_model.dart';

class MarketRepository {
  List<FoodModel> getAvailableFoods() {
    return const [
      FoodModel(
        id: 'food_apple',
        name: 'Kırmızı Elma',
        emoji: '🍎',
        description: 'Taze, sulu ve vitamin dolu gevrek elma.',
        priceInBadges: 10,
        satietyBoost: 12,
        expBoost: 15,
      ),
      FoodModel(
        id: 'food_carrot',
        name: 'Çıtır Havuç',
        emoji: '🥕',
        description: 'Tavşan ve dostlarının bayıldığı organik havuç.',
        priceInBadges: 12,
        satietyBoost: 15,
        expBoost: 18,
      ),
      FoodModel(
        id: 'food_milk',
        name: 'Taze Süt',
        emoji: '🥛',
        description: 'Kalsiyum deposu, kemikleri ve zihni güçlendirir.',
        priceInBadges: 15,
        satietyBoost: 18,
        expBoost: 22,
      ),
      FoodModel(
        id: 'food_fish',
        name: 'Taze Somon',
        emoji: '🐟',
        description: 'Kedilerin rüyalarını süsleyen leziz omega-3 balık.',
        priceInBadges: 25,
        satietyBoost: 30,
        expBoost: 40,
      ),
      FoodModel(
        id: 'food_cookie',
        name: 'Gelişim Bisküvisi',
        emoji: '🍪',
        description: 'Özel formülle hazırlanmış besleyici ödül bisküvisi.',
        priceInBadges: 20,
        satietyBoost: 25,
        expBoost: 30,
      ),
      FoodModel(
        id: 'food_cake',
        name: 'Kutlama Pastası',
        emoji: '🧁',
        description: 'Büyük başarıları kutlamak için leziz çilekli cupcake.',
        priceInBadges: 40,
        satietyBoost: 45,
        expBoost: 60,
      ),
      FoodModel(
        id: 'food_magic_berry',
        name: 'Sihirli Meyve',
        emoji: '🫐',
        description: 'Gece ormanından toplanmış efsanevi süper enerji meyvesi.',
        priceInBadges: 50,
        satietyBoost: 60,
        expBoost: 85,
      ),
    ];
  }
}
