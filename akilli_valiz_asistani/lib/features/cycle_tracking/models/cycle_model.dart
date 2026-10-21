class CyclePredictionModel {
  final DateTime nextEstimatedStart;
  final DateTime nextEstimatedEnd;
  final bool hasOverlapWithTrip;
  final String? overlappingTripName;
  final String advisoryMessage;

  const CyclePredictionModel({
    required this.nextEstimatedStart,
    required this.nextEstimatedEnd,
    required this.hasOverlapWithTrip,
    this.overlappingTripName,
    required this.advisoryMessage,
  });
}
