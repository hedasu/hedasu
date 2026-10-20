class DeliveryRecord {
  const DeliveryRecord({
    required this.pickupConfirmed,
    required this.dropoffConfirmed,
    this.pickupNotes = '',
    this.dropoffNotes = '',
    this.pickupPhotosCount = 0,
    this.dropoffPhotosCount = 0,
  });

  final bool pickupConfirmed;
  final bool dropoffConfirmed;
  final String pickupNotes;
  final String dropoffNotes;
  final int pickupPhotosCount;
  final int dropoffPhotosCount;

  DeliveryRecord copyWith({
    bool? pickupConfirmed,
    bool? dropoffConfirmed,
    String? pickupNotes,
    String? dropoffNotes,
    int? pickupPhotosCount,
    int? dropoffPhotosCount,
  }) {
    return DeliveryRecord(
      pickupConfirmed: pickupConfirmed ?? this.pickupConfirmed,
      dropoffConfirmed: dropoffConfirmed ?? this.dropoffConfirmed,
      pickupNotes: pickupNotes ?? this.pickupNotes,
      dropoffNotes: dropoffNotes ?? this.dropoffNotes,
      pickupPhotosCount: pickupPhotosCount ?? this.pickupPhotosCount,
      dropoffPhotosCount: dropoffPhotosCount ?? this.dropoffPhotosCount,
    );
  }
}
