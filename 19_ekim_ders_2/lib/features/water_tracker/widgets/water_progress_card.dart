// -bu kod bloğunda günlük içilen su miktarını ve hedefe olan yüzdelik oranı neon parlamalı dairesel bir halka (CircularProgressIndicator) içinde gösteren WaterProgressCard widget'ı anlatılıyor.-
// Stack: Çocuk widget'ları üst üste bindiren düzen widget'ı. Burada dairesel ilerleme halkası en altta, damla ikonu ve mililitre yazıları ise tam ortasında (üst katmanda) yer alır.
// StrokeCap.round: Dairesel ilerleme çubuğunun başlangıç ve bitiş uçlarını yumuşatarak yuvarlak hatlı modern bir görünüm kazandırır.

import 'package:flutter/material.dart'; // Flutter UI bileşenleri.
import '../../../../core/constants/app_colors.dart'; // Renk sabitleri.

/// Dairesel Su İlerleme Kartı (Karanlık ve Aydınlık Uyumlu)
class WaterProgressCard extends StatelessWidget {
  final int currentWater; // Şu ana kadar içilen su (ml).
  final int dailyGoal; // Günlük hedef su miktarı (ml).

  const WaterProgressCard({
    super.key,
    required this.currentWater,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = dailyGoal > 0 ? (currentWater / dailyGoal).clamp(0.0, 1.0) : 0.0; // 0.0 ile 1.0 arasında ilerleme oranı (clamp ile %100'ü geçse bile halka taşmaz).
    final percentage = (ratio * 100).toInt(); // Oranı yüzdelik tam sayıya çevirir (Örn: 0.6 -> 60).
    final isDark = AppColors.isDark(context); // Karanlık mod kontrolü.

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceBorderOf(context)),
        boxShadow: [ // Kartın arkasına neon mavi parlama (glow) gölgesi verir.
          BoxShadow(
            color: isDark ? AppColors.neonCyanGlow : const Color(0x1500E5FF), // Aydınlık modda daha hafif (%8), karanlık modda daha belirgin (%20) mavi parlama.
            blurRadius: 18, // Gölgenin yayılma yumuşaklığı.
            offset: const Offset(0, 4), // Gölgeyi 4 piksel aşağı yönlendirir.
          ),
        ],
      ),
      child: Center(
        child: Stack( // Halkayı ve içindeki metinleri merkezde üst üste bindirir.
          alignment: Alignment.center,
          children: [
            _CircularProgress(ratio: ratio), // Alt katman: Dairesel doluluk halkası.
            _CenterProgressText( // Üst katman: Ortadaki damla ikonu, ml ve hedef yazıları.
              currentWater: currentWater,
              dailyGoal: dailyGoal,
              percentage: percentage,
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularProgress extends StatelessWidget { // Dairesel ilerleme halkasını çizen özel (private) widget.
  final double ratio;

  const _CircularProgress({required this.ratio});

  @override
  Widget build(BuildContext context) {
    final cyan = AppColors.cyanOf(context);
    return SizedBox( // CircularProgressIndicator varsayılan olarak küçük çizilir; SizedBox ile 190x190 piksel geniş bir daireye büyütülür.
      width: 190,
      height: 190,
      child: CircularProgressIndicator(
        value: ratio, // Doluluk oranı.
        strokeWidth: 14, // Halkanın kalınlığı (14 piksel).
        strokeCap: StrokeCap.round, // Halkanın uçlarını yuvarlatır.
        backgroundColor: AppColors.surfaceLightOf(context), // Halkanın dolmamış boş kısmının rengi.
        valueColor: AlwaysStoppedAnimation<Color>(cyan), // Halkanın dolan kısmının rengi.
      ),
    );
  }
}

class _CenterProgressText extends StatelessWidget { // Halkanın tam ortasında duran metin ve ikon grubu.
  final int currentWater;
  final int dailyGoal;
  final int percentage;

  const _CenterProgressText({
    required this.currentWater,
    required this.dailyGoal,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final cyan = AppColors.cyanOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min, // Dikeyde sadece yazıların kapladığı kadar yer tutar.
      children: [
        Icon(Icons.water_drop_rounded, color: cyan, size: 36), // Su damlası ikonu.
        const SizedBox(height: 6),
        Text(
          '$currentWater ml', // Güncel içilen miktar (Örn: '1200 ml').
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryOf(context),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Hedef: $dailyGoal ml (%$percentage)', // Hedef ve yüzde bilgisi (Örn: 'Hedef: 2500 ml (%48)').
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }
}

// ÇALIŞMA MANTIĞI:
// WaterProgressCard currentWater ve dailyGoal değerlerini alır -> ratio ve percentage hesaplanır
// -> Stack içinde önce 190x190 boyutunda _CircularProgress çizilir -> Tam merkezine _CenterProgressText yerleştirilir.

// ROW / COLUMN : Elemanları yan yana (X ekseni) veya alt alta (Y ekseni) birbirine değecek şekilde dizer
//  VS
// STACK : Elemanları üst üste (Z ekseni / derinlik) bindirir; bir görselin veya halkanın üzerine yazı/ikon yerleştirmek için kullanılır
