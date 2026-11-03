// -bu dosyada gün içinde tamamlanan egzersizleri saat, süre ve kalori bilgileriyle listeleyen veya liste boşsa bilgilendirme kutusu gösteren WorkoutLogList bileşeni anlatılıyor.-
// ListView.separated : Dinamik listeleri oluştururken her iki eleman arasına `separatorBuilder` ile otomatik boşluk/çizgi ekleyen liste bileşenidir.
// NeverScrollableScrollPhysics : Bir `ScrollView` içindeki alt `ListView`'ın kendi başına kaymasını engelleyerek tüm ekranın tek bir bütün olarak kaymasını sağlayan fizik kuralıdır.

import 'package:flutter/material.dart'; // Flutter Material bileşenleri.
import '../../../core/constants/app_colors.dart'; // Uygulama renk sabitleri.
import '../models/workout.dart'; // Egzersiz veri modeli (Workout).

/// Kaydedilen egzersizleri listeleyen widget.
class WorkoutLogList extends StatelessWidget { // StatelessWidget : Dışarıdan gelen `workouts` listesini ekrana çizen ve silme isteğini `onDeleteWorkout` ile ileten bileşen.
  const WorkoutLogList({
    super.key,
    required this.workouts, // Gösterilecek egzersiz kayıtları listesi.
    required this.onDeleteWorkout, // Bir egzersizin yanındaki silme (X) butonuna basıldığında çalışan callback.
  });

  final List<Workout> workouts; // final : Antrenman listesi.
  final void Function(String id) onDeleteWorkout; // final : Silinecek antrenmanın ID'sini alan fonksiyon.

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) { // Eğer henüz hiç egzersiz eklenmemişse:
      return _buildEmptyState(); // Boş durum (Empty State) tasarımını göster.
    }

    return ListView.separated( // En az 1 egzersiz varsa listeyi çiz:
      shrinkWrap: true, // Sadece içindeki elemanların toplam yüksekliği kadar yer kapla.
      physics: const NeverScrollableScrollPhysics(), // Kendi kaydırmasını kapat, ana sayfa kaydırmasına uy.
      itemCount: workouts.length, // Listedeki antrenman sayısı.
      separatorBuilder: (context, index) => const SizedBox(height: 8), // Her iki antrenman kartı arasına 8 piksel dikey boşluk bırak.
      itemBuilder: (context, index) {
        final workout = workouts[index]; // Sıradaki Workout nesnesini al.
        return _buildWorkoutItem(workout); // Satır kartını oluşturup döndür.
      },
    );
  }

  Widget _buildEmptyState() { // _buildEmptyState : Antrenman listesi boşken gösterilen şık bilgilendirme alanı.
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.5)),
      ),
      child: const Column(
        children: [
          Icon(Icons.fitness_center_rounded, color: AppColors.textMuted, size: 28), // Dambıl ikonu.
          SizedBox(height: 8),
          Text(
            'Henüz egzersiz kaydı bulunmuyor.',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutItem(Workout workout) { // _buildWorkoutItem : Tek bir egzersiz kaydını gösteren satır kartı.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row( // Soldan sağa : Ateş İkonu -> Başlık ve Süre/Kalori Detayı -> Saat -> Silme (X) Butonu.
        children: [
          Container( // Sol baştaki yuvarlak turuncu ateş ikonu kutusu.
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.neonOrange.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded, // Ateş / Kalori ikonu.
              color: AppColors.neonOrange,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded( // Orta alan : Egzersiz adı ve altında dakika • kalori özeti.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.title, // Örn: 'Koşu', 'Ağırlık'.
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${workout.durationMinutes} dakika • ${workout.caloriesBurned} kcal', // Örn: '25 dakika • 220 kcal'.
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            workout.formattedTime, // Egzersizin eklendiği saat (Örn: '18:45').
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton( // Sağdaki silme (X) butonu.
            icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textMuted),
            onPressed: () => onDeleteWorkout(workout.id), // Tıklandığında bu kaydın `id` değerini silinmek üzere üst katmana bildirir.
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI: WorkoutView'dan workouts listesi gelir -> Boşsa _buildEmptyState() gösterilir -> Doluysa her Workout nesnesi için _buildWorkoutItem() çizilir -> Kullanıcı 'X' butonuna basarsa onDeleteWorkout(workout.id) ile kayıt silinir ve toplam kalori/süre düşer.

// LISTVIEW.SEPARATED : Elemanların arasına ayırıcı/boşluk koymak için ayrı bir parametre (`separatorBuilder`) sunar; son elemanın altına gereksiz boşluk eklemez.
//  VS
// LISTVIEW.BUILDER : Sadece elemanları çizer; aralarına boşluk koymak için her kartın dışına `Padding` veya `margin` vermek gerekir.
