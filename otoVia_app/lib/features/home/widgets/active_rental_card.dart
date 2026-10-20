import 'package:flutter/material.dart';
import '../../reservations/controller/reservation_controller.dart';
import '../../support/view/live_support_dialog.dart';
import '../../delivery/view/delivery_check_view.dart';
import '../../../core/widgets/status_badge.dart';

/// Aktif Kiralama Durum Kartı (ActiveRentalCard)
///
/// Kullanıcının şu anda devam eden bir araç kiralaması varsa ana sayfanın en üstünde
/// lüks bir çerçeve ile görüntülenir. Teslim tarihi, canlı destek, süre uzatma
/// ve teslimat kontrol adımlarına tek tıkla erişim imkanı sağlar.
class ActiveRentalCard extends StatelessWidget {
  const ActiveRentalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: reservationController,
      builder: (context, _) {
        final active = reservationController.activeRental;
        // Devam eden kiralama yoksa hiçbir şey gösterme
        if (active == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFC0B09A),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst rozet ve planlanan teslim tarihi
              _buildTopBadgeRow(context, active),
              const SizedBox(height: 10),
              // Araç küçük resmi, adı ve teslim alma lokasyonu
              _buildVehicleInfo(context, active),
              const SizedBox(height: 14),
              // Canlı Destek, Süre Uzat ve Teslim Et butonları
              _buildActionsRow(context, active),
            ],
          ),
        );
      },
    );
  }

  /// 'Aktif Kiralamanız' yeşil rozeti ve teslim zamanı satırı
  Widget _buildTopBadgeRow(BuildContext context, dynamic active) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const StatusBadge(
          text: 'AKTİF KİRALAMANIZ',
          backgroundColor: Color(0xFF2E7D32),
          textColor: Colors.white,
          icon: Icons.key_rounded,
        ),
        Text(
          'Teslim: ${_formatDate(active.endDate)}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Araç fotoğrafı ve model ismi satırı
  Widget _buildVehicleInfo(BuildContext context, dynamic active) {
    final theme = Theme.of(context);
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            active.vehicle.imageUrl,
            width: 72,
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
                active.vehicle.fullName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                active.pickupLocation,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Aktif kiralama yönetim aksiyonları (Canlı Destek, Süre Uzat, Teslim Et)
  Widget _buildActionsRow(BuildContext context, dynamic active) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.headset_mic_outlined, size: 16),
            label: const Text('Canlı Destek', style: TextStyle(fontSize: 12)),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const LiveSupportDialog(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.more_time_rounded, size: 16),
            label: const Text('Süre Uzat', style: TextStyle(fontSize: 12)),
            onPressed: () => _showExtendDialog(context, active),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton.icon(
            icon: const Icon(Icons.task_alt, size: 16),
            label: const Text('Teslim Et', style: TextStyle(fontSize: 12)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DeliveryCheckView(reservation: active),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Kiralama süresini 1 gün uzatma onay diyaloğu
  void _showExtendDialog(BuildContext context, dynamic active) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kiralama Süresini Uzat'),
        content: Text(
          '${active.vehicle.fullName} için kiralama süresini 1 gün uzatmak istiyor musunuz?\n\n'
          'Ek Ücret: ₺${active.unitPrice.toStringAsFixed(0)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () {
              reservationController.extendReservation(active.id, 1);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kiralama süresi başarıyla 1 gün uzatıldı.')),
              );
            },
            child: const Text('Onayla ve Uzat'),
          ),
        ],
      ),
    );
  }

  /// Tarih ve saat biçimlendirici (GG.AA SS:DD)
  String _formatDate(DateTime dt) {
    return '${dt.day}.${dt.month.toString().padLeft(2, '0')} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
