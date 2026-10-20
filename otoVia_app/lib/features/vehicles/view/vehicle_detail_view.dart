import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../widgets/vehicle_specs_grid.dart';
import '../../favorites/controller/favorites_controller.dart';
import '../../comparison/controller/comparison_controller.dart';
import '../../reservations/view/reservation_flow_view.dart';
import '../../reviews/controller/review_controller.dart';
import '../../auth/controller/auth_controller.dart';
import '../../../core/widgets/status_badge.dart';

/// otoVia Araç Detay Ekranı (VehicleDetailView)
///
/// Seçilen aracın fotoğraflarını, ehliyet gereksinimi uyarılarını,
/// ızgara formundaki teknik özelliklerini, donanım listesini, kullanıcı yorumlarını
/// ve alttaki sabit rezervasyon barını sergiler.
class VehicleDetailView extends StatelessWidget {
  const VehicleDetailView({super.key, required this.vehicle});

  /// İncelenen araç nesnesi
  final VehicleModel vehicle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst galeri görseli
            _buildGallerySection(context),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Araç başlığı, kategori, yıl ve puan
                  _buildTitleSection(context),
                  const SizedBox(height: 16),
                  // Ehliyet uyumluluğu kontrol kartı
                  _buildLicenseAlert(context),
                  const SizedBox(height: 20),
                  // 2x3 formatında teknik özellikler ızgarası
                  VehicleSpecsGrid(vehicle: vehicle),
                  const SizedBox(height: 24),
                  // Donanım ve öne çıkan özellikler çipleri
                  _buildFeaturesSection(context),
                  const SizedBox(height: 24),
                  // Kullanıcı değerlendirmeleri ve yorumlar listesi
                  _buildReviewsSection(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      // Altta sabit duran fiyat ve 'Rezerve Et' butonu çubuğu
      bottomSheet: _buildBottomBookingBar(context),
    );
  }

  /// Üst çubuk: Araç adı, favori ekleme ve karşılaştırmaya ekleme butonları
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(vehicle.fullName),
      actions: [
        _buildFavoriteAction(context),
        _buildCompareAction(context),
      ],
    );
  }

  /// AppBar üzerindeki dinamik favori butonu
  Widget _buildFavoriteAction(BuildContext context) {
    return ListenableBuilder(
      listenable: favoritesController,
      builder: (context, _) {
        final isFav = favoritesController.isFavorite(vehicle.id);
        return IconButton(
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? const Color(0xFFEF5350) : null,
          ),
          onPressed: () => favoritesController.toggleFavorite(vehicle, context),
        );
      },
    );
  }

  /// AppBar üzerindeki araç karşılaştırma butonu
  Widget _buildCompareAction(BuildContext context) {
    return ListenableBuilder(
      listenable: comparisonController,
      builder: (context, _) {
        final isComparing = comparisonController.isSelected(vehicle.id);
        return IconButton(
          icon: Icon(
            isComparing ? Icons.check_circle : Icons.compare_arrows,
            color: isComparing ? const Color(0xFFC0B09A) : null,
          ),
          onPressed: () => comparisonController.toggleVehicle(vehicle, context),
        );
      },
    );
  }

  /// 16:9 oranlı vitrin görseli
  Widget _buildGallerySection(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.network(
        vehicle.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(
            child: Icon(Icons.directions_car, size: 64, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  /// Araç ismi ve ortalama değerlendirme puanı
  Widget _buildTitleSection(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vehicle.fullName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${vehicle.category.displayName} • ${vehicle.year} Model',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 22, color: Color(0xFFC0B09A)),
            const SizedBox(width: 4),
            Text(
              vehicle.rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Giriş yapan kullanıcının ehliyet sınıfının bu araç için geçerli olup olmadığını denetleyen uyarı kartı
  Widget _buildLicenseAlert(BuildContext context) {
    final userLicense = authController.currentUser?.driverLicenseClass ?? 'B';
    final isEligible = vehicle.isEligibleForLicense(userLicense);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEligible
            ? const Color(0xFF2E7D32).withValues(alpha: 0.1)
            : const Color(0xFFD32F2F).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEligible ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isEligible ? Icons.verified_user_outlined : Icons.warning_amber_rounded,
            size: 20,
            color: isEligible ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isEligible
                  ? 'Ehliyetiniz ($userLicense) bu aracı kiralamak için uygundur.'
                  : 'Bu araç ${vehicle.requiredLicenseClass} sınıfı ehliyet gerektirir. Mevcut ehliyetiniz ($userLicense) ile kiralanamaz.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isEligible ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Öne çıkan donanım ve konfor özellikleri listesi
  Widget _buildFeaturesSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Donanım ve Özellikler',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: vehicle.features.map((f) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFFC0B09A)),
                  const SizedBox(width: 6),
                  Text(
                    f,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Kullanıcı yorumları ve puanlama bölümü
  Widget _buildReviewsSection(BuildContext context) {
    final theme = Theme.of(context);
    final reviews = reviewController.getReviewsForVehicle(vehicle.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kullanıcı Yorumları (${reviews.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            StatusBadge(
              text: '${vehicle.rating} / 5.0',
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              textColor: theme.colorScheme.onSurface,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (reviews.isEmpty)
          Text(
            'Henüz bu araç için yorum yapılmamış.',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          )
        else
          ...reviews.map((r) => _buildReviewCard(context, r)),
      ],
    );
  }

  /// Tekil bir kullanıcı yorum kartı
  Widget _buildReviewCard(BuildContext context, dynamic review) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.userName,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Color(0xFFC0B09A)),
                  const SizedBox(width: 2),
                  Text(
                    '${review.rating}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  /// Ekranın en altında sabit duran fiyatlandırma ve rezervasyon adımlarına geçiş çubuğu
  Widget _buildBottomBookingBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₺${vehicle.dailyPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'günlük / ₺${vehicle.hourlyPrice.toStringAsFixed(0)} saatlik',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReservationFlowView(vehicle: vehicle),
                ),
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size(160, 48),
              ),
              child: const Text('Rezerve Et'),
            ),
          ],
        ),
      ),
    );
  }
}
