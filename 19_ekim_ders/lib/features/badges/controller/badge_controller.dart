// -bu dosyada Rozetler (Badges) modülünün iş mantığı, birden fazla ChangeNotifier'ı birbirine bağlama (dinleme) ve dinamik rozet kazanım hesaplamaları anlatılıyor.-
// ChangeNotifier : Flutter'ın yerleşik durum yönetimi sınıfıdır. İçindeki veriler değiştiğinde `notifyListeners()` çağrılarak onu dinleyen arayüzlerin (ör. `ListenableBuilder`) güncellenmesini sağlar.
// addListener() : Başka bir `ChangeNotifier` nesnesine "sende bir değişiklik olursa benim şu fonksiyonumu çalıştır" diyerek abone olma (dinleyici ekleme) metodudur.
// removeListener() : `dispose()` aşamasında aboneliği iptal etme metodudur. EKLENEN HER DİNLEYİCİ MUTLAKA KALDIRILMALIDIR, aksi halde bellek sızıntısı (memory leak) oluşur.
// clamp(min, max) : Bir sayıyı belirtilen alt ve üst sınırlar arasında tutar (Örn: `1.4.clamp(0.0, 1.0)` sonucu `1.0` döner).

import 'package:flutter/foundation.dart'; // foundation.dart : UI paketine (material.dart) ihtiyaç duymadan saf ChangeNotifier sınıfını kullanmamızı sağlar.
import '../../water_tracker/controller/water_tracker_controller.dart'; // Su takip verilerini okumak ve dinlemek için içe aktarılır.
import '../../workout/controller/workout_controller.dart'; // Egzersiz verilerini okumak ve dinlemek için içe aktarılır.
import '../models/badge_item.dart'; // Rozet veri modeli (BadgeItem ve BadgeCategory).

/// Rozetler modülünün iş mantığını yöneten denetleyici (Controller).
/// Su ve egzersiz denetleyicilerini dinleyerek rozetlerin kazanım durumunu günceller.
class BadgeController extends ChangeNotifier { // extends ChangeNotifier : Bu sınıfa "dinlenebilir olma" ve "dinleyicilere haber verme (notifyListeners)" yeteneği kazandırır.
  BadgeController({ // Kurucu metot (Constructor) : Dışarıdan su ve egzersiz controller'larını zorunlu (required) olarak alır.
    required this.waterController, // Su verilerine erişmek için referans.
    required this.workoutController, // Egzersiz verilerine erişmek için referans.
  }) { // Kurucu gövdesi : Nesne oluşturulur oluşturulmaz her iki controller'ı dinlemeye başlar.
    waterController.addListener(_onDependenciesUpdated); // Su eklendiğinde/silindiğinde _onDependenciesUpdated fonksiyonunu tetikle.
    workoutController.addListener(_onDependenciesUpdated); // Egzersiz eklendiğinde/silindiğinde _onDependenciesUpdated fonksiyonunu tetikle.
  }

  final WaterTrackerController waterController; // final : Bağımlı olunan su denetleyicisi referansı.
  final WorkoutController workoutController; // final : Bağımlı olunan egzersiz denetleyicisi referansı.

  void _onDependenciesUpdated() { // _onDependenciesUpdated : Su veya egzersiz controller'ı `notifyListeners()` dediğinde otomatik çalışan geri çağırma (callback) metodu.
    notifyListeners(); // BadgeView ekranına "su veya egzersiz verisi değişti, rozetleri yeniden hesaplayıp ekranı güncelle!" sinyali gönderir.
  }

  @override
  void dispose() { // dispose() : BadgeController bellekten silinirken çalışır.
    waterController.removeListener(_onDependenciesUpdated); // ÖNEMLİ: Su denetleyicisindeki dinleyici aboneliğini koparır.
    workoutController.removeListener(_onDependenciesUpdated); // ÖNEMLİ: Egzersiz denetleyicisindeki dinleyici aboneliğini koparır.
    super.dispose(); // Üst sınıfın (ChangeNotifier) temizlik işlemlerini yapar.
  }

  /// Tüm rozet listesi ve güncel kilit durumları
  List<BadgeItem> get badges { // get badges : Her çağrıldığında su ve egzersizdeki en güncel duruma göre 5 rozetin durumunu hesaplayıp liste olarak döndüren getter.
    final isWaterAchieved = waterController.isGoalAchieved; // Günlük su hedefi (2500 ml) tamamlandı mı? (true/false)
    final isWorkoutAchieved = workoutController.isGoalAchieved; // Günlük kalori hedefi (500 kcal) tamamlandı mı? (true/false)
    final hasWaterLogs = waterController.currentIntakeMl > 0; // Bugün en az 1 ml bile olsa su içildi mi? (İlk Yudum rozeti için)
    final has30MinWorkout = workoutController.totalDurationMinutes >= 30; // Toplam egzersiz süresi 30 dakikaya ulaştı mı? (Demir Adam rozeti için)

    return [ // Hesaplanan güncel durumlarla oluşturulan BadgeItem nesneleri listesi:
      BadgeItem( // 1. Rozet : Hidrasyon Şampiyonu
        id: 'hidrasyon_sampiyonu',
        title: 'Hidrasyon Şampiyonu',
        description: 'Günlük 2500 ml su hedefini başarıyla tamamla.',
        iconEmoji: '💧',
        category: BadgeCategory.water, // Kategori : Su rozeti.
        isUnlocked: isWaterAchieved, // Su hedefi bittiyse kilidi açılır (true).
        progress: waterController.progressRatio, // 0.0 ile 1.0 arasındaki su tamamlanma oranı.
        requirementText: '${waterController.currentIntakeMl} / ${waterController.dailyGoalMl} ml', // Örn: "1200 / 2500 ml"
      ),
      BadgeItem( // 2. Rozet : İlk Yudum
        id: 'ilk_yudum',
        title: 'İlk Yudum',
        description: 'Güne zinde başla ve günün ilk su kaydını oluştur.',
        iconEmoji: '🥤',
        category: BadgeCategory.water,
        isUnlocked: hasWaterLogs, // currentIntakeMl > 0 ise anında açılır.
        progress: hasWaterLogs ? 1.0 : 0.0, // Ternary operatörü (? :) : Su içildiyse %100 (1.0), içilmediyse %0 (0.0).
        requirementText: hasWaterLogs ? 'Tamamlandı' : '1 Bardak Su İç', // Duruma göre dinamik alt metin.
      ),
      BadgeItem( // 3. Rozet : Kalori Canavarı
        id: 'kalori_canavari',
        title: 'Kalori Canavarı',
        description: 'Günlük 500 kcal yakım hedefine başarıyla ulaş.',
        iconEmoji: '🔥',
        category: BadgeCategory.workout, // Kategori : Egzersiz rozeti.
        isUnlocked: isWorkoutAchieved, // Kalori hedefi bittiyse kilidi açılır.
        progress: workoutController.calorieProgressRatio, // 0.0 ile 1.0 arası kalori oranı.
        requirementText: '${workoutController.totalCaloriesBurned} / ${workoutController.dailyCalorieGoal} kcal', // Örn: "250 / 500 kcal"
      ),
      BadgeItem( // 4. Rozet : Demir Adam
        id: 'demir_adam',
        title: 'Demir Adam',
        description: 'Günde toplam en az 30 dakika antrenman yap.',
        iconEmoji: '🏋️',
        category: BadgeCategory.workout,
        isUnlocked: has30MinWorkout, // Toplam süre >= 30 dk ise açılır.
        progress: (workoutController.totalDurationMinutes / 30).clamp(0.0, 1.0), // Süreyi 30'a böler ve .clamp(0.0, 1.0) ile 1.0'ı aşmasını engeller (ProgressIndicator 0-1 arası değer bekler).
        requirementText: '${workoutController.totalDurationMinutes} / 30 dk', // Örn: "25 / 30 dk"
      ),
      BadgeItem( // 5. Rozet : Çifte Şampiyon (Bileşik Rozet)
        id: 'cifte_sampiyon',
        title: 'Çifte Şampiyon',
        description: 'Hem su hedefini hem de egzersiz hedefini aynı gün tamamla!',
        iconEmoji: '👑',
        category: BadgeCategory.general, // Kategori : Genel başarı.
        isUnlocked: isWaterAchieved && isWorkoutAchieved, // && (VE operatörü) : HER İKİ hedef de aynı anda tamamlandıysa true döner.
        progress: (isWaterAchieved ? 0.5 : 0.0) + (isWorkoutAchieved ? 0.5 : 0.0), // Hedeflerden biri biterse 0.5 (%50), ikisi de biterse 1.0 (%100) ilerleme gösterir.
        requirementText: isWaterAchieved && isWorkoutAchieved
            ? 'Tüm Hedefler Başarıldı!'
            : 'Su & Egzersiz Hedefini Bitir',
      ),
    ];
  }

  /// Toplam kazanılan rozet sayısı
  int get unlockedCount => badges.where((b) => b.isUnlocked).length; // .where() : Listeyi filtreler, sadece `isUnlocked == true` olan rozetleri seçer ve `.length` ile sayısını döndürür.

  /// Toplam rozet sayısı
  int get totalCount => badges.length; // Toplam rozet adedini (5) döndürür.

  /// Kazanım oranı (0.0 - 1.0)
  double get unlockRatio => totalCount > 0 ? unlockedCount / totalCount : 0.0; // Sıfıra bölünme hatasını (DivisionByZero) önlemek için önce `totalCount > 0` kontrolü yapar, sonra kazanılan/toplam oranını hesaplar.
}

// ÇALIŞMA MANTIĞI: Kullanıcı su veya egzersiz ekler -> İlgili controller notifyListeners() çağırır -> BadgeController'ın addListener ile bağladığı _onDependenciesUpdated() tetiklenir -> BadgeController kendi notifyListeners() metodunu çağırır -> BadgeView ekranı güncel rozetlerle yeniden çizilir.

// HESAPLANMIŞ ÖZELLİK (Computed Getter - `get badges`) : Veriyi ayrı bir değişkende kopyalamak yerine her sorulduğunda kaynak controller'lardan anlık hesaplar; veri tutarsızlığı (senkronizasyon hatası) yaşanmaz.
//  VS
// SAKLANAN DURUM (Stored State - `List<BadgeItem> _badges`) : Veriyi bellekte ayrı bir listede tutar; kaynak her değiştiğinde listeyi manuel güncellemek gerekir, unutulursa eski/hatalı veri görünür.
