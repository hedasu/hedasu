class LuggageAnalysisModel {
  final double totalWeightKg;
  final double totalVolumeLiters;
  final double cabinMaxWeightKg;
  final double cabinMaxVolumeLiters;
  final bool isCabinExceeded;
  final String statusSummary;

  const LuggageAnalysisModel({
    required this.totalWeightKg,
    required this.totalVolumeLiters,
    required this.cabinMaxWeightKg,
    required this.cabinMaxVolumeLiters,
    required this.isCabinExceeded,
    required this.statusSummary,
  });

  double get weightRatio => (totalWeightKg / cabinMaxWeightKg).clamp(0.0, 1.5);
  double get volumeRatio => (totalVolumeLiters / cabinMaxVolumeLiters).clamp(0.0, 1.5);
}
