// -bu dosyada kullanıcının tek dokunuşla hazır antrenman (Koşu, Ağırlık, HIIT, Bisiklet) ekleyebildiği, son antrenmanı geri alabildiği veya sıfırlayabildiği QuickWorkoutPresets bileşeni anlatılıyor.-
// Named Parameters Function Type (`void Function({required String title, ...})`) : Bir callback fonksiyonunun parametrelerini sırayla değil, isimleriyle (`title:`, `durationMinutes:`) zorunlu olarak alacağını belirten fonksiyon imzasıdır; `WorkoutController.addWorkout` ile birebir eşleşir.
// Expanded : Bir `Row` içindeki 4 egzersiz kartının her birine eşit genişlik (ekranın 1/4'ü) paylaştıran esnek kapsayıcıdır.

import 'package:flutter/material.dart'; // Flutter Material bileşenleri.
import '../../../core/constants/app_colors.dart'; // Uygulama renk sabitleri.

/// Hızlı egzersiz ekleme buton grubu widgetı.
class QuickWorkoutPresets extends StatelessWidget { // StatelessWidget : Hazır antrenman şablonlarını gösteren ve tıklamaları callback ile üst katmana ileten bileşen.
  const QuickWorkoutPresets({
    super.key,
    required this.onAddWorkout, // Antrenman kartlarından birine tıklandığında çalışan fonksiyon.
    required this.onUndoLast, // "Geri Al" butonuna tıklandığında çalışan fonksiyon.
    required this.onReset, // "Sıfırla" butonuna tıklandığında çalışan fonksiyon.
    required this.canUndo, // Listede geri alınabilecek en az 1 antrenman var mı? (true/false).
  });

  final void Function({ // İsimlendirilmiş parametreler alan callback fonksiyon tipi:
    required String title, // Egzersiz adı.
    required int durationMinutes, // Süresi (dk).
    required int caloriesBurned, // Yakılan kalorisi (kcal).
    required String category, // Kategorisi.
  }) onAddWorkout;
  final VoidCallback onUndoLast; // Parametresiz geri alma fonksiyonu.
  final VoidCallback onReset; // Parametresiz sıfırlama fonksiyonu.
  final bool canUndo; // Geri Al butonunun aktiflik durumu.

  @override
  Widget build(BuildContext context) {
    return Column( // Üstteki başlık/aksiyon satırı ile alttaki 4'lü antrenman buton satırını alt alta dizer.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row( // Üst satır : Solda "Hızlı Egzersiz" başlığı, sağda "Geri Al" ve "Sıfırla" butonları.
          children: [
            const Expanded( // Başlığın sol alanı kaplayıp sağdaki butonları en sağa itmesini sağlar.
              child: Text(
                'Hızlı Egzersiz',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Row( // Sağdaki aksiyon butonları grubu:
              children: [
                TextButton.icon( // "Geri Al" butonu.
                  onPressed: canUndo ? onUndoLast : null, // Listede antrenman varsa (`canUndo == true`) tıklanabilir, yoksa `null` (pasif) olur.
                  icon: Icon(
                    Icons.undo_rounded,
                    size: 16,
                    color: canUndo ? AppColors.neonOrange : AppColors.textMuted, // Aktifse turuncu, pasifse soluk gri.
                  ),
                  label: Text(
                    'Geri Al',
                    style: TextStyle(
                      fontSize: 12,
                      color: canUndo ? AppColors.neonOrange : AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                TextButton.icon( // "Sıfırla" butonu.
                  onPressed: onReset, // Tüm antrenmanları temizleyen callback'i çağırır.
                  icon: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.textMuted),
                  label: const Text(
                    'Sıfırla',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10), // Başlık satırı ile butonlar arasına 10 piksel boşluk.
        Row( // Alt satır : 4 farklı hazır egzersiz seçeneğini yan yana eşit genişlikte dizer.
          children: [
            _buildPresetButton( // 1. Antrenman : Koşu (25 dk, 220 kcal, Neon Turuncu).
              title: 'Koşu',
              duration: 25,
              calories: 220,
              icon: Icons.directions_run_rounded,
              color: AppColors.neonOrange,
            ),
            const SizedBox(width: 8), // Kartlar arası 8 piksel yatay boşluk.
            _buildPresetButton( // 2. Antrenman : Ağırlık (40 dk, 250 kcal, Neon Yeşil).
              title: 'Ağırlık',
              duration: 40,
              calories: 250,
              icon: Icons.fitness_center_rounded,
              color: AppColors.neonLime,
            ),
            const SizedBox(width: 8),
            _buildPresetButton( // 3. Antrenman : HIIT - Yüksek Yoğunluklu Aralıklı Antrenman (15 dk, 180 kcal, Neon Mor).
              title: 'HIIT',
              duration: 15,
              calories: 180,
              icon: Icons.bolt_rounded,
              color: AppColors.neonPurple,
            ),
            const SizedBox(width: 8),
            _buildPresetButton( // 4. Antrenman : Bisiklet (30 dk, 200 kcal, Neon Mavi).
              title: 'Bisiklet',
              duration: 30,
              calories: 200,
              icon: Icons.pedal_bike_rounded,
              color: AppColors.neonCyan,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetButton({ // _buildPresetButton : Her bir egzersiz kartını oluşturan ortak yardımcı metot.
    required String title,
    required int duration,
    required int calories,
    required IconData icon,
    required Color color,
  }) {
    return Expanded( // Row içindeki mevcut yatay alanı diğer kardeşleriyle eşit paylaşır.
      child: Material(
        color: Colors.transparent, // InkWell dalga efekti için şeffaf Material zemini.
        child: InkWell( // Kartın üzerine dokunma ve dalga (ripple) efekti kazandırır.
          onTap: () => onAddWorkout( // Karta dokunulduğunda ilgili antrenmanın bilgilerini `onAddWorkout` ile controller'a gönderir:
            title: title,
            durationMinutes: duration,
            caloriesBurned: calories,
            category: title,
          ),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column( // İkon, egzersiz adı ve süresini alt alta dizer.
              children: [
                Icon(icon, color: color, size: 20), // Her antrenmanın kendine özgü neon renginde ikonu.
                const SizedBox(height: 6),
                Text(
                  title, // Örn: 'Koşu'
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$duration dk', // Örn: '25 dk'
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI: Kullanıcı 'Ağırlık (40 dk)' kartına dokunur -> InkWell onTap çalışır -> onAddWorkout(title: 'Ağırlık', durationMinutes: 40, caloriesBurned: 250, category: 'Ağırlık') tetiklenir -> Controller listeyi günceller -> 40 dk >= 30 dk olduğu için 'Demir Adam' rozeti de aynı anda açılır.

// İSİMLENDİRİLMİŞ PARAMETRELİ CALLBACK (`{required String title, ...}`) : Çok sayıda parametre (4 adet) gönderilirken hangi değerin süre, hangisinin kalori olduğunu karıştırmayı önler, kodun okunabilirliğini artırır.
//  VS
// KONUMSAL PARAMETRELİ CALLBACK (`(String, int, int, String)`) : `onAddWorkout('Koşu', 25, 220, 'Koşu')` şeklinde çağrılırken 25 ile 220'nin sırası yanlışlıkla ters yazılırsa derleyici hata vermez ama süre ile kalori birbirine karışır.
