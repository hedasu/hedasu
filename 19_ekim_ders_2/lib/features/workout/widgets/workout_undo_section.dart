// -bu kod bloğunda kullanıcının eklediği son antrenmanı gösteren ve yanlışlıkla eklenen antrenmanı tek dokunuşla geri almayı (Undo) sağlayan WorkoutUndoSection widget'ı anlatılıyor.-
// workouts.isEmpty & SizedBox.shrink(): Antrenman listesi boş olduğunda geri alma kartını ekranda hiç yer kaplamayacak şekilde gizleyen kontrol.
// workouts.last: Listeye en son eklenen WorkoutEntryModel nesnesine doğrudan erişim sağlayan özellik.

import 'package:flutter/material.dart'; // Flutter UI bileşenleri.
import '../../../../core/constants/app_colors.dart'; // Renk sabitleri.
import '../models/workout_entry_model.dart'; // Antrenman veri modeli.

/// Son Antrenmanı Geri Alma (Undo) Bölümü (Temaya Duyarlı)
class WorkoutUndoSection extends StatelessWidget {
  final List<WorkoutEntryModel> workouts; // Mevcut antrenman kayıtları listesi.
  final VoidCallback onUndo; // 'Geri Al' butonuna basıldığında tetiklenecek fonksiyon.

  const WorkoutUndoSection({
    super.key,
    required this.workouts,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) { // Eğer listede hiç antrenman yoksa:
      return const SizedBox.shrink(); // 0x0 boyutunda boş widget döndür (kartı gizle).
    }

    final last = workouts.last; // Listedeki en son eklenen antrenmanı alır.
    final green = AppColors.greenOf(context); // Egzersiz teması yeşil vurgu rengi.

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLightOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorderOf(context)),
      ),
      child: Row( // Onay ikonu, son antrenman detayları ve Geri Al butonunu yan yana dizer.
        children: [
          Icon(Icons.check_circle_rounded, color: green, size: 24), // Yeşil onay ikonu.
          const SizedBox(width: 12),
          Expanded( // Yazıların kalan boşluğu doldurmasını sağlar.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Son Egzersiz: ${last.title}', // Örn: 'Son Egzersiz: Kardio Koşu'.
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryOf(context),
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${last.durationMinutes} dk • ${last.caloriesBurned} kcal', // Örn: '30 dk • 280 kcal'.
                  style: TextStyle(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon( // Sağdaki turuncu çerçeveli 'Geri Al' aksiyon butonu.
            onPressed: onUndo, // Tıklandığında WorkoutView içindeki _handleUndo metodunu çalıştırır.
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceOf(context),
              foregroundColor: AppColors.neonOrange,
              side: const BorderSide(color: AppColors.neonOrange),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: const Icon(Icons.undo_rounded, size: 18),
            label: const Text('Geri Al', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// workouts listesi kontrol edilir -> Boş değilse workouts.last ile son antrenman alınır
// -> Başlığı, süresi ve kalorisi ekranda gösterilir -> 'Geri Al' butonuna basılırsa onUndo() çalışır ve son antrenman silinir.

// WORKOUTS.FIRST : Listenin ilk elemanını (günün ilk yapılan en eski antrenmanını) getirir
//  VS
// WORKOUTS.LAST : Listenin son elemanını (en son eklenen güncel antrenmanı) getirir; Undo (Geri Alma) işlemleri için her zaman .last kullanılır
