import 'package:flutter/material.dart';
import '../../reservations/controller/reservation_controller.dart';
import '../../coupons/controller/coupon_controller.dart';

/// Global profil istatistikleri kontrolcüsü (Singleton)
final ProfileController profileController = ProfileController();

/// Kullanıcı Profil ve Kiralama İstatistikleri Kontrolcüsü
///
/// Kullanıcının tamamlanan kiralama sayısı, toplam kiralama günü/saati
/// ve kazanılan/harcanan kupon istatistiklerini hesaplayarak profil ekranına sunar.
class ProfileController extends ChangeNotifier {
  /// Bugüne kadar tamamlanmış başarılı kiralama adedi
  int get totalCompletedRentals => reservationController.completedReservations.length;

  /// Tamamlanan kiralamaların toplam gün / saat süresi
  int get totalRentalDays {
    return reservationController.completedReservations
        .fold(0, (sum, res) => sum + res.totalDurationUnits);
  }

  /// Kullanılmış indirim kuponu sayısı
  int get usedCouponsCount => couponController.usedCoupons.length;

  /// Bugüne kadar hak edilen toplam kupon adedi
  int get earnedCouponsCount => couponController.allCoupons.length;
}
