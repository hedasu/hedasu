import 'package:flutter/material.dart';
import '../../vehicles/controller/vehicle_controller.dart';
import '../../vehicles/models/vehicle_model.dart';

class PurposeSelector extends StatelessWidget {
  const PurposeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vehicleController,
      builder: (context, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: RentalPurpose.values.map((purpose) {
              final isSelected = vehicleController.selectedPurpose == purpose;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(purpose.displayName),
                  selected: isSelected,
                  onSelected: (_) => vehicleController.setPurpose(purpose),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
