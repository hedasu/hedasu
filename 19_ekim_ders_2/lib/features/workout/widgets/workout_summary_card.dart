// -bu kod bloğunda günlük toplam aktif antrenman süresini (dakika) ve toplam yakılan kaloriyi (kcal) yan yana iki sütun halinde gösteren WorkoutSummaryCard widget'ı anlatılıyor.-
// Expanded İle Eşit Bölünmüş Kart: Row içinde iki Expanded widget'ı ve aralarında 1 piksellik dikey ayırıcı çizgi (Container) kullanarak kartı simetrik iki bölmeye ayırma tekniği.

import 'package:flutter/material.dart'; // Flutter UI bileşenleri.
import '../../../../core/constants/app_colors.dart'; // Renk sabitleri.

/// Günlük Egzersiz Özeti ve Kalori Kartı (Temaya Duyarlı)
class WorkoutSummaryCard extends StatelessWidget {
  final int totalMinutes; // Toplam antrenman süresi (dk).
  final int totalCalories; // Toplam yakılan kalori (kcal).
  final int minutesGoal; // Günlük dakika hedefi.
  final int caloriesGoal; // Günlük kalori hedefi.

  const WorkoutSummaryCard({
    super.key,
    required this.totalMinutes,
    required this.totalCalories,
    required this.minutesGoal,
    required this.caloriesGoal,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context); // Karanlık mod kontrolü.
    final green = AppColors.greenOf(context); // Aktif süre için yeşil renk.

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorderOf(context)),
        boxShadow: [ // Kartın altına yeşil neon parlama (glow) gölgesi verir.
          BoxShadow(
            color: isDark ? AppColors.neonGreenGlow : const Color(0x1500E676),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row( // Sol metrik (Süre), orta dikey çizgi ve sağ metrik (Kalori) yan yana dizilir.
        children: [
          Expanded( // Sol yarı: Aktif Süre istatistiği.
            child: _StatMetric(
              label: 'Aktif Süre',
              value: '$totalMinutes dk',
              goalText: 'Hedef: $minutesGoal dk',
              color: green,
              icon: Icons.timer_rounded, // Kronometre ikonu.
            ),
          ),
          Container( // İki istatistik arasındaki 1 piksel genişliğinde ve 60 piksel yüksekliğinde dikey ayırıcı çizgi (Divider).
            width: 1,
            height: 60,
            color: AppColors.surfaceBorderOf(context),
          ),
          Expanded( // Sağ yarı: Yakılan Kalori istatistiği.
            child: _StatMetric(
              label: 'Yakılan Kalori',
              value: '$totalCalories kcal',
              goalText: 'Hedef: $caloriesGoal kcal',
              color: AppColors.neonOrange, // Kalori için turuncu renk.
              icon: Icons.local_fire_department_rounded, // Ateş ikonu.
            ),
          ),
        ],
      ),
    );
  }
}

class _StatMetric extends StatelessWidget { // Tek bir istatistik sütununu (İkon + Değer + Başlık + Hedef) çizen tekrar kullanılabilir özel widget.
  final String label;
  final String value;
  final String goalText;
  final Color color;
  final IconData icon;

  const _StatMetric({
    required this.label,
    required this.value,
    required this.goalText,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column( // Elemanları dikeyde ortalayarak alt alta dizer.
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value, // Örn: '45 dk' veya '320 kcal'.
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label, // Örn: 'Aktif Süre'.
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        Text(
          goalText, // Örn: 'Hedef: 45 dk'.
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }
}

// ÇALIŞMA MANTIĞI:
// WorkoutSummaryCard toplam dakika ve kalori değerlerini alır -> Row içinde iki adet _StatMetric widget'ını Expanded ile eşit genişlikte yerleştirir
// -> Sol tarafta yeşil kronometre ile süreyi, sağ tarafta turuncu ateş ikonu ile kaloriyi gösterir.

// AYNI KODU İKİ KEZ YAZMAK : Hem süre hem kalori için ayrı ayrı Column, Icon, Text blokları yazmak kodu şişirir ve bakımı zorlaştırır
//  VS
// ÖZEL ALT WIDGET (_StatMetric) OLUŞTURMAK : Tasarımı bir kez tanımlayıp sadece değişen verileri (label, value, color, icon) parametre olarak geçmek temiz kod (Clean Code) sağlar
