// -bu dosyada Su Takip modülünün ana ekran görünümü (WaterTrackerView), alt bileşenlerin (ProgressCard, GoalBadge, QuickActions, History) birleştirilmesi ve callback fonksiyonlarıyla controller iletişimi anlatılıyor.-
// Callback (Geri Çağırma Fonksiyonu) : Alt widget'larda bir olay (butona tıklama, silme vb.) gerçekleştiğinde, alt widget'ın doğrudan controller'a bağımlı olması yerine üst widget'a haber vermesini sağlayan fonksiyon parametreleridir (`onAddWater`, `onDeleteLog` vb.).
// Delege Etme (Delegation) : Ana ekranın `build` metodunu yüzlerce satır kodla doldurmak yerine, her bir görsel bölümü kendi uzman alt widget'ına (`WaterProgressCard`, `QuickWaterActions` vb.) devretme mimarisidir.

import 'package:flutter/material.dart'; // Flutter Material bileşenleri.
import '../controller/water_tracker_controller.dart'; // Su takip iş mantığını yöneten controller.
import '../widgets/quick_water_actions.dart'; // Hızlı su ekleme/azaltma buton grubu widget'ı.
import '../widgets/water_goal_badge.dart'; // Günlük su hedefi rozet durumu kartı.
import '../widgets/water_log_history.dart'; // Bugünkü su kayıtlarını listeleyen geçmiş widget'ı.
import '../widgets/water_progress_card.dart'; // Dairesel su ilerleme göstergesi kartı.

/// Su takip modülü ana ekran görünümü.
/// Kırmızı çizgiler uyarınca build metodu kısa tutulmuş, alt bileşenlere delege edilmiştir.
class WaterTrackerView extends StatelessWidget { // StatelessWidget : Durumu ListenableBuilder üzerinden reaktif olarak dinleyen ana görünüm sınıfı.
  const WaterTrackerView({
    super.key,
    required this.controller, // MainNavigationShell tarafından oluşturulan ve buraya aktarılan WaterTrackerController.
  });

  final WaterTrackerController controller; // final : Su durumunu ve metotlarını barındıran denetleyici.

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder( // ListenableBuilder : Controller'da su eklendiğinde/silindiğinde (`notifyListeners()` çağrıldığında) sadece bu ekran içeriğini yeniden çizer.
      listenable: controller, // Dinlenen kaynak : `WaterTrackerController`.
      builder: (context, _) { // Değişiklik olduğunda çalışan çizim fonksiyonu.
        return SingleChildScrollView( // Küçük ekranlarda içerik taşarsa sayfanın dikeyde kaydırılabilmesini sağlar.
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Sayfa kenar boşlukları.
          child: Column( // 4 ana bölümü (İlerleme Kartı, Rozet, Hızlı Butonlar, Geçmiş Listesi) alt alta dizer.
            crossAxisAlignment: CrossAxisAlignment.stretch, // Alt kartların yatayda tam genişlik kaplamasını sağlar.
            children: [
              WaterProgressCard( // 1. Bölüm : Dairesel ilerleme ve ml sayacı kartı.
                currentMl: controller.currentIntakeMl, // Şu ana kadar içilen toplam su (ml).
                goalMl: controller.dailyGoalMl, // Günlük hedef (2500 ml).
                progressRatio: controller.progressRatio, // 0.0 - 1.0 arası ilerleme oranı.
                isGoalAchieved: controller.isGoalAchieved, // Hedef tamamlandı mı? (true ise kart yeşile döner).
              ),
              const SizedBox(height: 14), // Kartlar arası 14 piksel dikey boşluk.
              WaterGoalBadge( // 2. Bölüm : "Hidrasyon Şampiyonu" rozetinin kilit/kazanım durumu bandı.
                isAchieved: controller.isGoalAchieved, // Hedefe ulaşıldıysa açık rozet, ulaşılmadıysa kilitli rozet çizer.
                badgeTitle: controller.badgeTitle, // Rozet adı.
                remainingMl: controller.remainingMl, // Rozeti açmak için kalan ml miktarı.
              ),
              const SizedBox(height: 20),
              QuickWaterActions( // 3. Bölüm : Hızlı su ekleme (+200, +350, +500, +1000) ve düzeltme (-100, -200, -350, İptal) butonları.
                onAddWater: (amount, label) => controller.addWater(amount, label: label), // Alt widget'tan gelen (miktar, etiket) bilgisini controller.addWater metoduna iletir.
                onDecreaseWater: (amount, label) => controller.decreaseWater(amount, label: label), // Alt widget'tan gelen azaltma isteğini controller.decreaseWater metoduna iletir.
                onUndoLast: controller.undoLast, // Doğrudan fonksiyon referansı (Tear-off) : Parametresiz `undoLast` metodunu doğrudan bağlar.
                onReset: controller.reset, // Doğrudan fonksiyon referansı : `reset` metodunu doğrudan bağlar.
                canDecrease: controller.canDecrease, // İçilen su > 0 ise azaltma butonlarını aktif eder.
              ),
              const SizedBox(height: 20),
              const Text(
                'Bugünkü Kayıtlar', // Geçmiş listesi başlığı.
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              WaterLogHistory( // 4. Bölüm : Gün içinde yapılan su işlemlerinin saatli geçmiş listesi.
                logs: controller.logs, // Gösterilecek kayıt listesi.
                onDeleteLog: controller.removeLog, // Bir kaydın yanındaki 'X' butonuna basıldığında çalışacak silme fonksiyonu referansı.
              ),
            ],
          ),
        );
      },
    );
  }
}

// ÇALIŞMA MANTIĞI: Kullanıcı QuickWaterActions içindeki bir butona tıklar -> Callback (onAddWater) üzerinden controller.addWater() çalışır -> Controller veriyi günceller ve notifyListeners() çağırır -> WaterTrackerView içindeki ListenableBuilder tetiklenir -> Tüm alt bileşenler (WaterProgressCard, WaterGoalBadge, WaterLogHistory) yeni verilerle yeniden çizilir.

// TEAR-OFF (`onReset: controller.reset`) : Fonksiyonun parametre imzası birebir uyuştuğunda gereksiz `() => controller.reset()` anonim fonksiyonu açmadan doğrudan metodun referansını vermektir; daha temizdir.
//  VS
// ANONİM FONKSİYON (`onAddWater: (a, l) => controller.addWater(a, label: l)`) : Parametrelerin sırası veya türü (konumsal vs isimlendirilmiş `label:`) dönüştürüleceği zaman kullanılır.
