import 'package:flutter/foundation.dart';
import '../models/water_log.dart';

/// Su takip modülünün iş mantığını ve durumunu yöneten denetleyici (Controller).
/// Kırmızı Çizgiler gereği sayfa düzeyinde setState yerine ChangeNotifier kullanılır.
class WaterTrackerController extends ChangeNotifier {
  WaterTrackerController({int initialGoalMl = 2500}) : _dailyGoalMl = initialGoalMl;

  int _dailyGoalMl;
  final List<WaterLog> _logs = [];

  int get dailyGoalMl => _dailyGoalMl;
  List<WaterLog> get logs => List.unmodifiable(_logs);

  /// Günlük toplam tüketilen su miktarı (ml)
  int get currentIntakeMl {
    return _logs.fold(0, (total, log) => total + log.amountMl);
  }

  /// Kalan su miktarı (ml)
  int get remainingMl {
    final remaining = _dailyGoalMl - currentIntakeMl;
    return remaining < 0 ? 0 : remaining;
  }

  /// Tamamlanma yüzdesi (0.0 ile 1.0 arasında oran)
  double get progressRatio {
    if (_dailyGoalMl <= 0) return 0.0;
    final ratio = currentIntakeMl / _dailyGoalMl;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  /// Yüzde olarak tam sayı (ör. %75)
  int get progressPercentage {
    return (progressRatio * 100).round();
  }

  /// Hedefe ulaşıldı mı?
  bool get isGoalAchieved => currentIntakeMl >= _dailyGoalMl && _dailyGoalMl > 0;

  /// Hedef tamamlanınca verilen rozet bilgisi
  String get badgeTitle => 'Hidrasyon Şampiyonu';

  /// Rozet kazanıldı mı?
  bool get hasEarnedBadge => isGoalAchieved;

  /// Azaltma yapılabilir mi?
  bool get canDecrease => currentIntakeMl > 0;

  /// Yeni su tüketimi ekle
  void addWater(int amountMl, {String label = 'Hızlı Ekleme'}) {
    if (amountMl <= 0) return;
    final log = WaterLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
      label: label,
    );
    _logs.insert(0, log);
    notifyListeners();
  }

  /// Yanlışlıkla ekleme durumu için su miktarını azaltma
  void decreaseWater(int amountMl, {String label = 'Yanlış Ekleme Düzeltmesi'}) {
    if (amountMl <= 0 || currentIntakeMl <= 0) return;
    final effectiveAmount = amountMl > currentIntakeMl ? currentIntakeMl : amountMl;
    final log = WaterLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amountMl: -effectiveAmount,
      timestamp: DateTime.now(),
      label: label,
    );
    _logs.insert(0, log);
    notifyListeners();
  }

  /// En son yapılan kaydı geri al
  void undoLast() {
    if (_logs.isNotEmpty) {
      _logs.removeAt(0);
      notifyListeners();
    }
  }

  /// Son kaydı sil
  void removeLog(String logId) {
    _logs.removeWhere((item) => item.id == logId);
    notifyListeners();
  }

  /// Günlük sayacı sıfırla
  void reset() {
    _logs.clear();
    notifyListeners();
  }

  /// Günlük hedefi güncelle
  void updateGoal(int newGoalMl) {
    if (newGoalMl > 0) {
      _dailyGoalMl = newGoalMl;
      notifyListeners();
    }
  }
}
