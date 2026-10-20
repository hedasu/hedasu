import 'package:flutter/material.dart';
import '../controller/favorites_controller.dart';
import '../../comparison/controller/comparison_controller.dart';
import '../../comparison/view/comparison_view.dart';
import '../../vehicles/widgets/vehicle_card.dart';
import '../../../core/widgets/empty_state_widget.dart';

/// otoVia Favoriler Ekranı (FavoritesView)
///
/// Kullanıcının kalp simgesiyle favorilerine eklediği araçları listeler.
/// Karşılaştırma listesinde araç seçiliyse alt köşede hızlı karşılaştırma FAB butonu sunar.
class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: favoritesController,
      builder: (context, _) {
        final favorites = favoritesController.favoriteVehicles;
        return Scaffold(
          appBar: _buildAppBar(context, favorites.length),
          body: _buildBody(context, favorites),
          floatingActionButton: _buildComparisonFAB(context),
        );
      },
    );
  }

  /// AppBar: 'Favorilerim (X)' başlığı
  PreferredSizeWidget _buildAppBar(BuildContext context, int count) {
    return AppBar(
      title: Text('Favorilerim ($count)'),
    );
  }

  /// Favori listesi gövdesi (boş ise açıklayıcı EmptyStateWidget gösterilir)
  Widget _buildBody(BuildContext context, List<dynamic> favorites) {
    if (favorites.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.favorite_border_rounded,
        title: 'Favori Araç Yok',
        message: 'Beğendiğiniz lüks araçları kalp simgesine dokunarak favorilerinize ekleyebilirsiniz.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final vehicle = favorites[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: VehicleCard(
            vehicle: vehicle,
            isHourly: false,
          ),
        );
      },
    );
  }

  /// Karşılaştırma listesinde araç varsa gösterilen genişletilmiş FAB (FloatingActionButton)
  Widget? _buildComparisonFAB(BuildContext context) {
    return ListenableBuilder(
      listenable: comparisonController,
      builder: (context, _) {
        if (!comparisonController.hasVehicles) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ComparisonView()),
          ),
          icon: const Icon(Icons.compare_arrows),
          label: Text('Karşılaştır (${comparisonController.selectedVehicles.length})'),
        );
      },
    );
  }
}
