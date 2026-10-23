import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/router/app_router.dart';
import '../models/pet_model.dart';
import '../widgets/home_pet_widget.dart';
import '../widgets/pet_level_indicator.dart';
import '../widgets/pet_age_indicator.dart';

class PetDetailView extends StatelessWidget {
  const PetDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final petCtrl = AppScope.of(context).petController;

    return ListenableBuilder(
      listenable: petCtrl,
      builder: (context, _) {
        final pet = petCtrl.pet;
        return Scaffold(
          appBar: AppBar(
            title: Text(pet.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.swap_horiz_rounded),
                tooltip: 'Hayvanı Değiştir',
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRouter.petSelectionRoute),
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _PetHeroSection(pet: pet),
                const SizedBox(height: 24),
                _PetStatsCard(pet: pet),
                const SizedBox(height: 20),
                _PetDescriptionCard(pet: pet),
                const SizedBox(height: 24),
                _PetActionButtons(
                  onChangePet: () => Navigator.of(context)
                      .pushNamed(AppRouter.petSelectionRoute),
                  onOpenMarket: () =>
                      Navigator.of(context).pushNamed(AppRouter.marketRoute),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PetHeroSection extends StatelessWidget {
  final PetModel pet;

  const _PetHeroSection({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomePetWidget(
          pet: pet,
          size: 170,
          showStageBadge: true,
        ),
        const SizedBox(height: 12),
        Text(
          pet.name,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        PetAgeIndicator(formattedAge: pet.ageFormatted),
      ],
    );
  }
}

class _PetStatsCard extends StatelessWidget {
  final dynamic pet;

  const _PetStatsCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            PetLevelIndicator(
              level: pet.level,
              currentExp: pet.currentExp,
              maxExp: pet.maxExp,
            ),
            const SizedBox(height: 16),
            _SatietyRow(satiety: pet.satiety),
          ],
        ),
      ),
    );
  }
}

class _SatietyRow extends StatelessWidget {
  final int satiety;

  const _SatietyRow({required this.satiety});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.restaurant_rounded, size: 16, color: AppColors.accentOrange),
                SizedBox(width: 6),
                Text('Doygunluk Oranı', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
            Text(
              '%$satiety',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.accentOrange),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: satiety / 100.0,
            minHeight: 8,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentOrange),
          ),
        ),
      ],
    );
  }
}

class _PetDescriptionCard extends StatelessWidget {
  final dynamic pet;

  const _PetDescriptionCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: AppColors.darkMint),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                pet.type.description,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetActionButtons extends StatelessWidget {
  final VoidCallback onChangePet;
  final VoidCallback onOpenMarket;

  const _PetActionButtons({
    required this.onChangePet,
    required this.onOpenMarket,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onChangePet,
            icon: const Icon(Icons.swap_horiz_rounded),
            label: const Text('Tür Değiştir'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: onOpenMarket,
            icon: const Icon(Icons.storefront_rounded),
            label: const Text('Markete Git'),
          ),
        ),
      ],
    );
  }
}
