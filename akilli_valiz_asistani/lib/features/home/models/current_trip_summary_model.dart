class CurrentTripSummaryModel {
  final String tripId;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String tripType;
  final int totalItems;
  final int packedItems;
  final double totalWeightKg;
  final double totalVolumeLiters;

  const CurrentTripSummaryModel({
    required this.tripId,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.tripType,
    required this.totalItems,
    required this.packedItems,
    required this.totalWeightKg,
    required this.totalVolumeLiters,
  });

  double get progress => totalItems == 0 ? 0.0 : packedItems / totalItems;
  int get remainingItems => totalItems - packedItems;
}
