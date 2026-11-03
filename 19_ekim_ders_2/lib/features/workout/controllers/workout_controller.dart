// -bu kod bloğunda kullanıcının antrenman kayıtlarını, toplam süre/kalori hesaplamalarını, geri alma (undo) işlemini ve egzersiz rozetlerini yöneten WorkoutController sınıfı anlatılıyor.-
// fold<T>(başlangıçDeğeri, (birikim, eleman) => ...): Bir listedeki tüm elemanları tek tek gezerek sayısal değerlerini tek bir toplamda (sum) birleştiren güçlü koleksiyon metodu.
// ValueNotifier<List<WorkoutEntryModel>>: Antrenman listesi her değiştiğinde Egzersiz ekranını otomatik güncelleyen reaktif yapı.

import 'package:flutter/foundation.dart'; // ValueNotifier sınıfı için temel paket.
import '../../badges/controllers/badge_controller.dart'; // Egzersiz rozetlerini kontrol etmek için BadgeController.
import '../models/workout_entry_model.dart'; // Antrenman veri modeli.

/// Fitness & Egzersiz Durum Kontrolcüsü (ValueNotifier + Geri Alma / Undo Desteği)
class WorkoutController {
  final BadgeController? badgeController; // Rozet sistemi ile bağlantı (opsiyonel).
  final int dailyCalorieGoal; // Günlük hedeflenen kalori yakımı (kcal).
  final int dailyMinutesGoal; // Günlük hedeflenen aktif antrenman süresi (dakika).

  final ValueNotifier<List<WorkoutEntryModel>> workouts =
      ValueNotifier<List<WorkoutEntryModel>>([]); // Yapılan antrenmanların tutulduğu reaktif liste.

  WorkoutController({
    this.badgeController,
    this.dailyCalorieGoal = 600, // Varsayılan günlük kalori hedefi: 600 kcal.
    this.dailyMinutesGoal = 45, // Varsayılan günlük süre hedefi: 45 dakika.
  });

  int get totalMinutes => // Listedeki tüm antrenmanların sürelerini (durationMinutes) toplar.
      workouts.value.fold<int>(0, (sum, w) => sum + w.durationMinutes); // 0'dan başlar, her antrenmanın (w) süresini sum üzerine ekler.

  int get totalCalories => // Listedeki tüm antrenmanların yakılan kalorilerini (caloriesBurned) toplar.
      workouts.value.fold<int>(0, (sum, w) => sum + w.caloriesBurned);

  bool get canUndo => workouts.value.isNotEmpty; // En az 1 antrenman varsa geri alma (undo) yapılabilir.

  double get calorieProgress => // Kalori hedefine ulaşma oranı (0.0 - 1.0 arası).
      dailyCalorieGoal > 0 ? (totalCalories / dailyCalorieGoal).clamp(0.0, 1.0) : 0.0;

  double get minutesProgress => // Süre hedefine ulaşma oranı (0.0 - 1.0 arası).
      dailyMinutesGoal > 0 ? (totalMinutes / dailyMinutesGoal).clamp(0.0, 1.0) : 0.0;

  /// Antrenman ekleme
  void addWorkout({ // Yeni bir antrenman kaydı ekler.
    required String title, // Antrenman adı (Örn: 'Ağırlık Antrenmanı').
    required int durationMinutes, // Süresi (dk).
    required int caloriesBurned, // Yakılan kalori (kcal).
    required String category, // Kategori ('strength', 'cardio', 'hiit', 'yoga').
  }) {
    if (durationMinutes <= 0 || caloriesBurned < 0) return; // Geçersiz süre veya negatif kalori girilirse işlemi iptal et.

    final newWorkout = WorkoutEntryModel( // Yeni antrenman modeli oluşturulur.
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      timestamp: DateTime.now(),
      category: category,
    );

    workouts.value = [...workouts.value, newWorkout]; // Spread operatörü ile yeni antrenmanı listeye ekleyip yeni referans atar -> UI güncellenir.

    // Rozet tetiklemesi
    badgeController?.checkWorkoutBadges( // Egzersiz rozetlerinin ('İlk Ter' ve 'Kalori Avcısı') şartlarını kontrol eder.
      totalMinutes,
      totalCalories,
      dailyCalorieGoal,
    );
  }

  /// Son antrenmanı geri alma (Undo)
  bool undoLastWorkout() { // Son eklenen antrenmanı listeden çıkarır.
    if (workouts.value.isEmpty) return false; // Liste boşsa false döner.

    final updated = List<WorkoutEntryModel>.from(workouts.value); // Mevcut listenin kopyasını oluşturur.
    updated.removeLast(); // Son antrenmanı siler.
    workouts.value = updated; // Yeni listeyi atar -> totalMinutes ve totalCalories getter'ları otomatik olarak yeni listeye göre tekrar hesaplanır!

    return true;
  }

  /// Sıfırlama
  void resetWorkouts() { // Tüm antrenman geçmişini temizler.
    workouts.value = [];
  }

  void dispose() { // Bellek temizliği.
    workouts.dispose();
  }
}

// ÇALIŞMA MANTIĞI:
// Kullanıcı hızlı egzersizlerden birine tıklar -> addWorkout() çağrılır -> workouts.value listesine yeni WorkoutEntryModel eklenir
// -> workouts'u dinleyen WorkoutView yeniden çizilir -> totalMinutes ve totalCalories fold() ile anlık hesaplanır
// -> badgeController?.checkWorkoutBadges() çalışarak rozet kazanılıp kazanılmadığını denetler.

// AYRI DEĞİŞKENLER TUTMAK (ValueNotifier<int> totalMin, totalCal) : Her ekleme ve silmede 3 ayrı değişkeni manuel güncellemek gerekir, unutulursa veri tutarsızlığı olur
//  VS
// HESAPLANMIŞ GETTER KULLANMAK (int get totalMinutes => workouts.fold(...)) : Tek gerçek veri kaynağı (Single Source of Truth) workouts listesidir; liste değişince toplamlar her zaman hatasız hesaplanır
