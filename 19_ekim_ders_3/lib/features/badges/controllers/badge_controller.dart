// -bu kod bloğunda uygulamadaki başarı rozetlerinin listesini, kilit açma (unlock) şartlarını ve yeni rozet bildirimlerini yöneten BadgeController sınıfı anlatılıyor.-
// ValueNotifier<List<BadgeModel>>: Rozetlerin güncel durumunu (kilitli/açık) tutan ve bir rozet açıldığında arayüzü güncelleyen reaktif liste.
// |= (Bitwise OR Assignment / Veya Atama Operatörü): 'changed |= _unlockBadge(...)' ifadesi 'changed = changed || _unlockBadge(...)' demektir. Bir kez true olursa diğer kontroller false dönse bile 'changed' true kalır.
// indexWhere(): Bir liste içinde verilen şarta uyan ilk elemanın sıra numarasını (index) bulur. Bulamazsa -1 döndürür.

import 'package:flutter/foundation.dart'; // ValueNotifier sınıfını içeren temel Flutter paketi (material.dart kadar ağır değildir, sadece temel araçları içerir).
import '../models/badge_model.dart'; // BadgeModel veri sınıfını içe aktarır.

/// Rozet Durum Kontrolcüsü (ValueNotifier Tabanlı)
class BadgeController {
  final ValueNotifier<List<BadgeModel>> badges = ValueNotifier<List<BadgeModel>>([ // Uygulamadaki 5 temel rozetin başlangıç (kilitli) listesi.
    const BadgeModel(
      id: 'water_first', // Su eklendiğinde kontrol edilecek benzersiz kimlik.
      title: 'İlk Damla',
      description: 'Günün ilk su tüketimini kaydettin.',
      iconName: 'water_drop',
      category: 'water',
    ),
    const BadgeModel(
      id: 'water_goal',
      title: 'Hidrasyon Şampiyonu',
      description: 'Günlük su tüketim hedefine başarıyla ulaştın.',
      iconName: 'verified',
      category: 'water',
    ),
    const BadgeModel(
      id: 'workout_first',
      title: 'İlk Ter',
      description: 'İlk antrenmanını tamamlayıp sisteme işledin.',
      iconName: 'fitness_center',
      category: 'workout',
    ),
    const BadgeModel(
      id: 'workout_burn_500',
      title: 'Kalori Avcısı',
      description: 'Antrenmanlarda toplam 500 kcal yaktın.',
      iconName: 'local_fire_department',
      category: 'workout',
    ),
    const BadgeModel(
      id: 'double_champion',
      title: 'Çifte Şampiyon',
      description: 'Hem su hem de egzersiz hedeflerini tamamladın.',
      iconName: 'military_tech',
      category: 'special',
    ),
  ]);

  final ValueNotifier<String?> lastUnlockedBadgeNotification = ValueNotifier<String?>(null); // Son açılan rozetin adını tutar. main.dart burayı dinleyip ekranda SnackBar gösterir. (String?: null olabilir).

  int get unlockedCount => badges.value.where((b) => b.isUnlocked).length; // where(): Listedeki kilidi açılmış (isUnlocked == true) rozetleri filtreler, .length ile sayısını döner.
  int get totalCount => badges.value.length; // Toplam rozet sayısını döner (5).
  double get progress => totalCount > 0 ? unlockedCount / totalCount : 0.0; // Kazanılan rozetlerin toplama oranını (0.0 ile 1.0 arası) hesaplar. (Örn: 2/5 = 0.4).

  void checkWaterBadges(int currentWater, int dailyGoal) { // Su eklendiğinde WaterTrackerController tarafından çağrılır.
    final updated = List<BadgeModel>.from(badges.value); // Mevcut rozet listesinin yeni bir kopyasını oluşturur.
    bool changed = false; // Herhangi bir rozetin açılıp açılmadığını takip eden bayrak.

    // İlk damla
    if (currentWater > 0) { // Eğer içilen su 0'dan büyükse 'water_first' rozetini açmayı dener.
      changed |= _unlockBadge(updated, 'water_first'); // _unlockBadge true dönerse changed = true olur.
    }

    // Su hedefi
    if (currentWater >= dailyGoal && dailyGoal > 0) { // Günlük hedefe ulaşıldıysa 'water_goal' rozetini açmayı dener.
      changed |= _unlockBadge(updated, 'water_goal');
    }

    if (changed) { // ÖNEMLİ: Sadece gerçekten yeni bir rozet açıldıysa (changed == true) ValueNotifier güncellenir, gereksiz UI çizimi önlenir.
      badges.value = updated;
    }
  }

  void checkWorkoutBadges(int totalMinutes, int totalCalories, int dailyCalorieGoal) { // Antrenman eklendiğinde WorkoutController tarafından çağrılır.
    final updated = List<BadgeModel>.from(badges.value);
    bool changed = false;

    // İlk antrenman
    if (totalMinutes > 0) { // Toplam antrenman süresi 0'dan büyükse ilk antrenman rozetini açar.
      changed |= _unlockBadge(updated, 'workout_first');
    }

    // 500 kcal
    if (totalCalories >= 500) { // Yakılan toplam kalori 500 veya üzeriyse 'workout_burn_500' rozetini açar.
      changed |= _unlockBadge(updated, 'workout_burn_500');
    }

    if (changed) {
      badges.value = updated; // Yeni listeyi atayarak Rozetler ekranını günceller.
    }
  }

  void checkComboBadge(bool waterGoalMet, bool workoutGoalMet) { // Hem su hem antrenman hedefi tamamlandığında özel rozeti kontrol eder.
    if (waterGoalMet && workoutGoalMet) { // && (VE operatörü): Her iki hedef de true ise:
      final updated = List<BadgeModel>.from(badges.value);
      if (_unlockBadge(updated, 'double_champion')) {
        badges.value = updated;
      }
    }
  }

  bool _unlockBadge(List<BadgeModel> list, String badgeId) { // _: Sınıf içi özel metot. Verilen ID'li rozeti bulup kilidini açar.
    final index = list.indexWhere((b) => b.id == badgeId); // Aranan rozetin listedeki konumunu (index) bulur.
    if (index != -1 && !list[index].isUnlocked) { // Rozet listede varsa (index != -1) VE henüz kilidi açılmamışsa (!isUnlocked):
      final unlocked = list[index].copyWith( // copyWith() ile rozetin sadece isUnlocked ve unlockedAt alanlarını güncelleyerek yeni nesne üretir.
        isUnlocked: true,
        unlockedAt: DateTime.now(), // Kilidin açıldığı anın tarih/saatini kaydeder.
      );
      list[index] = unlocked; // Listedeki eski (kilitli) rozetin yerine yeni (açık) rozeti koyar.
      lastUnlockedBadgeNotification.value = unlocked.title; // Bildirim dinleyicisini tetiklemek için rozet başlığını atar.
      return true; // Yeni rozet açıldığını bildirir.
    }
    return false; // Rozet zaten açıksa veya bulunamadıysa false döner (tekrar bildirim gitmez).
  }

  void clearNotification() { // Bildirim SnackBar'da gösterildikten sonra sıfırlamak için kullanılır.
    lastUnlockedBadgeNotification.value = null;
  }

  void dispose() { // Bellek temizliği.
    badges.dispose();
    lastUnlockedBadgeNotification.dispose();
  }
}

// ÇALIŞMA MANTIĞI:
// Kullanıcı su veya egzersiz ekler -> checkWaterBadges() / checkWorkoutBadges() çağrılır
// -> Şart sağlanıyorsa _unlockBadge() çalışır -> Rozet daha önce açılmamışsa copyWith(isUnlocked: true) ile güncellenir
// -> lastUnlockedBadgeNotification.value'ya rozet adı yazılır (SnackBar tetiklenir) -> badges.value güncellenir (Rozet ekranı yenilenir).

// DOĞRUDAN LİSTE ELEMANINI DEĞİŞTİRMEK (badges.value[i] = unlocked) : Liste referansı aynı kaldığı için ValueNotifier değişikliği fark etmez, ekran güncellenmez
//  VS
// YENİ LİSTE KOPYASI ATAMAK (final updated = List.from(badges.value); ... badges.value = updated) : Yeni referans atandığı için ValueListenableBuilder anında tetiklenir ve UI güncellenir
