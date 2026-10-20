import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';

/// Araç Teknik Özellikleri Izgara Bileşeni (VehicleSpecsGrid)
///
/// Araç detay sayfasında model yılı, yakıt türü, vites, yolcu kapasitesi,
/// bagaj hacmi ve gereken ehliyet sınıfı gibi temel teknik verileri
/// 2 satır x 3 sütun halinde ikonlu ve şık bir kart içerisinde sunar.
class VehicleSpecsGrid extends StatelessWidget {
  const VehicleSpecsGrid({super.key, required this.vehicle});

  /// Özellikleri görüntülenecek araç
  final VehicleModel vehicle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        children: [
          // 1. Satır: Model Yılı, Yakıt Türü, Vites Türü
          Row(
            children: [
              _buildSpecTile(context, Icons.speed, 'Model Yılı', '${vehicle.year}'),
              _buildSpecTile(context, Icons.local_gas_station_outlined, 'Yakıt Türü', vehicle.fuelType),
              _buildSpecTile(context, Icons.tune, 'Vites Türü', vehicle.transmission),
            ],
          ),
          const SizedBox(height: 16),
          // 2. Satır: Yolcu Kapasitesi, Bagaj Hacmi, Gerekli Ehliyet
          Row(
            children: [
              _buildSpecTile(context, Icons.people_outline, 'Kapasite', '${vehicle.passengerCapacity} Kişi'),
              _buildSpecTile(context, Icons.luggage_outlined, 'Bagaj', '${vehicle.luggageCapacity} Valiz'),
              _buildSpecTile(context, Icons.badge_outlined, 'Gerekli Ehliyet', '${vehicle.requiredLicenseClass} Sınıfı'),
            ],
          ),
        ],
      ),
    );
  }

  /// Tek bir teknik özellik kutucuğunu (ikon, etiket, değer) inşa eden yardımcı metot
  Widget _buildSpecTile(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFFC0B09A)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
