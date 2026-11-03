// -bu kod bloğunda yapılan tek bir antrenmanın kategori ikonunu, başlığını, süresini ve yakılan kalorisini şık bir satır kartı halinde gösteren WorkoutCard widget'ı anlatılıyor.-
// Modüler Alt Widget Parçalama (_WorkoutIconBox, _WorkoutInfo, _WorkoutCalories): Tek bir büyük build() metodu yazmak yerine kartın sol, orta ve sağ bölümlerini ayrı küçük StatelessWidget'lara bölerek okunabilirliği ve performansı artırma tekniği.

import 'package:flutter/material.dart'; // Flutter UI bileşenleri.
import '../../../../core/constants/app_colors.dart'; // Renk sabitleri.
import '../models/workout_entry_model.dart'; // Antrenman veri modeli.

/// Tekil Antrenman Kartı (Temaya Duyarlı)
class WorkoutCard extends StatelessWidget {
  final WorkoutEntryModel workout; // Gösterilecek antrenman verisi.

  const WorkoutCard({
    super.key,
    required this.workout,
  });

  IconData _getCategoryIcon(String category) { // Antrenman kategorisine göre uygun ikonu döndüren yardımcı metot.
    switch (category) {
      case 'cardio':
        return Icons.directions_run_rounded; // Koşan insan ikonu.
      case 'hiit':
        return Icons.flash_on_rounded; // Şimşek (yüksek yoğunluk) ikonu.
      case 'yoga':
        return Icons.self_improvement_rounded; // Meditasyon/Esneklik ikonu.
      case 'strength':
      default:
        return Icons.fitness_center_rounded; // Ağırlık/Dambıl ikonu.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), // Altındaki diğer antrenman kartıyla arasına 10 piksel dış boşluk (margin) bırakır.
      padding: const EdgeInsets.all(14), // Kartın iç boşluğu (padding).
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorderOf(context)),
      ),
      child: Row( // Sol ikon kutusu, orta bilgi yazıları ve sağ kalori etiketini yan yana dizer.
        children: [
          _WorkoutIconBox(icon: _getCategoryIcon(workout.category)), // Sol: Yeşil ikon kutusu.
          const SizedBox(width: 14),
          Expanded( // Orta: Başlık ve dakika bilgisi (kalan tüm yatay alanı kaplar, kalori kutusunu en sağa iter).
            child: _WorkoutInfo(
              title: workout.title,
              durationMinutes: workout.durationMinutes,
            ),
          ),
          _WorkoutCalories(calories: workout.caloriesBurned), // Sağ: Turuncu ateş ikonlu kalori rozeti.
        ],
      ),
    );
  }
}

class _WorkoutIconBox extends StatelessWidget { // Kartın solundaki 44x44 piksellik yeşil parlamalı ikon kutusu.
  final IconData icon;

  const _WorkoutIconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final green = AppColors.greenOf(context);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? AppColors.neonGreenGlow : const Color(0x2000E676), // Yeşil yarı saydam arka plan.
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: green, size: 24),
    );
  }
}

class _WorkoutInfo extends StatelessWidget { // Kartın ortasındaki antrenman adı ve süresi.
  final String title;
  final int durationMinutes;

  const _WorkoutInfo({
    required this.title,
    required this.durationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Yazıları sola hizalar.
      children: [
        Text(
          title, // Örn: 'Ağırlık Antrenmanı'.
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$durationMinutes dakika', // Örn: '45 dakika'.
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }
}

class _WorkoutCalories extends StatelessWidget { // Kartın sağındaki yakılan kaloriyi gösteren turuncu kutucuk.
  final int calories;

  const _WorkoutCalories({required this.calories});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLightOf(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neonOrangeGlow),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded, // Ateş ikonu.
              color: AppColors.neonOrange, size: 16),
          const SizedBox(width: 4),
          Text(
            '$calories kcal', // Örn: '320 kcal'.
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.neonOrange,
            ),
          ),
        ],
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// WorkoutCard bir WorkoutEntryModel alır -> _getCategoryIcon() ile kategorisine uygun ikonu seçer
// -> Row içinde _WorkoutIconBox, _WorkoutInfo ve _WorkoutCalories alt widget'larını yan yana yerleştirerek kartı oluşturur.

// PADDING (İÇ BOŞLUK) : Kutunun kenarlığı (border) ile içindeki elemanlar (yazı/ikon) arasındaki boşluktur
//  VS
// MARGIN (DIŞ BOŞLUK) : Kutunun kenarlığı (border) ile dışındaki diğer komşu kutular arasındaki boşluktur
