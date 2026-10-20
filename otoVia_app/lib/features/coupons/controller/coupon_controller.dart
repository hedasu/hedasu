import 'package:flutter/material.dart';
import '../models/coupon_model.dart';

/// Global indirim kuponları kontrolcüsü (Singleton)
final CouponController couponController = CouponController();

/// İndirim Kuponları ve Sadakat Ödül Sistemi Kontrolcüsü
///
/// Kullanıcının kuponlarını listeler, rezervasyonda kupon kullanımını uygular
/// ve her 3 tamamlanan kiralamada otomatik %20 sadakat indirim kuponu tanımlar.
class CouponController extends ChangeNotifier {
  CouponController() {
    _initCoupons();
  }

  /// Tüm kuponların listesi
  final List<CouponModel> _coupons = [];

  /// Kullanıcının bugüne kadar tamamladığı toplam kiralama adedi
  int _completedRentalsCount = 1;

  // Dışa açık filtreli kupon listeleri
  List<CouponModel> get allCoupons => List.unmodifiable(_coupons);
  List<CouponModel> get validCoupons => _coupons.where((c) => c.isValid).toList();
  List<CouponModel> get usedCoupons => _coupons.where((c) => c.isUsed).toList();
  List<CouponModel> get expiredCoupons => _coupons.where((c) => c.isExpired).toList();

  /// Tamamlanan kiralama sayısı
  int get completedRentalsCount => _completedRentalsCount;

  /// Bir sonraki %20 indirim kuponunu kazanmak için gereken kiralama sayısı
  int get rentalsNeededForNextCoupon => 3 - (_completedRentalsCount % 3);

  /// Sadakat ödülü ilerleme oranı (0.0 ile 1.0 arası)
  double get couponProgress => (_completedRentalsCount % 3) / 3.0;

  /// Başlangıçta kullanıcıya tanımlanan örnek kuponları yükler
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

  /// Bir kiralama teslimatı başarıyla bittiğinde sayacı artırır ve 3'ün katlarında yeni kupon üretir
  void incrementCompletedRentals() {
    _completedRentalsCount++;
    if (_completedRentalsCount % 3 == 0) {
      // Her 3 başarılı kiralamada yeni %20 indirim kuponu tanımlanır
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

  /// Kupon kodunu kullanıldı olarak işaretler
  bool useCoupon(String code) {
    final index = _coupons.indexWhere((c) => c.code == code && c.isValid);
    if (index != -1) {
      _coupons[index] = _coupons[index].copyWith(isUsed: true);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Kod metnine göre geçerli kuponu bulur
  CouponModel? getCouponByCode(String code) {
    try {
      return _coupons.firstWhere((c) => c.code.toUpperCase() == code.toUpperCase() && c.isValid);
    } catch (_) {
      return null;
    }
  }
}
