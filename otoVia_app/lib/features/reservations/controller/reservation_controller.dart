import 'package:flutter/material.dart';
import '../models/reservation_model.dart';
import '../../vehicles/models/vehicle_model.dart';
import '../../vehicles/controller/vehicle_controller.dart';
import '../../delivery/models/delivery_record.dart';
import '../../coupons/controller/coupon_controller.dart';

final ReservationController reservationController = ReservationController();

class ReservationController extends ChangeNotifier {
  ReservationController() {
    _initReservations();
  }

  final List<ReservationModel> _reservations = [];

  List<ReservationModel> get allReservations => List.unmodifiable(_reservations);

  ReservationModel? get activeRental {
    try {
      return _reservations.firstWhere((r) => r.status == ReservationStatus.active);
    } catch (_) {
      return null;
    }
  }

  List<ReservationModel> get upcomingReservations =>
      _reservations.where((r) => r.status == ReservationStatus.upcoming).toList();

  List<ReservationModel> get activeReservations =>
      _reservations.where((r) => r.status == ReservationStatus.active).toList();

  List<ReservationModel> get completedReservations =>
      _reservations.where((r) => r.status == ReservationStatus.completed).toList();

  List<ReservationModel> get cancelledReservations =>
      _reservations.where((r) => r.status == ReservationStatus.cancelled).toList();

  void _initReservations() {
    final v1 = vehicleController.getVehicleById('veh_01'); // Porsche Taycan
    final v2 = vehicleController.getVehicleById('veh_02'); // Mercedes S 500
    final v3 = vehicleController.getVehicleById('veh_03'); // Range Rover

    if (v1 != null) {
      _reservations.add(
        ReservationModel(
          id: 'res_active_01',
          vehicle: v1,
          rentalType: 'daily',
          startDate: DateTime.now().subtract(const Duration(hours: 18)),
          endDate: DateTime.now().add(const Duration(hours: 30)),
          totalDurationUnits: 2,
          unitPrice: v1.dailyPrice,
          basePrice: v1.dailyPrice * 2,
          extraInsurance: 400,
          deposit: 1500,
          discountAmount: 0,
          finalPrice: (v1.dailyPrice * 2) + 400,
          status: ReservationStatus.active,
          pickupLocation: 'İstanbul Havalimanı (IST) VIP Lounge',
          dropoffLocation: 'İstanbul Havalimanı (IST) VIP Lounge',
          deliveryRecord: const DeliveryRecord(
            pickupConfirmed: true,
            dropoffConfirmed: false,
            pickupNotes: 'Araç kusursuz teslim alındı, batarya %98.',
            pickupPhotosCount: 4,
          ),
        ),
      );
    }

    if (v2 != null) {
      _reservations.add(
        ReservationModel(
          id: 'res_upcoming_02',
          vehicle: v2,
          rentalType: 'daily',
          startDate: DateTime.now().add(const Duration(days: 4)),
          endDate: DateTime.now().add(const Duration(days: 7)),
          totalDurationUnits: 3,
          unitPrice: v2.dailyPrice,
          basePrice: v2.dailyPrice * 3,
          extraInsurance: 600,
          deposit: 2000,
          discountAmount: 500,
          finalPrice: (v2.dailyPrice * 3) + 600 - 500,
          status: ReservationStatus.upcoming,
          pickupLocation: 'Sabiha Gökçen Havalimanı (SAW)',
          dropoffLocation: 'Sabiha Gökçen Havalimanı (SAW)',
          appliedCouponCode: 'OTOVIA20',
        ),
      );
    }

    if (v3 != null) {
      _reservations.add(
        ReservationModel(
          id: 'res_completed_03',
          vehicle: v3,
          rentalType: 'daily',
          startDate: DateTime.now().subtract(const Duration(days: 12)),
          endDate: DateTime.now().subtract(const Duration(days: 9)),
          totalDurationUnits: 3,
          unitPrice: v3.dailyPrice,
          basePrice: v3.dailyPrice * 3,
          extraInsurance: 600,
          deposit: 2500,
          discountAmount: 0,
          finalPrice: (v3.dailyPrice * 3) + 600,
          status: ReservationStatus.completed,
          pickupLocation: 'Bodrum Milas Havalimanı (BJV)',
          dropoffLocation: 'Bodrum Milas Havalimanı (BJV)',
          deliveryRecord: const DeliveryRecord(
            pickupConfirmed: true,
            dropoffConfirmed: true,
            pickupNotes: 'Hasarsız teslim alındı.',
            dropoffNotes: 'Yakıt dolu teslim edildi.',
            pickupPhotosCount: 4,
            dropoffPhotosCount: 4,
          ),
        ),
      );
    }
  }

  Future<ReservationModel> createReservation({
    required VehicleModel vehicle,
    required String rentalType,
    required DateTime startDate,
    required DateTime endDate,
    required int totalUnits,
    required double basePrice,
    required double extraInsurance,
    required double deposit,
    required double discountAmount,
    required double finalPrice,
    required String pickupLocation,
    required String dropoffLocation,
    String? appliedCouponCode,
  }) async {
    final newRes = ReservationModel(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      vehicle: vehicle,
      rentalType: rentalType,
      startDate: startDate,
      endDate: endDate,
      totalDurationUnits: totalUnits,
      unitPrice: rentalType == 'hourly' ? vehicle.hourlyPrice : vehicle.dailyPrice,
      basePrice: basePrice,
      extraInsurance: extraInsurance,
      deposit: deposit,
      discountAmount: discountAmount,
      finalPrice: finalPrice,
      status: ReservationStatus.upcoming,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      appliedCouponCode: appliedCouponCode,
      contractAccepted: true,
    );

    if (appliedCouponCode != null && appliedCouponCode.isNotEmpty) {
      couponController.useCoupon(appliedCouponCode);
    }

    _reservations.insert(0, newRes);
    notifyListeners();
    return newRes;
  }

  void cancelReservation(String id) {
    final index = _reservations.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reservations[index] = _reservations[index].copyWith(
        status: ReservationStatus.cancelled,
      );
      notifyListeners();
    }
  }

  void extendReservation(String id, int extraUnits) {
    final index = _reservations.indexWhere((r) => r.id == id);
    if (index != -1) {
      final current = _reservations[index];
      final Duration extraDuration = current.rentalType == 'hourly'
          ? Duration(hours: extraUnits)
          : Duration(days: extraUnits);
      final newEndDate = current.endDate.add(extraDuration);
      final addedCost = current.unitPrice * extraUnits;

      _reservations[index] = current.copyWith(
        endDate: newEndDate,
        totalDurationUnits: current.totalDurationUnits + extraUnits,
        finalPrice: current.finalPrice + addedCost,
      );
      notifyListeners();
    }
  }

  void completeDeliveryDropoff(String id, String notes, int photosCount) {
    final index = _reservations.indexWhere((r) => r.id == id);
    if (index != -1) {
      final current = _reservations[index];
      final updatedDelivery = current.deliveryRecord.copyWith(
        dropoffConfirmed: true,
        dropoffNotes: notes,
        dropoffPhotosCount: photosCount,
      );
      _reservations[index] = current.copyWith(
        status: ReservationStatus.completed,
        deliveryRecord: updatedDelivery,
      );
      couponController.incrementCompletedRentals();
      notifyListeners();
    }
  }
}
