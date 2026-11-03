// -bu kod bloğunda kullanıcının tek dokunuşla hazır antrenman şablonlarını (Ağırlık, Kardio, HIIT, Yoga) ekleyebilmesini sağlayan WorkoutQuickPresets widget'ı anlatılıyor.-
// Wrap Widget'ı: Çocuklarını yan yana dizen, ancak satırda yer kalmadığında taşma hatası (Right Overflowed) vermek yerine sığmayan elemanları otomatik olarak bir alt satıra indiren esnek düzen widget'ı.
// İsimlendirilmiş Fonksiyon Parametreleri (void Function({required String title, ...})): Callback fonksiyonunun çağrılırken hangi değerin ne anlama geldiğini açıkça belirterek (title: '...', durationMinutes: 45) hata yapma riskini azaltan yapı.

import 'package:flutter/material.dart'; // Flutter UI kütüphanesi.
import '../../../../core/constants/app_colors.dart'; // Renk sabitleri.

/// Hızlı Antrenman Ekleme Seçenekleri (Temaya Duyarlı)
class WorkoutQuickPresets extends StatelessWidget {
  final void Function({ // Bir şablona tıklandığında 4 temel antrenman bilgisini üst katmana ileten fonksiyon tipi.
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    required String category,
  }) onAddPreset;

  const WorkoutQuickPresets({
    super.key,
    required this.onAddPreset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hızlı Egzersiz Ekle', // Bölüm başlığı.
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        const SizedBox(height: 12),
        Wrap( // Butonları yan yana dizer, ekrana sığmayanları otomatik olarak alt satıra geçirir.
          spacing: 8, // Yan yana duran çipler arasındaki yatay boşluk (8 piksel).
          runSpacing: 8, // Alt satıra geçen çipler ile üst satır arasındaki dikey boşluk (8 piksel).
          children: [
            _PresetChip( // 1. Şablon: Ağırlık Antrenmanı (45 dk, 320 kcal).
              title: 'Ağırlık',
              subtitle: '45 dk • 320 kcal',
              icon: Icons.fitness_center_rounded,
              onTap: () => onAddPreset(
                title: 'Ağırlık Antrenmanı',
                durationMinutes: 45,
                caloriesBurned: 320,
                category: 'strength',
              ),
            ),
            _PresetChip( // 2. Şablon: Kardio Koşu (30 dk, 280 kcal).
              title: 'Kardio Koşu',
              subtitle: '30 dk • 280 kcal',
              icon: Icons.directions_run_rounded,
              onTap: () => onAddPreset(
                title: 'Kardio Koşu',
                durationMinutes: 30,
                caloriesBurned: 280,
                category: 'cardio',
              ),
            ),
            _PresetChip( // 3. Şablon: HIIT Seansı (20 dk, 220 kcal).
              title: 'HIIT Seansı',
              subtitle: '20 dk • 220 kcal',
              icon: Icons.flash_on_rounded,
              onTap: () => onAddPreset(
                title: 'HIIT Yağ Yakımı',
                durationMinutes: 20,
                caloriesBurned: 220,
                category: 'hiit',
              ),
            ),
            _PresetChip( // 4. Şablon: Yoga & Esneme (25 dk, 90 kcal).
              title: 'Yoga & Esneme',
              subtitle: '25 dk • 90 kcal',
              icon: Icons.self_improvement_rounded,
              onTap: () => onAddPreset(
                title: 'Yoga & Esneme',
                durationMinutes: 25,
                caloriesBurned: 90,
                category: 'yoga',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget { // Tek bir hızlı egzersiz kutucuğunun (chip) tasarımını tutan özel widget.
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _PresetChip({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final green = AppColors.greenOf(context); // Egzersiz teması için neon yeşil renk.

    return InkWell( // Tıklama ve dalga efekti.
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceBorderOf(context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // ÖNEMLİ: Wrap içinde kullanıldığı için tüm satırı kaplamak yerine sadece içindeki yazı ve ikon kadar genişlik alır.
          children: [
            Icon(icon, color: green, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, // Örn: 'Ağırlık'.
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                Text(
                  subtitle, // Örn: '45 dk • 320 kcal'.
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// Wrap widget'ı 4 adet _PresetChip'i ekran genişliğine göre yan yana ve alt alta yerleştirir
// -> Kullanıcı bir çipe dokunduğunda onTap tetiklenir -> onAddPreset ile egzersiz bilgileri WorkoutView'a ve oradan WorkoutController'a iletilir.

// ROW : Tüm elemanları tek bir satıra sıkıştırmaya çalışır; ekran daralırsa sağdan taşma hatası (Overflow) verir
//  VS
// WRAP : Elemanları satıra dizer, satır dolduğunda sığmayanları otomatik olarak alt satıra kaydırır (etiket ve çip listeleri için en güvenli yapıdır)
