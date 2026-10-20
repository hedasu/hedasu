import 'package:flutter/material.dart';
import '../models/coupon_model.dart';

final CouponController couponController = CouponController();

class CouponController extends ChangeNotifier {
  CouponController() {
    _initCoupons();
  }

  final List<CouponModel> _coupons = [];
  int _completedRentalsCount = 1; // Başlangıçta 1 tamamlanmış kiralama

  List<CouponModel> get allCoupons => List.unmodifiable(_coupons);
  List<CouponModel> get validCoupons => _coupons.where((c) => c.isValid).toList();
  List<CouponModel> get usedCoupons => _coupons.where((c) => c.isUsed).toList();
  List<CouponModel> get expiredCoupons => _coupons.where((c) => c.isExpired).toList();

  int get completedRentalsCount => _completedRentalsCount;
  int get rentalsNeededForNextCoupon => 3 - (_completedRentalsCount % 3);
  double get couponProgress => (_completedRentalsCount % 3) / 3.0;

  void _initCoupons() {
    _coupons.addAll([
      CouponModel(
        id: 'cpn_01',
        code: 'OTOVIA20',
        title: 'İlk Kiralama Hoş Geldin İndirimi',
        discountPercent: 20,
        description: 'Tüm araç kategorilerinde geçerli %20 özel indirim.',
        expiryDate: DateTime.now().add(const Duration(days: 60)),
      ),
      CouponModel(
        id: 'cpn_02',
        code: 'SADIKLUKSUZ',
        title: '3 Kiralama Sadakat Ödülü',
        discountPercent: 20,
        description: '3 tamamlanmış kiralama sonrasında hak edilen ödül.',
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      ),
      CouponModel(
        id: 'cpn_03',
        code: 'YAZSONU10',
        title: 'Geçmiş Sezon İndirimi',
        discountPercent: 10,
        description: 'Geçen ay kullanılmış sezon kampanyası.',
        expiryDate: DateTime.now().subtract(const Duration(days: 10)),
        isUsed: true,
      ),
    ]);
  }

  void incrementCompletedRentals() {
    _completedRentalsCount++;
    if (_completedRentalsCount % 3 == 0) {
      // 3 kiralamada bir %20 kupon kazanılır!
      final newCoupon = CouponModel(
        id: 'cpn_${DateTime.now().millisecondsSinceEpoch}',
        code: 'PREMIUM${_completedRentalsCount * 10}',
        title: '$_completedRentalsCount. Kiralama Sadakat Kuponu',
        discountPercent: 20,
        description: 'Tebrikler! 3 başarılı kiralama tamamlayarak %20 indirim kazandınız.',
        expiryDate: DateTime.now().add(const Duration(days: 90)),
      );
      _coupons.insert(0, newCoupon);
    }
    notifyListeners();
  }

  bool useCoupon(String code) {
    final index = _coupons.indexWhere((c) => c.code == code && c.isValid);
    if (index != -1) {
      _coupons[index] = _coupons[index].copyWith(isUsed: true);
      notifyListeners();
      return true;
    }
    return false;
  }

  CouponModel? getCouponByCode(String code) {
    try {
      return _coupons.firstWhere((c) => c.code.toUpperCase() == code.toUpperCase() && c.isValid);
    } catch (_) {
      return null;
    }
  }
}
