import 'package:flutter/material.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/router/app_router.dart';
import '../../../core/extensions/context_extensions.dart';
import '../widgets/food_inventory_card.dart';

class CupboardView extends StatelessWidget {
  const CupboardView({super.key});

  void _feed(BuildContext context, String foodId) {
    final cupboardCtrl = AppScope.of(context).cupboardController;
    final petCtrl = AppScope.of(context).petController;

    final food = cupboardCtrl.consumeFood(foodId);
    if (food != null) {
      final leveledUp = petCtrl.feedPet(
        satietyBoost: food.satietyBoost,
        expBoost: food.expBoost,
      );

      if (leveledUp) {
        context.showAppSnackBar(
          '🎉 Tebrikler! ${petCtrl.pet.name} Seviye ${petCtrl.pet.level}\'e yükseldi!',
        );
      } else {
        context.showAppSnackBar(
          '${petCtrl.pet.name} afiyetle ${food.name} yedi! (+${food.expBoost} XP)',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cupboardCtrl = AppScope.of(context).cupboardController;

    return ListenableBuilder(
      listenable: cupboardCtrl,
      builder: (context, _) {
        final items = cupboardCtrl.items;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Yiyecek Dolabı'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_shopping_cart_rounded),
                tooltip: 'Markete Git',
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRouter.marketRoute),
              ),
            ],
          ),
          body: SafeArea(
            child: items.isEmpty
                ? _EmptyCupboard(
                    onGoToMarket: () =>
                        Navigator.of(context).pushNamed(AppRouter.marketRoute),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.88,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return FoodInventoryCard(
                        item: item,
                        onFeed: () => _feed(context, item.food.id),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}

class _EmptyCupboard extends StatelessWidget {
  final VoidCallback onGoToMarket;

  const _EmptyCupboard({required this.onGoToMarket});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🥣', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              'Dolabın Boşaldı!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Evcil hayvanını beslemek için marketten rozetlerinle taze yiyecekler alabilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onGoToMarket,
              icon: const Icon(Icons.storefront_rounded),
              label: const Text('Markete Git'),
            ),
          ],
        ),
      ),
    );
  }
}
