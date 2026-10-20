import 'package:flutter/material.dart';
import '../models/reservation_model.dart';
import '../../support/view/live_support_dialog.dart';

class ReservationDetailView extends StatelessWidget {
  const ReservationDetailView({super.key, required this.reservation});

  final ReservationModel reservation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rezervasyon Detayı')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVehicleBanner(context),
            const SizedBox(height: 20),
            _buildDatesCard(context),
            const SizedBox(height: 16),
            _buildPricingCard(context),
            const SizedBox(height: 16),
            _buildDeliveryCard(context),
            const SizedBox(height: 24),
            if (reservation.isActive) _buildLiveSupportButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleBanner(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              reservation.vehicle.imageUrl,
              width: 90,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reservation.vehicle.fullName,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${reservation.vehicle.category.displayName} • ${reservation.vehicle.year}',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatesCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lokasyon ve Zaman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          _buildInfoRow('Teslim Alma:', '${reservation.pickupLocation}\n${_fmt(reservation.startDate)}'),
          const SizedBox(height: 8),
          _buildInfoRow('Teslim Bırakma:', '${reservation.dropoffLocation}\n${_fmt(reservation.endDate)}'),
        ],
      ),
    );
  }

  Widget _buildPricingCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ödeme Dökümü', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          _buildInfoRow('Kiralama Bedeli:', '₺${reservation.basePrice.toStringAsFixed(0)}'),
          _buildInfoRow('VIP Kasko Bedeli:', '₺${reservation.extraInsurance.toStringAsFixed(0)}'),
          if (reservation.discountAmount > 0)
            _buildInfoRow('İndirim Tutarı:', '-₺${reservation.discountAmount.toStringAsFixed(0)}'),
          _buildInfoRow('Depozito (İade Edilir):', '₺${reservation.deposit.toStringAsFixed(0)}'),
          const Divider(height: 16),
          _buildInfoRow('Toplam Ödenen:', '₺${reservation.finalPrice.toStringAsFixed(0)}', isBold: true),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(BuildContext context) {
    final rec = reservation.deliveryRecord;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fotoğraflı Teslim Kayıtları', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Text('Teslim Alma Notu: ${rec.pickupNotes.isEmpty ? "Not yok" : rec.pickupNotes} (${rec.pickupPhotosCount} fotoğraf eklendi)'),
          const SizedBox(height: 4),
          Text('Teslim Etme Durumu: ${rec.dropoffConfirmed ? "Tamamlandı" : "Henüz teslim edilmedi"}'),
        ],
      ),
    );
  }

  Widget _buildLiveSupportButton(BuildContext context) {
    return FilledButton.icon(
      icon: const Icon(Icons.headset_mic),
      label: const Text('Bu Araç İçin Canlı Desteğe Bağlan'),
      onPressed: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const LiveSupportDialog(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, textAlign: TextAlign.right, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) {
    return '${dt.day}.${dt.month.toString().padLeft(2, '0')}.${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
