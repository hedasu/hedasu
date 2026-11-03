// -bu dosyada Egzersiz (Workout) modülünün iş mantığı, yakılan toplam kalori/süre hesaplamaları ve ChangeNotifier tabanlı durum yönetimi anlatılıyor.-
// ChangeNotifier : Egzersiz eklendiğinde, geri alındığında veya silindiğinde `notifyListeners()` çağrısıyla hem `WorkoutView` ekranını hem de `BadgeController`'ı anında bilgilendiren sınıf.
// fold() : Listedeki tüm `Workout` nesnelerinin kalori (`caloriesBurned`) veya süre (`durationMinutes`) alanlarını tek bir toplam sayıda birleştiren metot.
// List.unmodifiable() : İçerideki `_workouts` listesini dışarıdan gelebilecek doğrudan müdahalelere (`workouts.clear()` vb.) karşı koruyan salt okunur liste sarmalayıcısı.

import 'package:flutter/foundation.dart'; // foundation.dart : ChangeNotifier sınıfı için içe aktarılır.
import '../models/workout.dart'; // Egzersiz veri modeli (Workout).

/// Egzersiz modülünün iş mantığını ve durumunu yöneten denetleyici (Controller).
/// Kırmızı çizgiler uyarınca saf Dart ve ChangeNotifier ile sayfa düzeyinde ağır setState önlenir.
class WorkoutController extends ChangeNotifier { // extends ChangeNotifier : Dinlenebilir durum yöneticisi.
  WorkoutController({this.dailyCalorieGoal = 500}); // Kurucu metot : Varsayılan günlük kalori yakım hedefi 500 kcal olarak atanır.

  final int dailyCalorieGoal; // final : Günlük hedeflenen kalori miktarı (500 kcal).
  final List<Workout> _workouts = []; // _workouts : Tamamlanan egzersiz kayıtlarını tutan private (gizli) liste.

  List<Workout> get workouts => List.unmodifiable(_workouts); // Dışarıya sadece okunabilir, değiştirilemez bir egzersiz listesi döndürür.

  /// Toplam yakılan kalori
  int get totalCaloriesBurned { // get totalCaloriesBurned : Listedeki tüm antrenmanların yakılan kalorilerini toplar.
    return _workouts.fold(0, (sum, item) => sum + item.caloriesBurned); // 0'dan başlar -> her antrenmanın `caloriesBurned` değerini `sum` üzerine ekler.
  }

  /// Toplam egzersiz süresi (dakika)
  int get totalDurationMinutes { // get totalDurationMinutes : Listedeki tüm antrenmanların sürelerini (dakika) toplar ("Demir Adam" rozeti bu değeri kontrol eder).
    return _workouts.fold(0, (sum, item) => sum + item.durationMinutes); // 0'dan başlar -> her antrenmanın `durationMinutes` değerini `sum` üzerine ekler.
  }

  /// Kalori hedef oranı (0.0 - 1.0)
  double get calorieProgressRatio { // get calorieProgressRatio : İlerleme çubuğu (LinearProgressIndicator) için 0.0 ile 1.0 arasında oran döndürür.
    if (dailyCalorieGoal <= 0) return 0.0; // Sıfıra bölünme hatasına karşı koruma.
    final ratio = totalCaloriesBurned / dailyCalorieGoal; // Yakılan kaloriyi hedefe böler.
    return ratio > 1.0 ? 1.0 : ratio; // Oran 1.0'ı (%100'ü) geçerse çubuğun taşmaması için 1.0'da sabitler.
  }

  /// Hedefe ulaşıldı mı?
  bool get isGoalAchieved => totalCaloriesBurned >= dailyCalorieGoal && dailyCalorieGoal > 0; // Toplam yakılan kalori günlük hedefe (500 kcal) ulaştıysa `true` döner.

  /// Geri alma yapılabilir mi?
  bool get canUndo => _workouts.isNotEmpty; // Listede en az 1 egzersiz varsa "Geri Al" butonunu aktif (`true`) yapar.

  /// Hedef tamamlanınca verilen rozet başlığı
  String get badgeTitle => 'Kalori Canavarı'; // Egzersiz hedefi rozetinin adı.

  /// Rozet kazanıldı mı?
  bool get hasEarnedBadge => isGoalAchieved; // Hedef tamamlandığında rozet kazanılır.

  /// Yeni egzersiz kaydı ekle
  void addWorkout({ // addWorkout() : İsimlendirilmiş zorunlu (required) parametrelerle yeni bir antrenman kaydı oluşturup listeye ekler.
    required String title, // Antrenman adı (Örn: 'Koşu', 'Ağırlık').
    required int durationMinutes, // Antrenman süresi (dk).
    required int caloriesBurned, // Yakılan kalori (kcal).
    required String category, // Antrenman kategorisi.
  }) {
    final workout = Workout( // Yeni bir değişmez (immutable) Workout nesnesi oluşturur:
      id: DateTime.now().millisecondsSinceEpoch.toString(), // O anki milisaniye zaman damgasından benzersiz ID üretir.
      title: title,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      category: category,
      timestamp: DateTime.now(), // Kayıt anının saati.
    );
    _workouts.insert(0, workout); // Yeni antrenmanı listenin EN BAŞINA (0. indekse) ekler.
    notifyListeners(); // ÖNEMLİ: Hem WorkoutView ekranını hem de bu controller'ı dinleyen BadgeController'ı uyarır.
  }

  /// En son eklenen egzersizi geri al
  void undoLast() { // undoLast() : Yanlışlıkla eklenen en son antrenmanı (0. indeksteki elemanı) listeden çıkarır.
    if (_workouts.isNotEmpty) { // Liste boş değilse:
      _workouts.removeAt(0); // En üstteki kaydı siler.
      notifyListeners(); // Arayüzü günceller.
    }
  }

  /// Egzersiz kaydını sil
  void removeWorkout(String id) { // removeWorkout() : Listeden belirli bir ID'ye sahip antrenmanı siler.
    _workouts.removeWhere((item) => item.id == id); // ID'si eşleşen kaydı bulup listeden kaldırır.
    notifyListeners(); // Arayüzü günceller.
  }

  /// Günlük egzersizleri sıfırla
  void reset() { // reset() : Tüm günlük antrenman geçmişini temizler.
    _workouts.clear(); // Listeyi tamamen boşaltır.
    notifyListeners(); // Arayüzü günceller.
  }
}

// ÇALIŞMA MANTIĞI: Kullanıcı 'Koşu (25 dk, 220 kcal)' butonuna basar -> addWorkout() çağrılır -> Yeni Workout nesnesi _workouts listesinin başına eklenir -> notifyListeners() çalışır -> WorkoutStatCard kalori/süre toplamlarını, BadgeController ise 'Demir Adam' ve 'Kalori Canavarı' rozetlerini anında günceller.

// FOLD İLE TOPLAMA (`_workouts.fold(...)`) : Ayrı bir `int _totalCalories` değişkeni tutup her ekleme/silmede manuel toplama-çıkarma yapmak yerine, her seferinde listeden hatasız hesaplar; senkronizasyon kayması asla yaşanmaz.
//  VS
// MANUEL SAYAÇ TUTMA (`_totalCalories += cal`) : Silme veya sıfırlama işlemlerinden birinde sayacı düşürmeyi unutursanız liste boş olsa bile ekranda kalori yazmaya devam eder (state bug).
