// -bu kod bloğunda rozetler ekranının en üstünde yer alan, kazanılan rozet sayısını ve yatay ilerleme çubuğunu (LinearProgressIndicator) gösteren BadgeStatsHeader widget'ı anlatılıyor.-
// LinearProgressIndicator: 0.0 ile 1.0 arasındaki bir değeri yatay doluluk çubuğu olarak görselleştiren Material widget'ı.
// MainAxisAlignment.spaceBetween: Row içindeki ilk elemanı en sola, son elemanı en sağa yaslayarak aralarındaki boşluğu maksimuma çıkaran hizalama.

import 'package:flutter/material.dart'; // Flutter UI kütüphanesi.
import '../../../../core/constants/app_colors.dart'; // Renk sabitleri.

/// Rozet İlerleme Başlık Kartı (Temaya Duyarlı)
class BadgeStatsHeader extends StatelessWidget {
  final int unlockedCount; // Kazanılmış rozet sayısı.
  final int totalCount; // Toplam rozet sayısı.
  final double progress; // İlerleme oranı (0.0 - 1.0 arası).

  const BadgeStatsHeader({
    super.key,
    required this.unlockedCount,
    required this.totalCount,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final gold = AppColors.goldOf(context); // Aktif temaya göre altın sarısı vurgu rengi.

    return Container(
      padding: const EdgeInsets.all(20), // Kartın içinden her yönden 20 piksel boşluk.
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context), // Kartın arka plan yüzey rengi.
        borderRadius: BorderRadius.circular(16), // Köşeleri 16 piksel yuvarlatır.
        border: Border.all(color: AppColors.surfaceBorderOf(context)), // Kart çerçevesi.
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alt alta dizilen elemanları sola hizalar.
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Başlığı sola, '2 / 5' sayacını en sağa yaslar.
            children: [
              Text(
                'Kazanılan Rozetler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              Text(
                '$unlockedCount / $totalCount', // Örn: '2 / 5' şeklinde ilerleme metni.
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Metin satırı ile ilerleme çubuğu arasına 12 piksel dikey boşluk.
          ClipRRect( // İlerleme çubuğunun köşelerini yuvarlatmak için kırpma widget'ı.
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator( // Yatay ilerleme çubuğu.
              value: progress, // Doluluk oranı (Örn: 0.4 -> %40 dolu).
              minHeight: 10, // Çubuğun dikey kalınlığı (10 piksel).
              backgroundColor: AppColors.surfaceBorderOf(context), // Çubuğun henüz dolmamış arka plan rengi.
              valueColor: AlwaysStoppedAnimation<Color>(gold), // Çubuğun dolan kısmının rengi (sabit altın sarısı).
            ),
          ),
        ],
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// BadgeView'dan unlockedCount, totalCount ve progress değerleri gelir -> Üst satırda 'Kazanılan Rozetler' ve 'X / Y' yazdırılır
// -> Alt satırda LinearProgressIndicator verilen progress oranına göre altın sarısı renkte doldurulur.

// LINEARPROGRESSINDICATOR : İlerlemeyi düz yatay bir şerit/çubuk üzerinde gösterir (dar başlık kartları için idealdir)
//  VS
// CIRCULARPROGRESSINDICATOR : İlerlemeyi dairesel bir halka üzerinde gösterir (ana odak kartları ve sayaçlar için idealdir)
