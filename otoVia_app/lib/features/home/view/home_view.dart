import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/active_rental_card.dart';
import '../widgets/category_chips_bar.dart';
import '../widgets/purpose_selector.dart';
import '../../vehicles/controller/vehicle_controller.dart';
import '../../vehicles/widgets/vehicle_card.dart';
import '../../../core/widgets/empty_state_widget.dart';

/// otoVia Ana Sayfa Ekranı (HomeView)
///
/// Kullanıcıyı karşılayan ana vitrin ekranıdır. Aktif kiralama durumu kartı,
/// arama çubuğu, kategori ve kullanım amacı çipleri ile filtrelenmiş araç listesini (SliverList) sunar.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Araç listesindeki filtreleme veya kiralama türü değişikliklerini reaktif dinliyoruz
    return ListenableBuilder(
      listenable: vehicleController,
      builder: (context, _) {
        final vehicles = vehicleController.filteredVehicles;
        return CustomScrollView(
          slivers: [
            // Üst bölüm: Karşılama, Arama, Kategori ve Amaç seçicileri
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kullanıcının varsa devam eden aktif kiralamasını gösteren kart
                    const ActiveRentalCard(),
                    // Başlık, arama çubuğu ve saatlik/günlük geçiş butonları
                    const HomeHeader(),
                    const SizedBox(height: 18),
                    // Kategori filtreleme çipleri
                    const CategoryChipsBar(),
                    const SizedBox(height: 16),
                    // Kullanım amacına göre öneri bölümü başlığı
                    _buildPurposeSectionTitle(context),
                    const SizedBox(height: 8),
                    // Kullanım amacı seçim çipleri
                    const PurposeSelector(),
                    const SizedBox(height: 20),
                    // Araç listesi başlığı ve adet göstergesi
                    _buildVehicleListHeader(context, vehicles.length),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            // Filtrelenmiş araçların kartlar halinde dikey listelendiği sliver
            _buildVehicleListSliver(vehicles),
            // Alt gezinti çubuğu için boşluk
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        );
      },
    );
  }

  /// 'Kullanım Amacına Göre Öneriler' bölüm başlığı
  Widget _buildPurposeSectionTitle(BuildContext context) {
    return Text(
      'Kullanım Amacına Göre Öneriler',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 0.2,
      ),
    );
  }

  /// 'Öne Çıkan Araçlar' başlığı ve araç sayısı sayacı
  Widget _buildVehicleListHeader(BuildContext context, int count) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Öne Çıkan Araçlar',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          '$count Araç',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Araç kartları sliver listesi (sonuç bulunamazsa EmptyStateWidget gösterir)
  Widget _buildVehicleListSliver(List<dynamic> vehicles) {
    if (vehicles.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: EmptyStateWidget(
            icon: Icons.search_off_rounded,
            title: 'Araç Bulunamadı',
            message: 'Arama kriterlerinize veya seçilen filtrelere uygun araç bulunamadı.',
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final vehicle = vehicles[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: VehicleCard(
                vehicle: vehicle,
                isHourly: vehicleController.isHourly,
              ),
            );
          },
          childCount: vehicles.length,
        ),
      ),
    );
  }
}
