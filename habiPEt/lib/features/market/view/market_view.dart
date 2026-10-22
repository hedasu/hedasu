import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/food_model.dart';
import '../widgets/food_card.dart';

class MarketView extends StatelessWidget {
  const MarketView({super.key});

  void _handleBuy(BuildContext context, FoodModel food) {
    final badgeCtrl = AppScope.of(context).badgeController;
    final cupboardCtrl = AppScope.of(context).cupboardController;
    final marketCtrl = AppScope.of(context).marketController;

    final success = marketCtrl.buyFood(
      food: food,
      badgeController: badgeCtrl,
      cupboardController: cupboardCtrl,
    );

    if (success) {
      context.showAppSnackBar('${food.emoji} ${food.name} dolabına eklendi!');
    } else {
      context.showAppSnackBar('Yeterli rozetin yok!', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeCtrl = AppScope.of(context).badgeController;
    final marketCtrl = AppScope.of(context).marketController;

    return ListenableBuilder(
      listenable: badgeCtrl,
      builder: (context, _) {
        final coins = badgeCtrl.totalBadgeCoins;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Evcil Hayvan Marketi'),
            actions: [_MarketCoinChip(coins: coins)],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const _MarketBanner(),
                const SizedBox(height: 16),
                _MarketFoodGrid(
                  foods: marketCtrl.availableFoods,
                  userCoins: coins,
                  onBuy: (food) => _handleBuy(context, food),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MarketCoinChip extends StatelessWidget {
  final int coins;

  const _MarketCoinChip({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accentGold.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.accentGold.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🪙', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                '$coins Rozet',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarketBanner extends StatelessWidget {
  const _MarketBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkMint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkMint.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Text('🍱', style: TextStyle(fontSize: 32)),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rozetlerini Yiyeceğe Dönüştür',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2),
                Text(
                  'Alışkanlıklarından kazandığın rozetlerle besin al, evcil hayvanına seviye atlat.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketFoodGrid extends StatelessWidget {
  final List<FoodModel> foods;
  final int userCoins;
  final ValueChanged<FoodModel> onBuy;

  const _MarketFoodGrid({
    required this.foods,
    required this.userCoins,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foods.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.88,
      ),
      itemBuilder: (context, index) {
        final food = foods[index];
        final canAfford = userCoins >= food.priceInBadges;
        return FoodCard(
          food: food,
          canAfford: canAfford,
          onBuy: () => onBuy(food),
        );
      },
    );
  }
}
