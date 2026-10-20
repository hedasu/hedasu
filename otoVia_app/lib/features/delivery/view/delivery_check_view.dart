import 'package:flutter/material.dart';
import '../../reservations/models/reservation_model.dart';
import '../../reservations/controller/reservation_controller.dart';
import '../../../core/extensions/context_extensions.dart';

class DeliveryCheckView extends StatefulWidget {
  const DeliveryCheckView({super.key, required this.reservation});

  final ReservationModel reservation;

  @override
  State<DeliveryCheckView> createState() => _DeliveryCheckViewState();
}

class _DeliveryCheckViewState extends State<DeliveryCheckView> {
  final TextEditingController _notesController = TextEditingController();
  int _photosAdded = 2;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Araç Teslim Etme')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVehicleSummary(context),
            const SizedBox(height: 20),
            _buildPhotoUploadSection(context),
            const SizedBox(height: 20),
            _buildDamageNotesField(context),
            const SizedBox(height: 28),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSummary(BuildContext context) {
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
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.reservation.vehicle.imageUrl,
              width: 80,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.reservation.vehicle.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Teslim Bırakma: ${widget.reservation.dropoffLocation}',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUploadSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Güncel Araç Fotoğrafları', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        const Text(
          'Aracın 4 köşesinden, ön ve arka kısımlarından güncel durumu yansıtan fotoğraflar ekleyiniz.',
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text('Fotoğraf Ekle'),
              onPressed: () {
                setState(() => _photosAdded++);
                context.showAppSnackBar('Fotoğraf başarıyla eklendi (Simülasyon).');
              },
            ),
            const SizedBox(width: 14),
            Text('$_photosAdded Fotoğraf Eklendi', style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildDamageNotesField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Teslim Notu ve Kilometre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Araç durumu, yakıt seviyesi veya teslimat ile ilgili notlar...',
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return FilledButton(
      onPressed: _isSubmitting ? null : _submitDropoff,
      child: _isSubmitting
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Teslimatı Onayla ve Tamamla'),
    );
  }

  Future<void> _submitDropoff() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    reservationController.completeDeliveryDropoff(
      widget.reservation.id,
      _notesController.text.trim().isEmpty ? 'Sorunsuz teslim edildi.' : _notesController.text.trim(),
      _photosAdded,
    );
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.pop(context);
    context.showAppSnackBar('Araç teslim işlemi başarıyla tamamlandı!');
  }
}
