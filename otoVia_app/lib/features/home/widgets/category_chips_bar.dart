import 'package:flutter/material.dart';
import '../../vehicles/controller/vehicle_controller.dart';
import '../../vehicles/models/vehicle_model.dart';

/// Araç Segmenti Kategori Çipleri Çubuğu (CategoryChipsBar)
///
/// Tümü, Motosiklet, Binek, SUV, Geniş Grup ve Nakliye & Ticari segmentleri arasında
/// yatay kaydırma ile anlık geçiş yapılmasını sağlar.
class CategoryChipsBar extends StatelessWidget {
  const CategoryChipsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vehicleController,
      builder: (context, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: VehicleCategory.values.map((cat) {
              final isSelected = vehicleController.selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(cat.displayName),
                  selected: isSelected,
                  onSelected: (_) => vehicleController.setCategory(cat),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
