import 'package:flutter/material.dart';
import '../../vehicles/controller/vehicle_controller.dart';
import '../../vehicles/widgets/vehicle_filter_sheet.dart';

/// Ana Sayfa Başlık ve Arama Alanı (HomeHeader)
///
/// 'Aracını keşfet.' editoryal başlığını, arama çubuğunu, filtreleme butonunu
/// ve Günlük / Saatlik kiralama türü geçişini (SegmentedButton) barındırır.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Karşılama başlığı ve alt metin
        _buildGreeting(context),
        const SizedBox(height: 16),
        // Arama çubuğu ve filtre butonu
        _buildSearchAndFilterRow(context),
        const SizedBox(height: 16),
        // Günlük / Saatlik kiralama türü seçicisi
        _buildRentalTypeSegmentedButton(context),
      ],
    );
  }

  /// Editoryal karşılama başlığı
  Widget _buildGreeting(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aracını keşfet.',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Zarif, modern ve güvenilir premium kiralama filosu.',
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Arama çubuğu (SearchBar) ve filtreleme alt sayfasını açan buton
  Widget _buildSearchAndFilterRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBar(
            hintText: 'Marka, model veya kategori ara...',
            leading: const Icon(Icons.search, size: 20),
            elevation: const WidgetStatePropertyAll(0),
            onChanged: (val) => vehicleController.setSearchQuery(val),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.outlined(
          icon: const Icon(Icons.tune_rounded),
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const VehicleFilterSheet(),
          ),
          tooltip: 'Filtrele',
        ),
      ],
    );
  }

  /// Günlük / Saatlik kiralama tercihi geçiş butonu (SegmentedButton)
  Widget _buildRentalTypeSegmentedButton(BuildContext context) {
    return ListenableBuilder(
      listenable: vehicleController,
      builder: (context, _) {
        return SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'daily',
                label: Text('Günlük Kiralama'),
                icon: Icon(Icons.calendar_today_outlined, size: 16),
              ),
              ButtonSegment(
                value: 'hourly',
                label: Text('Saatlik Kiralama'),
                icon: Icon(Icons.schedule_outlined, size: 16),
              ),
            ],
            selected: {vehicleController.rentalType},
            onSelectionChanged: (set) {
              vehicleController.setRentalType(set.first);
            },
          ),
        );
      },
    );
  }
}
