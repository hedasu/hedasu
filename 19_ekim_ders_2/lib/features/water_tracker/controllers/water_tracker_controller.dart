// -bu kod bloğunda günlük su tüketimini, geçmiş su kayıtlarını, geri alma (undo) işlemini ve su rozeti tetiklemelerini yöneten WaterTrackerController sınıfı anlatılıyor.-
// ValueNotifier<T>: Reaktif durum tutucu. currentWater veya history değiştiğinde sadece ilgili ValueListenableBuilder'ları yeniden çizer.
// Spread Operatörü ([...list, item]): Mevcut bir listenin tüm elemanlarını yeni bir liste içine açıp sonuna yeni eleman ekleyerek yepyeni bir liste referansı oluşturur.
// clamp(alt, üst): Bir sayının belirtilen alt ve üst sınırlar dışına taşmasını engeller (Örn: su miktarının 0'ın altına düşmesini önler).

import 'package:flutter/foundation.dart'; // ValueNotifier için temel paket.
import '../../badges/controllers/badge_controller.dart'; // Su eklendiğinde rozet kontrolü yapmak için BadgeController.
import '../models/water_entry_model.dart'; // Su kaydı veri modeli.

/// Su Takip Durum Kontrolcüsü (ValueNotifier + Geri Alma / Undo Desteği)
class WaterTrackerController {
  final BadgeController? badgeController; // Rozetleri kontrol etmek için opsiyonel (null olabilir) bağımlılık.
  final int dailyGoalWater; // Günlük hedeflenen su miktarı (ml).

  final ValueNotifier<int> currentWater = ValueNotifier<int>(0); // Anlık içilen toplam su miktarı (başlangıçta 0 ml).
  final ValueNotifier<List<WaterEntryModel>> history =
      ValueNotifier<List<WaterEntryModel>>([]); // İçilen suların geçmiş listesi (Undo işlemi için tutulur).

  WaterTrackerController({
    this.badgeController,
    this.dailyGoalWater = 2500, // 2.5 Litre standart sporcu hedefi (değer verilmezse varsayılan 2500 ml).
  });

  bool get canUndo => history.value.isNotEmpty; // Geçmiş listesinde en az 1 kayıt varsa geri alma yapılabilir (true).
  double get progressRatio => // İlerleme halkası için 0.0 ile 1.0 arasında doluluk oranı hesaplar.
      dailyGoalWater > 0 ? (currentWater.value / dailyGoalWater).clamp(0.0, 1.0) : 0.0;

  /// Hızlı su ekleme
  void addWater(int amountMl, {String label = 'Su'}) { // Belirtilen miktarda (amountMl) ve etikette su ekler.
    if (amountMl <= 0) return; // 0 veya negatif değer girilirse hiçbir işlem yapmadan çık.

    final newEntry = WaterEntryModel( // Eklenen suyun detaylarını taşıyan model nesnesi oluşturulur.
      id: DateTime.now().microsecondsSinceEpoch.toString(), // Benzersiz ID olarak o anki mikrosaniye zaman damgası kullanılır.
      amountMl: amountMl,
      timestamp: DateTime.now(),
      label: label,
    );

    currentWater.value += amountMl; // Toplam su miktarını artırır -> İlerleme halkası güncellenir.
    history.value = [...history.value, newEntry]; // Eski geçmişin sonuna yeni kaydı ekleyip yeni liste atar -> Geri alma (Undo) kutusu güncellenir.

    // Rozet kontrolü
    badgeController?.checkWaterBadges(currentWater.value, dailyGoalWater); // ?.: badgeController null değilse su rozetlerini ('İlk Damla' ve 'Hidrasyon Şampiyonu') kontrol et.
  }

  /// Son su tüketimini geri alma (Undo)
  bool undoLastWater() { // Yanlışlıkla eklenen son suyu geri alır.
    if (history.value.isEmpty) return false; // Geçmiş boşsa geri alınacak kayıt yoktur, false döner.

    final updated = List<WaterEntryModel>.from(history.value); // Mevcut listenin değiştirilebilir kopyasını alır.
    final removed = updated.removeLast(); // removeLast(): Son eklenen su kaydını listeden siler ve silinen nesneyi döndürür.

    currentWater.value = (currentWater.value - removed.amountMl).clamp(0, 99999); // Silinen miktarı toplam sudan düşer, 0'ın altına inmesini clamp ile engeller.
    history.value = updated; // Güncel listeyi atayarak UI'ı yeniler.

    return true; // İşlem başarılı.
  }

  /// Sıfırlama
  void resetWater() { // Tüm günlük su verilerini sıfırlar.
    currentWater.value = 0;
    history.value = [];
  }

  void dispose() { // Bellek sızıntısını önlemek için ValueNotifier'ları kapatır.
    currentWater.dispose();
    history.dispose();
  }
}

// ÇALIŞMA MANTIĞI:
// Kullanıcı '+200 ml Bardak' butonuna basar -> addWater(200, label: 'Bardak') çağrılır
// -> WaterEntryModel oluşturulur -> currentWater.value 200 artar -> history.value listesine yeni kayıt eklenir
// -> badgeController?.checkWaterBadges() çağrılır -> İlk kez su içildiyse 'İlk Damla' rozeti açılır.

// SADECE TOPLAM SAYIYI TUTMAK (int currentWater) : Son eklenen miktarın ne olduğu bilinmediği için gerçek bir adım adım Geri Alma (Undo) yapılamaz
//  VS
// GEÇMİŞ LİSTESİ TUTMAK (List<WaterEntryModel> history) : Her ekleme kayıt altına alınır, removeLast() ile son işlem (ve ardışık işlemler) hatasız geri alınabilir
