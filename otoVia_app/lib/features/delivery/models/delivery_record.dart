/// Araç Teslim Tutanağı ve Kontrol Modeli (DeliveryRecord)
///
/// Araç teslim alınırken (pickup) ve teslim edilirken (dropoff) kaydedilen
/// fotoğraflı durum tespitlerini, hasar/yakıt/temizlik notlarını ve onay durumlarını saklar.
class DeliveryRecord {
  const DeliveryRecord({
    required this.pickupConfirmed,
    required this.dropoffConfirmed,
    this.pickupNotes = '',
    this.dropoffNotes = '',
    this.pickupPhotosCount = 0,
    this.dropoffPhotosCount = 0,
  });

  /// Aracın kullanıcı tarafından teslim alındığının onay durumu
  final bool pickupConfirmed;

  /// Aracın kullanıcı tarafından iade / teslim edildiğinin onay durumu
  final bool dropoffConfirmed;

  /// Teslim alırken eklenen notlar (ör. 'Sol kapıda kılcal çizik mevcut')
  final String pickupNotes;

  /// İade ederken eklenen notlar (ör. 'Araç temiz ve yakıt deposu dolu teslim edildi')
  final String dropoffNotes;

  /// Teslim alırken sisteme yüklenen fotoğraf sayısı (4 cephe kontrolü)
  final int pickupPhotosCount;

  /// İade ederken sisteme yüklenen fotoğraf sayısı
  final int dropoffPhotosCount;

  /// Modelin güncellenmiş yeni bir kopyasını üreten yardımcı metot
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
