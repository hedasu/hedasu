// -bu kod bloğunda Egzersiz sekmesinin ana görünümü (WorkoutView), özet kartı, geri alma bölümü, hızlı egzersiz şablonları ve yapılan antrenmanların listelenmesi anlatılıyor.-
// Ters Sıralı Listeleme (workoutList[workoutList.length - 1 - index]): Listeye son eklenen (en güncel) antrenmanın ekranda en üstte görünmesini sağlayan indeks hesaplaması.
// Boş Durum (Empty State) Gösterimi: Henüz hiç antrenman eklenmediğinde (workoutList.isEmpty) kullanıcıya boş bir ekran yerine yönlendirici bilgi mesajı gösterme tekniği.

import 'package:flutter/material.dart'; // Flutter UI bileşenleri.
import '../../../../core/constants/app_colors.dart'; // Renk sabitleri.
import '../controllers/workout_controller.dart'; // Egzersiz kontrolcüsü.
import '../models/workout_entry_model.dart'; // Antrenman veri modeli.
import '../widgets/workout_card.dart'; // Tekil antrenman satır kartı.
import '../widgets/workout_quick_presets.dart'; // Hızlı egzersiz ekleme çipleri.
import '../widgets/workout_summary_card.dart'; // Üstteki toplam dakika ve kalori özet kartı.
import '../widgets/workout_undo_section.dart'; // Son antrenmanı geri alma (Undo) bölümü.

/// Egzersiz ve Fitness Takip Görünümü (Stateless & ValueListenableBuilder)
class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<WorkoutEntryModel>>( // controller.workouts listesini dinler, antrenman eklendiğinde veya silindiğinde ekranı yeniler.
      valueListenable: controller.workouts,
      builder: (context, workoutList, _) { // workoutList: Güncel antrenman listesi.
        return ListView( // Tüm sayfanın dikey kaydırılabilir olmasını sağlar.
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          children: [
            WorkoutSummaryCard( // 1. Bölüm: Aktif süre ve yakılan kalori özet kartı.
              totalMinutes: controller.totalMinutes,
              totalCalories: controller.totalCalories,
              minutesGoal: controller.dailyMinutesGoal,
              caloriesGoal: controller.dailyCalorieGoal,
            ),
            const SizedBox(height: 16),
            WorkoutUndoSection( // 2. Bölüm: Son eklenen egzersizi geri alma kutusu (liste boşsa gizlenir).
              workouts: workoutList,
              onUndo: () => _handleUndo(context),
            ),
            const SizedBox(height: 16),
            WorkoutQuickPresets( // 3. Bölüm: Tek tıkla hazır egzersiz (Ağırlık, Kardio, HIIT, Yoga) ekleme alanı.
              onAddPreset: ({
                required String title,
                required int durationMinutes,
                required int caloriesBurned,
                required String category,
              }) {
                controller.addWorkout( // Seçilen hazır şablonun bilgilerini kontrolcüye gönderir.
                  title: title,
                  durationMinutes: durationMinutes,
                  caloriesBurned: caloriesBurned,
                  category: category,
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Bugünkü Antrenmanlar', // 4. Bölüm başlığı.
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _WorkoutList(workoutList: workoutList), // Yapılan antrenmanları alt alta sıralayan özel widget.
          ],
        );
      },
    );
  }

  void _handleUndo(BuildContext context) { // Geri Al butonuna basıldığında çalışır.
    final success = controller.undoLastWorkout(); // Son antrenmanı listeden çıkarır.
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Son antrenman kaydı geri alındı.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class _WorkoutList extends StatelessWidget { // Antrenman geçmişini veya boş durum mesajını çizen alt widget.
  final List<WorkoutEntryModel> workoutList;

  const _WorkoutList({required this.workoutList});

  @override
  Widget build(BuildContext context) {
    if (workoutList.isEmpty) { // Eğer henüz hiçbir antrenman eklenmemişse kullanıcıya bilgi kutusu (Empty State) gösterir.
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: const Center(
          child: Text(
            'Henüz antrenman kaydı eklenmedi.\nYukarıdaki hızlı seçeneklerden ekleyebilirsin.', // \n: Alt satıra geçer.
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ),
      );
    }

    return ListView.builder( // Antrenmanlar varsa dinamik olarak kartları oluşturur.
      shrinkWrap: true, // Dıştaki ListView içinde sorunsuz çalışması için boyunu içeriğe göre sınırlar.
      physics: const NeverScrollableScrollPhysics(), // Kendi kaydırmasını kapatıp ana sayfa kaydırmasına uyar.
      itemCount: workoutList.length,
      itemBuilder: (context, index) {
        // En yeniden en eskiye sıralama:
        // Örn: Listede 3 eleman varsa (uzunluk 3), index=0 iken 3 - 1 - 0 = 2. (en son eklenen) elemanı getirir.
        final item = workoutList[workoutList.length - 1 - index];
        return WorkoutCard(workout: item);
      },
    );
  }
}

// ÇALIŞMA MANTIĞI:
// Kullanıcı WorkoutQuickPresets'ten bir egzersize basar -> onAddPreset tetiklenir -> controller.addWorkout() çalışır
// -> workouts listesi güncellenir -> ValueListenableBuilder ekranı yeniler
// -> WorkoutSummaryCard'da toplamlar artar ve _WorkoutList içinde en üste yeni WorkoutCard eklenir.

// DÜZ İNDEKS (workoutList[index]) : İlk eklenen (en eski) antrenmanı en üstte, yeni ekleneni en altta gösterir
//  VS
// TERS İNDEKS (workoutList[workoutList.length - 1 - index]) : En son eklenen (en güncel) antrenmanı listenin en üstünde gösterir
