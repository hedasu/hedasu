import 'package:flutter/material.dart';
import '../../pets/models/pet_model.dart';
import '../../pets/widgets/home_pet_widget.dart';
import '../../pets/widgets/pet_level_indicator.dart';
import '../../pets/widgets/pet_age_indicator.dart';
import '../../cupboard/models/cupboard_item_model.dart';
import '../../../core/constants/app_colors.dart';

class PetPreviewCard extends StatelessWidget {
  final PetModel pet;
  final List<CupboardItemModel> cupboardItems;
  final bool isCupboardOpen;
  final VoidCallback onToggleCupboard;
  final ValueChanged<String> onFeedPet;
  final VoidCallback onGoToMarket;
  final VoidCallback onChangePet;

  const PetPreviewCard({
    super.key,
    required this.pet,
    required this.cupboardItems,
    required this.isCupboardOpen,
    required this.onToggleCupboard,
    required this.onFeedPet,
    required this.onGoToMarket,
    required this.onChangePet,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _PetTopRow(pet: pet, onChangePet: onChangePet),
            const SizedBox(height: 10),
            HomePetWidget(
              pet: pet,
              size: 160,
              showStageBadge: true,
            ),
            const SizedBox(height: 14),
            PetLevelIndicator(
              level: pet.level,
              currentExp: pet.currentExp,
              maxExp: pet.maxExp,
            ),
            const SizedBox(height: 16),
            _CupboardSection(
              isOpen: isCupboardOpen,
              items: cupboardItems,
              onToggle: onToggleCupboard,
              onFeed: onFeedPet,
              onGoToMarket: onGoToMarket,
            ),
          ],
        ),
      ),
    );
  }
}

class _PetTopRow extends StatelessWidget {
  final PetModel pet;
  final VoidCallback onChangePet;

  const _PetTopRow({required this.pet, required this.onChangePet});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  pet.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  tooltip: 'Hayvanı veya İsmi Değiştir',
                  onPressed: onChangePet,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              pet.type.displayName,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
        PetAgeIndicator(formattedAge: pet.ageFormatted),
      ],
    );
  }
}

class _CupboardSection extends StatelessWidget {
  final bool isOpen;
  final List<CupboardItemModel> items;
  final VoidCallback onToggle;
  final ValueChanged<String> onFeed;
  final VoidCallback onGoToMarket;

  const _CupboardSection({
    required this.isOpen,
    required this.items,
    required this.onToggle,
    required this.onFeed,
    required this.onGoToMarket,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CupboardHeaderRow(isOpen: isOpen, onToggle: onToggle),
        if (isOpen) ...[
          const SizedBox(height: 10),
          _CupboardScrollList(
            items: items,
            onFeed: onFeed,
            onGoToMarket: onGoToMarket,
          ),
        ],
      ],
    );
  }
}

class _CupboardHeaderRow extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onToggle;

  const _CupboardHeaderRow({required this.isOpen, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.kitchen_rounded, size: 18, color: AppColors.accentOrange),
                SizedBox(width: 6),
                Text(
                  'Yiyecek Dolabı',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Icon(
              isOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _CupboardScrollList extends StatelessWidget {
  final List<CupboardItemModel> items;
  final ValueChanged<String> onFeed;
  final VoidCallback onGoToMarket;

  const _CupboardScrollList({
    required this.items,
    required this.onFeed,
    required this.onGoToMarket,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...items.map((item) {
            return _FoodQuickFeedItem(item: item, onFeed: () => onFeed(item.food.id));
          }),
          _AddFoodMarketButton(onTap: onGoToMarket),
        ],
      ),
    );
  }
}

class _FoodQuickFeedItem extends StatelessWidget {
  final CupboardItemModel item;
  final VoidCallback onFeed;

  const _FoodQuickFeedItem({required this.item, required this.onFeed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFeed,
      child: Container(
        width: 64,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.food.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 2),
            Text(
              'x${item.quantity}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.accentGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddFoodMarketButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddFoodMarketButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: primaryColor,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: primaryColor, size: 24),
            const SizedBox(height: 2),
            Text(
              'Market',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
