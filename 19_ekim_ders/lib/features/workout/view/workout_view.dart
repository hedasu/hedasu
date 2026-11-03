// -bu dosyada Egzersiz takip modülünün ana ekran görünümü (WorkoutView), ListenableBuilder ile reaktif dinleme ve alt widget'lara (WorkoutStatCard, QuickWorkoutPresets, WorkoutLogList) görev dağılımı anlatılıyor.-
// ListenableBuilder : `WorkoutController` içindeki antrenman listesi her değiştiğinde sadece bu görünümü yeniden oluşturarak sayfa düzeyinde temiz ve hızlı bir güncelleme sağlar.
// CrossAxisAlignment.stretch : `Column` içindeki alt kartların yatay eksende (soldan sağa) mevcut tüm genişliği doldurmasını sağlar.

import 'package:flutter/material.dart'; // Flutter Material bileşenleri.
import '../controller/workout_controller.dart'; // Egzersiz iş mantığını yöneten controller.
import '../widgets/quick_workout_presets.dart'; // Hızlı egzersiz ekleme (Koşu, Ağırlık, HIIT, Bisiklet) butonları widget'ı.
import '../widgets/workout_log_list.dart'; // Tamamlanan egzersizleri listeleyen geçmiş widget'ı.
import '../widgets/workout_stat_card.dart'; // Yakılan kalori ve toplam süreyi gösteren üst istatistik kartı.

/// Egzersiz takip modülü ana ekran görünümü.
/// Kırmızı çizgiler uyarınca build metodu kısa ve modüler widgetlardan oluşmaktadır.
class WorkoutView extends StatelessWidget { // StatelessWidget : Kendi içinde state tutmayan, dışarıdan gelen `WorkoutController`'ı dinleyen ana ekran.
  const WorkoutView({
    super.key,
    required this.controller, // MainNavigationShell'den aktarılan egzersiz denetleyicisi.
  });

  final WorkoutController controller; // final : Egzersiz verilerini ve metotlarını barındıran controller referansı.

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder( // ListenableBuilder : `controller.notifyListeners()` çağrıldığında builder bloğunu yeniden çalıştırır.
      listenable: controller, // Dinlenen nesne : `WorkoutController`.
      builder: (context, _) {
        return SingleChildScrollView( // Ekran içeriğinin dikeyde kaydırılabilmesini sağlar.
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Kenarlardan yatay 16, dikey 12 piksel boşluk.
          child: Column( // 3 ana bileşeni (İstatistik Kartı, Hızlı Egzersiz Butonları, Antrenman Listesi) alt alta dizer.
            crossAxisAlignment: CrossAxisAlignment.stretch, // Tüm alt bileşenleri yatayda tam genişliğe yayar.
            children: [
              WorkoutStatCard( // 1. Bileşen : Toplam yakılan kalori, hedef kalori, toplam süre ve ilerleme çubuğunu gösteren kart.
                caloriesBurned: controller.totalCaloriesBurned, // Toplam yakılan kcal.
                calorieGoal: controller.dailyCalorieGoal, // Günlük kcal hedefi (500).
                durationMinutes: controller.totalDurationMinutes, // Toplam antrenman dakikası.
                progressRatio: controller.calorieProgressRatio, // 0.0 - 1.0 arası kalori hedef oranı.
                isGoalAchieved: controller.isGoalAchieved, // Kalori hedefi tamamlandı mı?
              ),
              const SizedBox(height: 20), // Bileşenler arası 20 piksel dikey boşluk.
              QuickWorkoutPresets( // 2. Bileşen : Tek dokunuşla antrenman ekleme, geri alma ve sıfırlama butonları.
                onAddWorkout: controller.addWorkout, // İsimlendirilmiş parametre imzaları birebir aynı olduğu için doğrudan `controller.addWorkout` referansı (tear-off) verilir.
                onUndoLast: controller.undoLast, // Son antrenmanı geri alma metodu referansı.
                onReset: controller.reset, // Tüm antrenmanları sıfırlama metodu referansı.
                canUndo: controller.canUndo, // Listede antrenman varsa "Geri Al" butonunu aktif eder.
              ),
              const SizedBox(height: 20),
              const Text(
                'Tamamlanan Egzersizler', // Geçmiş listesi başlığı.
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              WorkoutLogList( // 3. Bileşen : Eklenen egzersizlerin listesi ve silme işlemi.
                workouts: controller.workouts, // Salt okunur antrenman listesi.
                onDeleteWorkout: controller.removeWorkout, // Çarpı (X) butonuna basıldığında ilgili antrenmanı silen metot referansı.
              ),
            ],
          ),
        );
      },
    );
  }
}

// ÇALIŞMA MANTIĞI: Kullanıcı QuickWorkoutPresets içinden bir antrenmana tıklar -> controller.addWorkout() çalışır -> notifyListeners() tetiklenir -> WorkoutView içindeki ListenableBuilder ekranı yeniler -> WorkoutStatCard ve WorkoutLogList güncel verilerle çizilir.

// MODÜLER VIEW MİMARİSİ (`WorkoutStatCard` + `QuickWorkoutPresets` + `WorkoutLogList`) : Ana ekran (View) sadece yaklaşık 60 satırdır, hangi parçanın ne iş yaptığı ilk bakışta anlaşılır ve bakımı çok kolaydır.
//  VS
// MONOLİTİK (TEK PARÇA) VIEW : Tüm kartları, butonları ve listeleri tek bir dosya içinde 500 satır olarak yazmaktır; hata bulmayı ve tasarımı güncellemeyi zorlaştırır.
