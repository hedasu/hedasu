// -bu dosyada Su Takip ekranının en üstünde yer alan, dairesel ilerleme halkasını (CircularProgressIndicator) ve içilen/hedeflenen su miktarını üst üste (Stack ile) gösteren WaterProgressCard bileşeni anlatılıyor.-
// Stack : Çocuklarını (children) Column gibi alt alta veya Row gibi yan yana dizmek yerine, Z ekseninde ÜST ÜSTE (katman katman) bindiren yerleşim widget'ıdır (Burada dairesel çubuğun tam ortasına su damlası ve ml yazısını yerleştirmek için kullanılmıştır).
// CircularProgressIndicator : 0.0 ile 1.0 arasındaki değeri dairesel bir halka olarak çizen ilerleme göstergesidir.
// StrokeCap.round : Dairesel ilerleme halkasının uçlarını küt (köşeli) bırakmak yerine yumuşakça yuvarlatır.

import 'package:flutter/material.dart'; // Flutter Material bileşenleri.
import '../../../core/constants/app_colors.dart'; // Uygulama renk sabitleri.

/// Günlük su tüketim ilerlemesini ve kalan miktarı gösteren neon gösterge kartı.
class WaterProgressCard extends StatelessWidget { // StatelessWidget : Dışarıdan aldığı ml ve oran değerlerini dairesel grafik olarak çizen durumsuz bileşen.
  const WaterProgressCard({
    super.key,
    required this.currentMl, // Şu ana kadar içilen su miktarı (ml).
    required this.goalMl, // Günlük su hedefi (2500 ml).
    required this.progressRatio, // 0.0 ile 1.0 arasındaki tamamlanma oranı.
    required this.isGoalAchieved, // Hedefe ulaşıldı mı? (Renk değişimi için).
  });

  final int currentMl; // final : Güncel ml.
  final int goalMl; // final : Hedef ml.
  final double progressRatio; // final : İlerleme oranı.
  final bool isGoalAchieved; // final : Başarı durumu.

  @override
  Widget build(BuildContext context) {
    return Container( // Kartın ana dış çerçevesi.
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isGoalAchieved ? AppColors.neonLime : AppColors.cardBorder, // Hedef tamamlandığında kart çerçevesi Neon Lime olur.
          width: 1.5,
        ),
        boxShadow: isGoalAchieved // Hedef tamamlandığında kartın arkasına yeşil neon parlama (glow) ekler.
            ? [
                BoxShadow(
                  color: AppColors.neonLime.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column( // Üstte dairesel halka (_buildProgressCircle), altta özet bilgi satırı (_buildGoalSummary).
        children: [
          _buildProgressCircle(context), // Dairesel göstergeyi çizen yardımcı metot.
          const SizedBox(height: 20),
          _buildGoalSummary(context), // Alt kısımdaki Yüzde ve Durum özetini çizen yardımcı metot.
        ],
      ),
    );
  }

  Widget _buildProgressCircle(BuildContext context) { // _buildProgressCircle : 180x180 boyutunda dairesel ilerleme halkası ve içindeki metinleri oluşturur.
    return SizedBox( // Halkaya sabit 180x180 piksel kare alan tanımlar.
      height: 180,
      width: 180,
      child: Stack( // Stack : 1. katmana dairesel çubuğu, 2. katmana (tam ortasına) ikon ve sayıları koyar.
        fit: StackFit.expand, // StackFit.expand : Altındaki CircularProgressIndicator'ın 180x180'lik alanı tamamen dolduracak şekilde genişlemesini sağlar (bu olmazsa halka küçük kalır).
        children: [
          CircularProgressIndicator( // 1. Katman (Alt) : Dairesel ilerleme çubuğu.
            value: progressRatio, // 0.0 (boş) ile 1.0 (tam dolu) arasındaki değer.
            strokeWidth: 14, // Halkanın çizgi kalınlığı : 14 piksel.
            backgroundColor: AppColors.surfaceVariant, // Halkanın henüz dolmamış kısmının koyu gri rengi.
            valueColor: AlwaysStoppedAnimation<Color>( // Halkanın dolan kısmının rengi:
              isGoalAchieved ? AppColors.neonLime : AppColors.neonCyan, // Hedefe ulaşıldıysa Neon Yeşil, devam ediyorsa Neon Mavi.
            ),
            strokeCap: StrokeCap.round, // Halka uçlarını yuvarlatarak modern bir görünüm verir.
          ),
          Center( // 2. Katman (Üst) : Halkanın tam merkezine su damlası, içilen ml ve hedef ml yazılarını yerleştirir.
            child: Column(
              mainAxisSize: MainAxisSize.min, // MainAxisSize.min : Column'un dikeyde tüm alanı kaplamak yerine sadece içindeki elemanlar kadar yer kaplamasını sağlar ki tam ortalansın.
              children: [
                Icon(
                  Icons.water_drop_rounded,
                  color: isGoalAchieved ? AppColors.neonLime : AppColors.neonCyan,
                  size: 32,
                ),
                const SizedBox(height: 4),
                Text(
                  '$currentMl', // İçilen miktar (Örn: "1500").
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  '/ $goalMl ml', // Hedef miktar (Örn: "/ 2500 ml").
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSummary(BuildContext context) { // _buildGoalSummary : Kartın altındaki "Yüzde" ve "Durum" sütunlarını yan yana gösterir.
    final percentage = (progressRatio * 100).round(); // Oranı 0-100 arası tam sayı yüzdesine çevirir.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // İki bilgi sütununu ve ortadaki ayırıcı çizgiyi dengeli dağıtır.
      children: [
        _buildInfoColumn('Yüzde', '%$percentage', AppColors.neonCyan), // Sol sütun : Yüzde bilgisi.
        Container(width: 1, height: 28, color: AppColors.cardBorder), // Ortadaki 1 piksel genişliğinde dikey ayırıcı çizgi (Divider).
        _buildInfoColumn( // Sağ sütun : Durum bilgisi.
          'Durum',
          isGoalAchieved ? 'Hedef Tamam!' : 'Devam Ediyor',
          isGoalAchieved ? AppColors.neonLime : AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value, Color valueColor) { // _buildInfoColumn : Küçük başlık ve altındaki renkli değeri çizen ortak yardımcı metot.
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// ÇALIŞMA MANTIĞI: WaterTrackerView'dan güncel ml ve progressRatio gelir -> Stack içinde CircularProgressIndicator halka oranını çizer, Center ise tam ortasına ml rakamını yazar -> Hedef tamamlandığında (isGoalAchieved == true) tüm mavi vurgular neon yeşile döner.

// STACK : Bileşenleri Z ekseninde üst üste bindirir (Örn: Dairesel grafik halkasının içine yazı yazmak veya resmin üzerine etiket koymak için kullanılır).
//  VS
// COLUMN / ROW : Bileşenleri Y (dikey) veya X (yatay) ekseninde birbirinin ardına (üst üste binmeden) dizer.
