import 'package:flutter/material.dart';
import '../controller/comparison_controller.dart';
import '../../../core/widgets/empty_state_widget.dart';

class ComparisonView extends StatelessWidget {
  const ComparisonView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: comparisonController,
      builder: (context, _) {
        final vehicles = comparisonController.selectedVehicles;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Araç Karşılaştırma'),
            actions: [
              if (vehicles.isNotEmpty)
                TextButton(
                  onPressed: () => comparisonController.clear(),
                  child: const Text('Temizle'),
                ),
            ],
          ),
          body: vehicles.length < 2
              ? const EmptyStateWidget(
                  icon: Icons.compare_arrows_rounded,
                  title: 'En Az 2 Araç Seçin',
                  message: 'Araç kartlarındaki karşılaştırma simgesine dokunarak en az 2 aracı yan yana kıyaslayabilirsiniz.',
                )
              : _buildComparisonTable(context, vehicles),
        );
      },
    );
  }

  Widget _buildComparisonTable(BuildContext context, List<dynamic> vehicles) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DataTable(
          columnSpacing: 24,
          columns: [
            const DataColumn(label: Text('Özellik', style: TextStyle(fontWeight: FontWeight.bold))),
            ...vehicles.map((v) => DataColumn(
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(v.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${v.year} • ${v.category.displayName}', style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                )),
          ],
          rows: [
            _buildRow('Günlük Fiyat', vehicles.map((v) => '₺${v.dailyPrice.toStringAsFixed(0)} / gün').toList()),
            _buildRow('Saatlik Fiyat', vehicles.map((v) => '₺${v.hourlyPrice.toStringAsFixed(0)} / saat').toList()),
            _buildRow('Puan & Yorum', vehicles.map((v) => '★ ${v.rating} (${v.reviewCount} yorum)').toList()),
            _buildRow('Yakıt Türü', vehicles.map((v) => v.fuelType as String).toList()),
            _buildRow('Vites Türü', vehicles.map((v) => v.transmission as String).toList()),
            _buildRow('Kapasite', vehicles.map((v) => '${v.passengerCapacity} Kişi').toList()),
            _buildRow('Bagaj Hacmi', vehicles.map((v) => '${v.luggageCapacity} Valiz').toList()),
            _buildRow('Gerekli Ehliyet', vehicles.map((v) => '${v.requiredLicenseClass} Sınıfı').toList()),
          ],
        ),
      ),
    );
  }

  DataRow _buildRow(String label, List<String> values) {
    return DataRow(
      cells: [
        DataCell(Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        ...values.map((val) => DataCell(Text(val, style: const TextStyle(fontSize: 13)))),
      ],
    );
  }
}
