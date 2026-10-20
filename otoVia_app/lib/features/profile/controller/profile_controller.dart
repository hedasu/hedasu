import 'package:flutter/material.dart';
import '../../reservations/controller/reservation_controller.dart';
import '../../coupons/controller/coupon_controller.dart';

final ProfileController profileController = ProfileController();

class ProfileController extends ChangeNotifier {
  int get totalCompletedRentals => reservationController.completedReservations.length;

  int get totalRentalDays {
    return reservationController.completedReservations
        .fold(0, (sum, res) => sum + res.totalDurationUnits);
  }

  int get usedCouponsCount => couponController.usedCoupons.length;
  int get earnedCouponsCount => couponController.allCoupons.length;
}
