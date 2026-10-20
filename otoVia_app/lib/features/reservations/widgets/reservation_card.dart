import 'package:flutter/material.dart';
import '../models/reservation_model.dart';
import '../controller/reservation_controller.dart';
import '../view/reservation_detail_view.dart';
import '../../reviews/view/add_review_dialog.dart';
import '../../support/view/live_support_dialog.dart';
import '../../../core/widgets/status_badge.dart';

/// otoVia Rezervasyon Kartı Bileşeni (ReservationCard)
///
/// 'Kiralamalar' sekmesinde her bir rezervasyon kaydını durum rozeti (Aktif, Gelecek,
/// Tamamlandı, İptal), araç görseli, kiralama tarih aralığı, toplam ücret ve
/// duruma özel aksiyon butonları (Detaylar, İptal Et, Destek, Değerlendir) ile gösterir.
class ReservationCard extends StatelessWidget {
  const ReservationCard({super.key, required this.reservation});

  /// Görüntülenecek rezervasyon nesnesi
  final ReservationModel reservation;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst satır: Durum rozeti ve rezervasyon referans kodu
            _buildTopRow(context),
            const SizedBox(height: 12),
            // Araç resmi, adı, kiralama türü ve toplam bedel
            _buildVehicleRow(context),
            const SizedBox(height: 12),
            // Başlangıç ve bitiş tarih kutucuğu
            _buildDetailsRow(context),
            const SizedBox(height: 14),
            // Duruma bağlı aksiyon butonları
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  /// Durum rozeti (yeşil, mavi, gri, kırmızı) ve kısa ID
  Widget _buildTopRow(BuildContext context) {
    Color bg;
    Color fg = Colors.white;
    switch (reservation.status) {
      case ReservationStatus.active:
        bg = const Color(0xFF2E7D32); // Yeşil
        break;
      case ReservationStatus.upcoming:
        bg = const Color(0xFF0288D1); // Mavi
        break;
      case ReservationStatus.completed:
        bg = const Color(0xFF62625F); // Gri
        break;
      case ReservationStatus.cancelled:
        bg = const Color(0xFFD32F2F); // Kırmızı
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatusBadge(
          text: reservation.status.displayName.toUpperCase(),
          backgroundColor: bg,
          textColor: fg,
        ),
        Text(
          '#${reservation.id.substring(reservation.id.length - 6)}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Araç fotoğrafı, modeli ve toplam tutar
  Widget _buildVehicleRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            reservation.vehicle.imageUrl,
            width: 70,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.car_rental, size: 40),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reservation.vehicle.fullName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${reservation.rentalType == 'hourly' ? 'Saatlik' : 'Günlük'} • ${reservation.totalDurationUnits} ${reservation.rentalType == 'hourly' ? 'Saat' : 'Gün'}',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Text(
          '₺${reservation.finalPrice.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  /// Başlangıç ve bitiş tarihlerini içeren yatay bilgi kutucuğu
  Widget _buildDetailsRow(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDateCol('Başlangıç', reservation.startDate, theme),
          const Icon(Icons.arrow_forward, size: 16, color: Color(0xFFC0B09A)),
          _buildDateCol('Bitiş', reservation.endDate, theme),
        ],
      ),
    );
  }

  /// Tarih ve saat sütunu
  Widget _buildDateCol(String label, DateTime dt, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant)),
        Text(
          '${dt.day}.${dt.month.toString().padLeft(2, '0')}.${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  /// Rezervasyon durumuna göre dinamik butonlar
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Her durumda detay sayfasına gitme butonu
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReservationDetailView(reservation: reservation),
              ),
            ),
            child: const Text('Detaylar', style: TextStyle(fontSize: 13)),
          ),
        ),
        // Gelecek kiralama ise iptal et seçeneği
        if (reservation.isUpcoming) ...[
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFD32F2F)),
              onPressed: () => _confirmCancellation(context),
              child: const Text('İptal Et', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
        // Aktif kiralama ise hızlı canlı destek butonu
        if (reservation.isActive) ...[
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const LiveSupportDialog(),
              ),
              child: const Text('Destek', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
        // Tamamlanmış kiralama ise aracı puanlama ve yorum yapma butonu
        if (reservation.isCompleted) ...[
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton.tonal(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AddReviewDialog(vehicle: reservation.vehicle),
              ),
              child: const Text('Değerlendir', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ],
    );
  }

  /// Rezervasyon iptal onay modal diyaloğu
  void _confirmCancellation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rezervasyonu İptal Et'),
        content: Text(
          '${reservation.vehicle.fullName} için planlanan rezervasyonunuzu iptal etmek istediğinize emin misiniz? Depozito ve kiralama ücretiniz iade edilecektir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
            onPressed: () {
              reservationController.cancelReservation(reservation.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rezervasyonunuz iptal edildi.')),
              );
            },
            child: const Text('Evet, İptal Et'),
          ),
        ],
      ),
    );
  }
}
