// -bu dosyada Rozetler ekranının en üstünde yer alan, kazanılan toplam rozet sayısını ve genel başarı yüzdesini özetleyen BadgeSummaryHeader kartı anlatılıyor.-
// round() : Ondalıklı bir sayıyı (double) kendisine en yakın tam sayıya (int) yuvarlar (Örn: `66.6.round()` -> `67`).
// BoxShadow : Bir kutunun etrafına neon parlama (glow) veya derinlik gölgesi eklemek için kullanılır.

import 'package:flutter/material.dart'; // Flutter Material bileşenleri.
import '../../../core/constants/app_colors.dart'; // Uygulama renk sabitleri.

/// Rozet kazanım durumunu ve genel başarı oranını özetleyen kart.
class BadgeSummaryHeader extends StatelessWidget { // StatelessWidget : Dışarıdan aldığı istatistik verilerini görselleştiren durumsuz bileşen.
  const BadgeSummaryHeader({
    super.key,
    required this.unlockedCount, // Kazanılan (kilidi açılan) rozet sayısı.
    required this.totalCount, // Toplam rozet sayısı.
    required this.ratio, // 0.0 ile 1.0 arasındaki genel tamamlanma oranı.
  });

  final int unlockedCount; // final : Açılan rozet adedi.
  final int totalCount; // final : Toplam rozet adedi.
  final double ratio; // final : İlerleme çubuğu ve yüzde hesabı için oran.

  @override
  Widget build(BuildContext context) {
    final percentage = (ratio * 100).round(); // 0.0-1.0 arasındaki oranı 100 ile çarpıp tam sayı yüzdesine (0-100) çevirir (Örn: 0.4 * 100 = %40).

    return Container( // Üst özet kartının dış kapsayıcısı.
      padding: const EdgeInsets.all(22), // Her yönden 22 piksel iç boşluk.
      decoration: BoxDecoration(
        color: AppColors.surface, // Kart yüzey rengi.
        borderRadius: BorderRadius.circular(24), // Köşeleri 24 birim yuvarlatır.
        border: Border.all(
          color: unlockedCount > 0 ? AppColors.neonLime : AppColors.cardBorder, // En az 1 rozet kazanıldıysa çerçeveyi Neon Lime yapar, hiç kazanılmadıysa koyu gri bırakır.
          width: 1.5, // Çerçeve kalınlığı.
        ),
        boxShadow: unlockedCount > 0 // En az 1 rozet kazanıldıysa kartın etrafına neon yeşil parlama (glow) efekti ekler, yoksa `null` (gölgesiz) geçer.
            ? [
                BoxShadow(
                  color: AppColors.neonLime.withValues(alpha: 0.12), // %12 opaklıkta fosforlu yeşil ışık.
                  blurRadius: 18, // Işığın yumuşak dağılma mesafesi.
                  spreadRadius: 1, // Işığın karttan dışarı taşma miktarı.
                ),
              ]
            : null,
      ),
      child: Column( // Üstteki bilgi satırı ile alttaki ilerleme çubuğunu alt alta dizer.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row( // Sol grup (kupa ikonu + başlıklar) ile sağdaki büyük yüzde yazısını yan yana dizer.
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Sol grubu en sola, yüzdeyi en sağa yaslar.
            children: [
              Row( // Kupa ikonu ile "Rozet Odası" yazılarını yan yana tutan iç Row.
                children: [
                  Container( // Kupa ikonunun etrafındaki dairesel fosforlu arka plan.
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.neonLime.withValues(alpha: 0.15),
                      shape: BoxShape.circle, // Dairesel şekil.
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded, // Kupa (Trophy) ikonu.
                      color: AppColors.neonLime,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12), // İkon ile yazılar arasına 12 piksel yatay boşluk.
                  Column( // "Rozet Odası" başlığı ve altındaki sayaç metnini alt alta dizer.
                    crossAxisAlignment: CrossAxisAlignment.start, // Yazıları sola hizalar.
                    children: [
                      const Text(
                        'Rozet Odası',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$unlockedCount / $totalCount Rozet Kazanıldı', // String interpolation ($değişken) ile dinamik sayaç metni.
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '%$percentage', // Sağ taraftaki büyük tamamlanma yüzdesi (Örn: "%40").
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900, // En kalın (Black) font ağırlığı.
                  color: AppColors.neonLime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Üst satır ile ilerleme çubuğu arasına 16 piksel dikey boşluk.
          ClipRRect( // İlerleme çubuğunun köşelerini 8 birim yuvarlatarak kırpar.
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator( // Genel rozet kazanım ilerleme çubuğu.
              value: ratio, // 0.0 ile 1.0 arasındaki oran.
              minHeight: 8, // Çubuk yüksekliği : 8 piksel.
              backgroundColor: AppColors.surfaceVariant, // Dolmayan kısmın rengi.
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonLime), // Dolan kısmın sabit Neon Lime rengi.
            ),
          ),
        ],
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI: BadgeView'dan unlockedCount, totalCount ve ratio gelir -> percentage hesaplanır -> unlockedCount > 0 ise neon çerçeve ve gölge aktif edilir -> Kupa ikonu, sayaç ve LinearProgressIndicator ekrana çizilir.

// KOŞULLU GÖLGE (`unlockedCount > 0 ? [...] : null`) : Sadece başarı elde edildiğinde neon parlama ekleyerek kullanıcıya görsel ödül hissi (gamification) verir.
//  VS
// SABİT GÖLGE : Her durumda aynı görünür; kullanıcının başlangıç durumu ile başarı durumu arasındaki görsel farkı azaltır.
