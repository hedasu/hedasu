// -bu dosyada Egzersiz ekranının en üstünde yer alan, yakılan toplam kaloriyi, kalori hedefini ve toplam antrenman süresini gösteren neon istatistik kartı (WorkoutStatCard) anlatılıyor.-
// CrossAxisAlignment.baseline : Yan yana duran farklı boyutlardaki iki metnin (örneğin 22 punto `'250'` ile 12 punto `'/ 500 kcal'`) alt taban çizgilerini (harflerin oturduğu görünmez çizgiyi) kusursuz hizalar.
// TextBaseline.alphabetic : `CrossAxisAlignment.baseline` kullanıldığında Latin harf ve rakamlarının taban çizgisini referans alacağını belirten zorunlu parametredir.

import 'package:flutter/material.dart'; // Flutter Material bileşenleri.
import '../../../core/constants/app_colors.dart'; // Uygulama renk sabitleri.

/// Egzersiz ve yakılan kalori istatistiklerini özetleyen neon kart.
class WorkoutStatCard extends StatelessWidget { // StatelessWidget : Dışarıdan aldığı kalori ve süre metriklerini görselleştiren durumsuz kart.
  const WorkoutStatCard({
    super.key,
    required this.caloriesBurned, // Şu ana kadar yakılan toplam kalori (kcal).
    required this.calorieGoal, // Günlük kalori yakım hedefi (500 kcal).
    required this.durationMinutes, // Toplam egzersiz süresi (dakika).
    required this.progressRatio, // 0.0 ile 1.0 arasındaki kalori hedef oranı.
    required this.isGoalAchieved, // Kalori hedefine ulaşıldı mı? (true/false).
  });

  final int caloriesBurned; // final : Yakılan kalori.
  final int calorieGoal; // final : Hedef kalori.
  final int durationMinutes; // final : Toplam süre (dk).
  final double progressRatio; // final : İlerleme oranı.
  final bool isGoalAchieved; // final : Başarı durumu.

  @override
  Widget build(BuildContext context) {
    return Container( // İstatistik kartının dış kapsayıcısı.
      padding: const EdgeInsets.all(22), // Her yönden 22 piksel iç boşluk.
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24), // Köşeleri 24 birim yuvarlatır.
        border: Border.all(
          color: isGoalAchieved ? AppColors.neonLime : AppColors.cardBorder, // Kalori hedefi tamamlandığında çerçeveyi Neon Lime yapar.
          width: 1.5,
        ),
      ),
      child: Column( // Üstteki iki metrik (Kalori ve Süre) ile alttaki ilerleme çubuğunu alt alta dizer.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row( // Sol tarafta "Yakılan Kalori", sağ tarafta "Toplam Süre" metriğini yan yana dizer.
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // İki metriği kartın sol ve sağ uçlarına dengeli yerleştirir.
            children: [
              _buildMetric( // 1. Metrik : Yakılan Kalori (Neon Turuncu ateş ikonuyla).
                label: 'Yakılan Kalori',
                value: '$caloriesBurned', // Örn: '220'
                unit: '/ $calorieGoal kcal', // Örn: '/ 500 kcal'
                color: AppColors.neonOrange,
                icon: Icons.local_fire_department_rounded,
              ),
              _buildMetric( // 2. Metrik : Toplam Süre (Neon Yeşil kronometre ikonuyla).
                label: 'Toplam Süre',
                value: '$durationMinutes', // Örn: '25'
                unit: 'dk',
                color: AppColors.neonLime,
                icon: Icons.timer_outlined,
              ),
            ],
          ),
          const SizedBox(height: 18), // Metrikler ile ilerleme çubuğu arasına 18 piksel dikey boşluk.
          ClipRRect( // İlerleme çubuğunun köşelerini 8 birim yuvarlatır.
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator( // Kalori hedefi ilerleme çubuğu.
              value: progressRatio, // 0.0 - 1.0 arası oran.
              minHeight: 10, // Çubuk kalınlığı : 10 piksel.
              backgroundColor: AppColors.surfaceVariant, // Dolmayan kısmın rengi.
              valueColor: AlwaysStoppedAnimation<Color>( // Dolan kısmın rengi:
                isGoalAchieved ? AppColors.neonLime : AppColors.neonOrange, // Hedef tamamlandıysa Neon Yeşil, devam ediyorsa Neon Turuncu.
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({ // _buildMetric : İkon kutusu, başlık, büyük sayı ve birim metnini oluşturan ortak yardımcı metot.
    required String label,
    required String value,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    return Row( // Solda ikon kutusu, sağda metin sütunu.
      children: [
        Container( // İkonun etrafındaki yuvarlatılmış kare arka plan.
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12), // Vurgu renginin %12 opaklığında hafif arka plan.
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12), // İkon ile yazılar arasına 12 piksel boşluk.
        Column( // Üstte küçük etiket ('Yakılan Kalori'), altta büyük rakam ve birimi.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row( // Büyük rakam ('220') ile küçük birimi ('/ 500 kcal') yan yana hizalar:
              crossAxisAlignment: CrossAxisAlignment.baseline, // ÖNEMLİ: Farklı font boyutlarındaki iki metnin alt tabanlarını aynı hizaya oturtur.
              textBaseline: TextBaseline.alphabetic, // Taban hizalaması için alfabetik referans çizgisi (CrossAxisAlignment.baseline ile zorunludur).
              children: [
                Text(
                  value, // Büyük sayı.
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit, // Küçük birim yazısı.
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ÇALIŞMA MANTIĞI: WorkoutView'dan kalori ve süre değerleri gelir -> _buildMetric ile sol ve sağ göstergeler çizilir -> LinearProgressIndicator progressRatio oranında doldurulur -> isGoalAchieved true olduğunda çubuk ve kart çerçevesi turuncudan neon yeşile döner.

// CROSSAXISALIGNMENT.BASELINE : Farklı punto büyüklüğündeki (22px ve 12px) rakam ve birim yazılarının alt ayaklarını aynı düz çizgiye oturtur; profesyonel tipografi sağlar.
//  VS
// CROSSAXISALIGNMENT.CENTER : Küçük birim yazısını büyük rakamın dikey ortasına (havada asılı gibi) hizalar; sayı ve birim kopuk görünür.
