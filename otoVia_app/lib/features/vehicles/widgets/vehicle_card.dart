import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../../favorites/controller/favorites_controller.dart';
import '../../comparison/controller/comparison_controller.dart';
import '../view/vehicle_detail_view.dart';
import '../../../core/widgets/status_badge.dart';

/// otoVia Araç Kartı Bileşeni (VehicleCard)
///
/// Ana sayfa listesinde ve arama sonuçlarında aracı lüks editoryal stilde sergiler.
/// 16:9 görsel, kategori rozeti, favori butonu, araç adı, puan, özellik etiketleri,
/// fiyat ve karşılaştırma/detay aksiyon butonlarını içerir.
class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.isHourly,
  });

  /// Kartta sergilenecek araç modeli
  final VehicleModel vehicle;

  /// Saatlik kiralama modu mu yoksa günlük mü olduğunu belirler
  final bool isHourly;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Araç fotoğrafı, kategori etiketi ve favori butonu
          _buildImageSection(context),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Araç adı ve yıldızlı puan
                _buildHeaderRow(context),
                const SizedBox(height: 8),
                // Yıl, yakıt, vites ve ehliyet sınıfı etiketleri
                _buildSpecsRow(context),
                const SizedBox(height: 14),
                // İnce ayırıcı çizgi
                _buildDivider(context),
                const SizedBox(height: 14),
                // Fiyat bilgisi, karşılaştır butonu ve detay sayfası butonu
                _buildBottomActionRow(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 16:9 oranlı görsel, kategori rozeti ve favori butonunu içeren üst görsel alanı
  Widget _buildImageSection(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            vehicle.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.directions_car_outlined,
                  size: 54,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        // Kategori Rozeti (Sol üst)
        Positioned(
          top: 12,
          left: 12,
          child: StatusBadge(
            text: vehicle.category.displayName,
            backgroundColor: Colors.black.withValues(alpha: 0.75),
            textColor: Colors.white,
          ),
        ),
        // Favorilere Ekle / Çıkar Butonu (Sağ üst)
        Positioned(
          top: 12,
          right: 12,
          child: _buildFavoriteButton(context),
        ),
      ],
    );
  }

  /// Favori durumu dinleyen ve tek tıkla favoriye ekleyen buton
  Widget _buildFavoriteButton(BuildContext context) {
    return ListenableBuilder(
      listenable: favoritesController,
      builder: (context, _) {
        final isFav = favoritesController.isFavorite(vehicle.id);
        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.65),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: isFav ? const Color(0xFFEF5350) : Colors.white,
            ),
            onPressed: () => favoritesController.toggleFavorite(vehicle, context),
            constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            padding: EdgeInsets.zero,
          ),
        );
      },
    );
  }

  /// Araç tam adı ve puan ortalaması satırı
  Widget _buildHeaderRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            vehicle.fullName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 18, color: Color(0xFFC0B09A)),
            const SizedBox(width: 3),
            Text(
              vehicle.rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Temel teknik özellikleri (yıl, yakıt, vites, ehliyet) gösteren etiketler
  Widget _buildSpecsRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _buildSpecTag('${vehicle.year}', theme),
        const SizedBox(width: 8),
        _buildSpecTag(vehicle.fuelType, theme),
        const SizedBox(width: 8),
        _buildSpecTag(vehicle.transmission, theme),
        const Spacer(),
        StatusBadge(
          text: '${vehicle.requiredLicenseClass} Ehliyet',
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          textColor: theme.colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  /// Küçük teknik özellik hap etiketi (badge)
  Widget _buildSpecTag(String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  /// Kart içi ince ayırıcı
  Widget _buildDivider(BuildContext context) {
    return Divider(height: 1, color: Theme.of(context).colorScheme.outline);
  }

  /// Alt aksiyon alanı: Fiyat, Karşılaştırma butonu ve Detay İncele butonu
  Widget _buildBottomActionRow(BuildContext context) {
    final theme = Theme.of(context);
    final double price = isHourly ? vehicle.hourlyPrice : vehicle.dailyPrice;
    final String unit = isHourly ? '/ saat' : '/ gün';

    return Row(
      children: [
        // Fiyat ve birim göstergesi
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₺${price.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Karşılaştırma listesine ekle butonu
        _buildCompareIconButton(context),
        const SizedBox(width: 8),
        // Detay sayfasına geçiş butonu
        FilledButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VehicleDetailView(vehicle: vehicle),
            ),
          ),
          style: FilledButton.styleFrom(
            minimumSize: const Size(120, 42),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text('Aracı İncele'),
        ),
      ],
    );
  }

  /// Karşılaştırma listesi seçim butonunu inşa eden metot
  Widget _buildCompareIconButton(BuildContext context) {
    return ListenableBuilder(
      listenable: comparisonController,
      builder: (context, _) {
        final isComparing = comparisonController.isSelected(vehicle.id);
        return IconButton.outlined(
          icon: Icon(
            isComparing ? Icons.check_circle : Icons.compare_arrows,
            size: 18,
            color: isComparing ? const Color(0xFFC0B09A) : null,
          ),
          onPressed: () => comparisonController.toggleVehicle(vehicle, context),
          tooltip: 'Karşılaştır',
        );
      },
    );
  }
}
