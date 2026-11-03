// -bu dosyada Su Takip (Water Tracker) modülünün tüm iş mantığı (su ekleme, azaltma, geri alma, sıfırlama) ve ChangeNotifier ile durum yönetimi anlatılıyor.-
// ChangeNotifier : Veriler değiştiğinde `notifyListeners()` çağrısıyla kendisini dinleyen UI bileşenlerini (`ListenableBuilder`, `BadgeController` vb.) otomatik haberdar eden sınıf.
// List.unmodifiable() : Sınıf içindeki private listeyi (`_logs`) dışarıya salt okunur (değiştirilemez) bir kopya olarak verir; böylece UI katmanının `controller.logs.add(...)` diyerek kapsüllemeyi (encapsulation) delmesi engellenir.
// fold() : Bir listedeki tüm elemanları başlangıç değerinden (0) başlayarak tek bir toplam değerde birleştiren (indirgeyen) yüksek mertebe liste fonksiyonudur.

import 'package:flutter/foundation.dart'; // foundation.dart : ChangeNotifier sınıfını sağlar.
import '../models/water_log.dart'; // Tek bir su kaydını temsil eden WaterLog modeli.

/// Su takip modülünün iş mantığını ve durumunu yöneten denetleyici (Controller).
/// Kırmızı Çizgiler gereği sayfa düzeyinde setState yerine ChangeNotifier kullanılır.
class WaterTrackerController extends ChangeNotifier { // extends ChangeNotifier : Reaktif durum yönetimi yeteneği kazandırır.
  WaterTrackerController({int initialGoalMl = 2500}) : _dailyGoalMl = initialGoalMl; // Kurucu metot : Varsayılan günlük hedef 2500 ml'dir | `: _dailyGoalMl = initialGoalMl` (Initializer List) : Gövde çalışmadan önce private alanı başlatır.

  int _dailyGoalMl; // _dailyGoalMl : Başındaki `_` ile private yapılan günlük su hedefi değişkeni.
  final List<WaterLog> _logs = []; // _logs : Gün içinde yapılan su ekleme/azaltma kayıtlarını tutan private liste (`final` olduğu için listenin kendisi başka bir listeyle değiştirilemez ama içine eleman eklenip silinebilir).

  int get dailyGoalMl => _dailyGoalMl; // get dailyGoalMl : Private hedef değerini dışarıya güvenli (salt okunur) şekilde açan getter.
  List<WaterLog> get logs => List.unmodifiable(_logs); // DİKKAT: Dışarıya `_logs` listesinin değiştirilemez bir görünümünü döndürür (Kapsülleme / Encapsulation güvenliği).

  /// Günlük toplam tüketilen su miktarı (ml)
  int get currentIntakeMl { // get currentIntakeMl : Listedeki tüm kayıtların ml değerlerini toplayarak güncel içilen su miktarını hesaplar.
    return _logs.fold(0, (total, log) => total + log.amountMl); // 0'dan başlar -> her bir `log.amountMl` değerini (azaltma kayıtları negatif olduğu için otomatik düşülür) `total` üzerine ekler.
  }

  /// Kalan su miktarı (ml)
  int get remainingMl { // get remainingMl : Hedefe ulaşmak için kaç ml daha su içilmesi gerektiğini hesaplar.
    final remaining = _dailyGoalMl - currentIntakeMl; // Hedef eksi içilen miktar.
    return remaining < 0 ? 0 : remaining; // Eğer hedefin üzerine çıkıldıysa (remaining negatifse) eksi göstermemek için `0` döndürür.
  }

  /// Tamamlanma yüzdesi (0.0 ile 1.0 arasında oran)
  double get progressRatio { // get progressRatio : CircularProgressIndicator'ın beklediği 0.0 - 1.0 arası ilerleme oranını hesaplar.
    if (_dailyGoalMl <= 0) return 0.0; // Sıfıra bölünme hatasını önlemek için güvenlik kontrolü.
    final ratio = currentIntakeMl / _dailyGoalMl; // İçilen miktarı günlük hedefe böler.
    return ratio > 1.0 ? 1.0 : ratio; // Hedef aşılsa bile görsel çubuğun taşmaması için oranı maksimum `1.0` (%100) ile sınırlar.
  }

  /// Yüzde olarak tam sayı (ör. %75)
  int get progressPercentage {
    return (progressRatio * 100).round(); // 0.0-1.0 arasındaki oranı 100 ile çarpıp en yakın tam sayıya yuvarlar.
  }

  /// Hedefe ulaşıldı mı?
  bool get isGoalAchieved => currentIntakeMl >= _dailyGoalMl && _dailyGoalMl > 0; // İçilen su miktarı günlük hedefe eşit veya büyükse `true` döner.

  /// Hedef tamamlanınca verilen rozet bilgisi
  String get badgeTitle => 'Hidrasyon Şampiyonu'; // Kazanılacak rozetin sabit başlığı.

  /// Rozet kazanıldı mı?
  bool get hasEarnedBadge => isGoalAchieved; // Hedefe ulaşıldığı anda rozet kazanılmış sayılır.

  /// Azaltma yapılabilir mi?
  bool get canDecrease => currentIntakeMl > 0; // Toplam içilen su 0'dan büyükse azaltma ve geri alma butonlarını aktif (`true`) yapar, 0 ise pasif (`false`) yapar.

  /// Yeni su tüketimi ekle
  void addWater(int amountMl, {String label = 'Hızlı Ekleme'}) { // addWater() : Belirtilen miktarda (amountMl) ve etikette (label) yeni su kaydı ekler.
    if (amountMl <= 0) return; // Guard Clause (Koruma Bloğu) : 0 veya negatif bir değer eklenmeye çalışılırsa işlemi anında durdurur.
    final log = WaterLog( // Yeni bir değişmez (immutable) WaterLog nesnesi oluşturur:
      id: DateTime.now().millisecondsSinceEpoch.toString(), // id : O anki zamanın milisaniye cinsinden benzersiz sayısal değerini String kimlik olarak kullanır.
      amountMl: amountMl, // Eklenen pozitif ml miktarı (Örn: +200).
      timestamp: DateTime.now(), // Kaydın oluşturulduğu tam tarih ve saat.
      label: label, // Kayıt açıklaması (Örn: 'Bardak', 'Matara').
    );
    _logs.insert(0, log); // _logs.insert(0, log) : Yeni kaydı listenin EN BAŞINA (0. indekse) ekler ki geçmiş listesinde en son içilen su en üstte görünsün (add() kullanılsaydı en sona eklerdi).
    notifyListeners(); // ÖNEMLİ: Dinleyen tüm widget'lara ve BadgeController'a "veri değişti, ekranı yenileyin" sinyali gönderir.
  }

  /// Yanlışlıkla ekleme durumu için su miktarını azaltma
  void decreaseWater(int amountMl, {String label = 'Yanlış Ekleme Düzeltmesi'}) { // decreaseWater() : Yanlışlıkla fazla eklenen suyu negatif kayıt oluşturarak düşer.
    if (amountMl <= 0 || currentIntakeMl <= 0) return; // Miktar geçersizse veya mevcut su zaten 0 ise işlem yapmadan çıkar.
    final effectiveAmount = amountMl > currentIntakeMl ? currentIntakeMl : amountMl; // ÖNEMLİ: Toplam suyun eksiye düşmemesi için; eğer 150 ml su varken -200 ml butonuna basılırsa sadece mevcut olan 150 ml'yi düşer.
    final log = WaterLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amountMl: -effectiveAmount, // `-effectiveAmount` : Miktarı eksi (-) işaretiyle kaydeder ki `fold` toplamında mevcut sudan düşülsün ve geçmişte "-200 ml" olarak görünsün.
      timestamp: DateTime.now(),
      label: label,
    );
    _logs.insert(0, log); // Düzeltme kaydını geçmiş listesinin en üstüne ekler.
    notifyListeners(); // Arayüzü günceller.
  }

  /// En son yapılan kaydı geri al
  void undoLast() { // undoLast() : En son eklenen (listenin 0. indeksindeki) su veya düzeltme kaydını tamamen siler.
    if (_logs.isNotEmpty) { // Liste boş değilse (hata almamak için kontrol):
      _logs.removeAt(0); // 0. indeksteki (en üstteki / en son yapılan) elemanı listeden çıkarır.
      notifyListeners(); // Arayüzü günceller.
    }
  }

  /// Son kaydı sil
  void removeLog(String logId) { // removeLog() : Kullanıcının geçmiş listesinden çarpı (X) butonuna basarak seçtiği belirli bir kaydı ID'sine göre siler.
    _logs.removeWhere((item) => item.id == logId); // removeWhere() : Listedeki elemanları gezer ve `item.id == logId` koşulunu sağlayan kaydı listeden siler.
    notifyListeners(); // Arayüzü günceller.
  }

  /// Günlük sayacı sıfırla
  void reset() { // reset() : Tüm günlük kayıtları temizleyerek sayacı sıfırlar.
    _logs.clear(); // clear() : Listedeki tüm elemanları tek seferde siler.
    notifyListeners(); // Arayüzü günceller.
  }

  /// Günlük hedefi güncelle
  void updateGoal(int newGoalMl) { // updateGoal() : Kullanıcının günlük su hedefini değiştirmesini sağlar.
    if (newGoalMl > 0) { // Yeni hedef 0'dan büyük geçerli bir sayıysa:
      _dailyGoalMl = newGoalMl; // Hedefi günceller.
      notifyListeners(); // İlerleme oranları değişeceği için arayüzü günceller.
    }
  }
}

// ÇALIŞMA MANTIĞI: Kullanıcı '+200 ml Bardak' butonuna basar -> addWater(200, label: 'Bardak') çağrılır -> Yeni WaterLog _logs listesinin 0. indeksine eklenir -> notifyListeners() çağrılır -> WaterTrackerView (ve dolaylı olarak BadgeController) anında yeniden hesaplanıp çizilir.

// INSERT(0, item) : Yeni elemanı listenin EN BAŞINA (0. indekse) ekler; geçmiş kayıtlarında "en yeni en üstte" (LIFO) sıralaması için idealdir.
//  VS
// ADD(item) : Yeni elemanı listenin EN SONUNA ekler; en son yapılan işlemi görmek için listenin en altına kaydırmak gerekir.
