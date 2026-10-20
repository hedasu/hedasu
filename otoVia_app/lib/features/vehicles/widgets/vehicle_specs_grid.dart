import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';

class VehicleSpecsGrid extends StatelessWidget {
  const VehicleSpecsGrid({super.key, required this.vehicle});

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
          Row(
            children: [
              _buildSpecTile(context, Icons.speed, 'Model Yılı', '${vehicle.year}'),
              _buildSpecTile(context, Icons.local_gas_station_outlined, 'Yakıt Türü', vehicle.fuelType),
              _buildSpecTile(context, Icons.tune, 'Vites Türü', vehicle.transmission),
            ],
          ),
          const SizedBox(height: 16),
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
