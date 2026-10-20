import 'package:flutter/material.dart';
import '../controller/vehicle_controller.dart';
import '../../auth/controller/auth_controller.dart';

class VehicleFilterSheet extends StatelessWidget {
  const VehicleFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildSortingSection(context),
            const SizedBox(height: 20),
            _buildLicenseEligibilityToggle(context),
            const SizedBox(height: 20),
            _buildFuelSection(context),
            const SizedBox(height: 20),
            _buildTransmissionSection(context),
            const SizedBox(height: 28),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Filtrele ve Sırala',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildSortingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sıralama Ölçütü',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: VehicleSortOption.values.map((opt) {
            final isSelected = vehicleController.sortOption == opt;
            return ChoiceChip(
              label: Text(opt.displayName),
              selected: isSelected,
              onSelected: (_) => vehicleController.setSortOption(opt),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLicenseEligibilityToggle(BuildContext context) {
    final userLicense = authController.currentUser?.driverLicenseClass ?? 'B';
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text(
        'Ehliyetime Uygun Araçlar',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        'Mevcut ehliyetiniz: $userLicense Sınıfı. Sadece kiralayabileceğiniz araçlar listelenir.',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      value: vehicleController.onlyEligibleForLicense,
      onChanged: (_) => vehicleController.toggleLicenseEligibility(),
    );
  }

  Widget _buildFuelSection(BuildContext context) {
    const fuels = ['Benzin', 'Dizel', 'Elektrik', 'Hibrit'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Yakıt Türü',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: fuels.map((f) {
            final isSelected = vehicleController.selectedFuelType == f;
            return FilterChip(
              label: Text(f),
              selected: isSelected,
              onSelected: (selected) {
                vehicleController.setFilters(
                  fuel: selected ? f : null,
                  transmission: vehicleController.selectedTransmission,
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTransmissionSection(BuildContext context) {
    const transmissions = ['Otomatik', 'Manuel'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vites Türü',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: transmissions.map((t) {
            final isSelected = vehicleController.selectedTransmission == t;
            return FilterChip(
              label: Text(t),
              selected: isSelected,
              onSelected: (selected) {
                vehicleController.setFilters(
                  fuel: vehicleController.selectedFuelType,
                  transmission: selected ? t : null,
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              vehicleController.resetFilters();
              Navigator.pop(context);
            },
            child: const Text('Temizle'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sonuçları Gör'),
          ),
        ),
      ],
    );
  }
}
