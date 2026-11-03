// -bu dosyada tek bir başarı rozetini görselleştiren BadgeCard bileşeni ve rozetin kilit durumuna (isUnlocked) göre koşullu (conditional) neon stil değişimi anlatılıyor.-
// LinearProgressIndicator : Yatay bir çubuk üzerinde 0.0 (%0) ile 1.0 (%100) arasındaki ilerleme durumunu görselleştiren Material bileşenidir.
// AlwaysStoppedAnimation<Color> : ProgressIndicator'ın renk parametresi (`valueColor`) animasyonlu bir renk nesnesi beklediği için, sabit bir rengi animasyonsuz olarak sarmalayıp vermemizi sağlar.
// Expanded : Row veya Column içinde kendisinden önceki/sonraki sabit boyutlu elemanlardan geriye kalan tüm boş alanı kaplayan esnek kutudur.

import 'package:flutter/material.dart'; // Flutter görsel bileşenleri.
import '../../../core/constants/app_colors.dart'; // Neon ve koyu tema renk sabitleri.
import '../models/badge_item.dart'; // Rozet bilgilerini taşıyan BadgeItem modeli.

/// Tek bir başarı rozetini temsil eden kart bileşeni.
class BadgeCard extends StatelessWidget { // StatelessWidget : Sadece dışarıdan gelen `badge` verisini ekrana çizer, kendi içinde durum değiştirmez.
  const BadgeCard({
    super.key,
    required this.badge, // Gösterilecek olan rozet verisi (BadgeItem).
  });

  final BadgeItem badge; // final : Kartın çizeceği rozet modeli.

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked; // Kodun okunabilirliğini artırmak için kilit durumunu yerel bir değişkene alırız (true: Kazanıldı, false: Kilitli).

    return Container( // Kartın ana dış kapsayıcısı.
      padding: const EdgeInsets.all(16), // Kartın iç kenarlarından her yönde 16 piksel boşluk.
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.surface : AppColors.surfaceVariant.withValues(alpha: 0.35), // Rozet kazanıldıysa tam koyu yüzey rengi, kilitliyse %35 opaklıkta soluk yüzey rengi.
        borderRadius: BorderRadius.circular(20), // Kart köşelerini 20 birim yuvarlatır.
        border: Border.all(
          color: isUnlocked ? AppColors.neonLime.withValues(alpha: 0.7) : AppColors.cardBorder, // Rozet kazanıldıysa çerçeveyi %70 opaklıkta parlak Neon Lime yapar, kilitliyse standart gri çerçeve.
          width: 1.2, // Çerçeve kalınlığı.
        ),
      ),
      child: Row( // Sol taraftaki yuvarlak emoji kutusu ile sağ taraftaki metin/ilerleme alanını yan yana dizer.
        children: [
          Container( // Sol taraftaki dairesel emoji ikonu alanı.
            width: 52,
            height: 52,
            alignment: Alignment.center, // Emojiyi dairenin tam ortasına hizalar.
            decoration: BoxDecoration(
              color: isUnlocked
                  ? AppColors.neonLime.withValues(alpha: 0.15) // Kazanıldıysa hafif fosforlu yeşil hale.
                  : AppColors.surfaceVariant, // Kilitliyse koyu gri daire.
              shape: BoxShape.circle, // BoxShape.circle : Kutuyu tam daire şekline sokar.
            ),
            child: Text(
              badge.iconEmoji, // Rozetin emojisi (💧, 🔥, 👑 vb.).
              style: TextStyle(
                fontSize: 26,
                color: isUnlocked ? null : Colors.grey, // Emoji rengi (kilitliyse gri tonlama).
              ),
            ),
          ),
          const SizedBox(width: 14), // Dairesel ikon ile sağdaki yazılar arasına 14 piksel yatay boşluk.
          Expanded( // Expanded : Sağ taraftaki yazı ve ilerleme çubuğunun kalan tüm yatay alanı doldurmasını sağlar (taşmayı önler).
            child: Column( // Başlık satırı, açıklama ve ilerleme çubuğunu alt alta dizer.
              crossAxisAlignment: CrossAxisAlignment.start, // Yazıları sola hizalar.
              children: [
                Row( // Üst satır : Rozet başlığı (solda) ve Kazanıldı/Kilitli etiketi (sağda).
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // İki elemanı satırın en soluna ve en sağına iter.
                  children: [
                    Text(
                      badge.title, // Rozet adı.
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800, // Extra-bold.
                        color: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary, // Açıldıysa parlak beyaz, kilitliyse ikincil gri.
                      ),
                    ),
                    _buildStatusChip(isUnlocked), // Sağ üstteki küçük durum rozetini ("Kazanıldı" veya "Kilitli") oluşturan yardımcı metot.
                  ],
                ),
                const SizedBox(height: 4), // Başlık ile açıklama arasına 4 piksel boşluk.
                Text(
                  badge.description, // Rozetin nasıl kazanılacağını anlatan açıklama.
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8), // Açıklama ile ilerleme çubuğu arasına 8 piksel boşluk.
                Row( // Alt satır : İlerleme çubuğu (solda uzayan) ve gereksinim metni (sağda).
                  children: [
                    Expanded( // İlerleme çubuğunun metinden geriye kalan tüm yatay alanı kaplamasını sağlar.
                      child: ClipRRect( // İlerleme çubuğunun köşelerini yuvarlatmak için kırpar.
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator( // Yatay ilerleme göstergesi.
                          value: badge.progress, // 0.0 ile 1.0 arasındaki tamamlanma oranı.
                          minHeight: 5, // Çubuğun dikey kalınlığı (5 piksel).
                          backgroundColor: AppColors.surfaceVariant, // Dolmayan kısmın arka plan rengi.
                          valueColor: AlwaysStoppedAnimation<Color>( // Dolan kısmın rengi:
                            isUnlocked ? AppColors.neonLime : AppColors.neonCyan, // Tamamlandıysa Neon Lime, devam ediyorsa Neon Cyan.
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // Çubuk ile sağdaki durum yazısı arasına 10 piksel boşluk.
                    Text(
                      badge.requirementText, // Örn: "1500 / 2500 ml" veya "Tamamlandı".
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isUnlocked ? AppColors.neonLime : AppColors.textMuted, // Kazanıldıysa yeşil, değilse soluk gri.
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isUnlocked) { // _buildStatusChip : build metodunu şişirmemek için ayrılmış, sağ üstteki durum etiketini çizen private yardımcı metot.
    if (isUnlocked) { // Eğer rozet kazanıldıysa:
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.neonLime.withValues(alpha: 0.15), // Yarı saydam fosforlu yeşil zemin.
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Kazanıldı',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.neonLime, // Parlak yeşil yazı.
          ),
        ),
      );
    }

    return Container( // Eğer rozet henüz KİLİTLİYSE:
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant, // Koyu gri zemin.
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Kilitli',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted, // Soluk gri yazı.
        ),
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI: BadgeView listedeki her eleman için BadgeCard(badge: ...) çağırır -> isUnlocked durumu kontrol edilir -> Renkler (neonLime vs textMuted) ve ilerleme çubuğu (badge.progress) duruma göre boyanarak ekrana çizilir.

// YARDIMCI METOT (`_buildStatusChip`) : Sadece o kartın içinde kullanılan küçük bir UI parçasını ana build metodundan ayırarak okunabilirliği artırır.
//  VS
// AYRI WIDGET SINIFI (`BadgeCard`) : Kendi başına bağımsız bir bileşendir, başka dosyalardan çağrılabilir ve Flutter'ın widget ağacında ayrı bir düğüm olarak optimize edilir.
