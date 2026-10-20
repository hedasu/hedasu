import '../../vehicles/models/vehicle_model.dart';
import '../../delivery/models/delivery_record.dart';

enum ReservationStatus {
  active('Aktif'),
  upcoming('Gelecek'),
  completed('Tamamlandı'),
  cancelled('İptal Edildi');

  const ReservationStatus(this.displayName);
  final String displayName;
}

class ReservationModel {
  const ReservationModel({
    required this.id,
    required this.vehicle,
    required this.rentalType, // 'hourly' or 'daily'
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

  final String id;
  final VehicleModel vehicle;
  final String rentalType; // 'hourly' | 'daily'
  final DateTime startDate;
  final DateTime endDate;
  final int totalDurationUnits;
  final double unitPrice;
  final double basePrice;
  final double extraInsurance;
  final double deposit;
  final double discountAmount;
  final double finalPrice;
  final ReservationStatus status;
  final String pickupLocation;
  final String dropoffLocation;
  final String? appliedCouponCode;
  final bool contractAccepted;
  final DeliveryRecord deliveryRecord;

  bool get isActive => status == ReservationStatus.active;
  bool get isUpcoming => status == ReservationStatus.upcoming;
  bool get isCompleted => status == ReservationStatus.completed;
  bool get isCancelled => status == ReservationStatus.cancelled;

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
