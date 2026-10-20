import '../../vehicles/models/vehicle_model.dart';
import '../../delivery/models/delivery_record.dart';

/// Rezervasyon Durumları Sabiti (ReservationStatus)
enum ReservationStatus {
  active('Aktif'),
  upcoming('Gelecek'),
  completed('Tamamlandı'),
  cancelled('İptal Edildi');

  const ReservationStatus(this.displayName);
  /// Arayüzde gösterilecek Türkçe durum metni
  final String displayName;
}

/// otoVia Rezervasyon ve Kiralama Veri Modeli (ReservationModel)
///
/// Kullanıcının oluşturduğu araç kiralamasının başlangıç/bitiş tarihlerini,
/// kiralama türünü, ücret detaylarını (baz fiyat, sigorta, depozito, kupon indirimi, nihai tutar),
/// teslim alış/bırakış lokasyonlarını ve teslimat tutanağını (DeliveryRecord) modeller.
class ReservationModel {
  const ReservationModel({
    required this.id,
    required this.vehicle,
    required this.rentalType,
    required this.startDate,
    required this.endDate,
    required this.totalDurationUnits,
    required this.unitPrice,
    required this.basePrice,
    required this.extraInsurance,
    required this.deposit,
    required this.discountAmount,
    required this.finalPrice,
    required this.status,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.appliedCouponCode,
    this.contractAccepted = true,
    this.deliveryRecord = const DeliveryRecord(
      pickupConfirmed: true,
      dropoffConfirmed: false,
    ),
  });

  /// Benzersiz rezervasyon takip numarası
  final String id;

  /// Kiralanan araç modeli
  final VehicleModel vehicle;

  /// Kiralama türü ('hourly' = Saatlik, 'daily' = Günlük)
  final String rentalType;

  /// Kiralama başlangıç tarihi ve saati
  final DateTime startDate;

  /// Kiralama bitiş / teslim tarihi ve saati
  final DateTime endDate;

  /// Toplam süre birimi adedi (kaç saat veya kaç gün)
  final int totalDurationUnits;

  /// Birim kiralama ücreti (saatlik veya günlük birim fiyat)
  final double unitPrice;

  /// İndirimler ve ekler öncesi baz kiralama tutarı
  final double basePrice;

  /// Ek güvence paketi ve kasko bedeli
  final double extraInsurance;

  /// Provizyon / depozito tutarı
  final double deposit;

  /// Kupon veya kampanya ile düşülen indirim tutarı
  final double discountAmount;

  /// Ödenen toplam nihai tutar
  final double finalPrice;

  /// Rezervasyonun güncel durumu (Aktif, Gelecek, Tamamlandı, İptal)
  final ReservationStatus status;

  /// Aracın teslim alınacağı nokta / şube
  final String pickupLocation;

  /// Aracın iade edileceği nokta / şube
  final String dropoffLocation;

  /// Varsa uygulanan promosyon kupon kodu
  final String? appliedCouponCode;

  /// Kiralama sözleşmesinin onay durumu
  final bool contractAccepted;

  /// Araç teslim alma ve iade tutanağı kaydı
  final DeliveryRecord deliveryRecord;

  // Durum sorgulama yardımcı getter'ları
  bool get isActive => status == ReservationStatus.active;
  bool get isUpcoming => status == ReservationStatus.upcoming;
  bool get isCompleted => status == ReservationStatus.completed;
  bool get isCancelled => status == ReservationStatus.cancelled;

  /// Süre uzatma, durum güncelleme veya teslim tutanağı ekleme için kopya oluşturucu
  ReservationModel copyWith({
    ReservationStatus? status,
    DateTime? endDate,
    int? totalDurationUnits,
    double? finalPrice,
    DeliveryRecord? deliveryRecord,
  }) {
    return ReservationModel(
      id: id,
      vehicle: vehicle,
      rentalType: rentalType,
      startDate: startDate,
      endDate: endDate ?? this.endDate,
      totalDurationUnits: totalDurationUnits ?? this.totalDurationUnits,
      unitPrice: unitPrice,
      basePrice: basePrice,
      extraInsurance: extraInsurance,
      deposit: deposit,
      discountAmount: discountAmount,
      finalPrice: finalPrice ?? this.finalPrice,
      status: status ?? this.status,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      appliedCouponCode: appliedCouponCode,
      contractAccepted: contractAccepted,
      deliveryRecord: deliveryRecord ?? this.deliveryRecord,
    );
  }
}
