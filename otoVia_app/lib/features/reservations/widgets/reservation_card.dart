import 'package:flutter/material.dart';
import '../models/reservation_model.dart';
import '../controller/reservation_controller.dart';
import '../view/reservation_detail_view.dart';
import '../../reviews/view/add_review_dialog.dart';
import '../../support/view/live_support_dialog.dart';
import '../../../core/widgets/status_badge.dart';

class ReservationCard extends StatelessWidget {
  const ReservationCard({super.key, required this.reservation});

  final ReservationModel reservation;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopRow(context),
            const SizedBox(height: 12),
            _buildVehicleRow(context),
            const SizedBox(height: 12),
            _buildDetailsRow(context),
            const SizedBox(height: 14),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    Color bg;
    Color fg = Colors.white;
    switch (reservation.status) {
      case ReservationStatus.active:
        bg = const Color(0xFF2E7D32);
        break;
      case ReservationStatus.upcoming:
        bg = const Color(0xFF0288D1);
        break;
      case ReservationStatus.completed:
        bg = const Color(0xFF62625F);
        break;
      case ReservationStatus.cancelled:
        bg = const Color(0xFFD32F2F);
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
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
