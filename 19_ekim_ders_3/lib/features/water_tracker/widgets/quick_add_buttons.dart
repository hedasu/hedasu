// -bu kod bloğunda kullanıcının tek dokunuşla farklı miktarlarda (+200ml, +330ml, +500ml, +1000ml) su ekleyebilmesini sağlayan QuickAddButtons widget'ı anlatılıyor.-
// Callback Fonksiyon (void Function(int amount, String label)): Alt widget'tan (_QuickButton) üst widget'a (WaterTrackerView) tıklanan su miktarını ve etiketini göndermek için kullanılan fonksiyon parametresi.
// Expanded: Bir Row (satır) içindeki çocukların mevcut yatay genişliği eşit olarak paylaşmasını sağlayan esnek sarmalayıcı widget.

import 'package:flutter/material.dart'; // Flutter UI kütüphanesi.
import '../../../../core/constants/app_colors.dart'; // Dinamik tema renkleri.

/// Hızlı Su Ekleme Butonları (Temaya Duyarlı)
class QuickAddButtons extends StatelessWidget {
  final void Function(int amount, String label) onAddWater; // Butona basıldığında miktar (int) ve etiket (String) ile çağrılacak fonksiyon.

  const QuickAddButtons({
    super.key,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Başlığı sola hizalar.
      children: [
        Text(
          'Hızlı Su Ekle', // Bölüm başlığı.
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        const SizedBox(height: 12),
        Row( // 4 adet hızlı su ekleme butonunu yan yana dizer.
          children: [
            Expanded( // 1. Buton: 200 ml Bardak (Satırın 1/4 genişliğini alır).
              child: _QuickButton(
                amount: 200,
                label: 'Bardak',
                icon: Icons.local_drink_rounded,
                onTap: () => onAddWater(200, 'Bardak (200ml)'),
              ),
            ),
            const SizedBox(width: 8), // Butonlar arası 8 piksel yatay boşluk.
            Expanded( // 2. Buton: 330 ml Küçük Şişe.
              child: _QuickButton(
                amount: 330,
                label: 'K. Şişe',
                icon: Icons.water_drop_outlined,
                onTap: () => onAddWater(330, 'Küçük Şişe (330ml)'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded( // 3. Buton: 500 ml Spor Matarası.
              child: _QuickButton(
                amount: 500,
                label: 'Matara',
                icon: Icons.sports_gymnastics_rounded,
                onTap: () => onAddWater(500, 'Spor Matarası (500ml)'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded( // 4. Buton: 1000 ml (1 Litre) Sürahi.
              child: _QuickButton(
                amount: 1000,
                label: '1 Litre',
                icon: Icons.fitness_center_rounded,
                onTap: () => onAddWater(1000, 'Sürahi (1000ml)'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickButton extends StatelessWidget { // Tek bir hızlı ekleme butonunun görsel tasarımını tutan özel (private) widget. (Kod tekrarını önler).
  final int amount;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickButton({
    required this.amount,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cyan = AppColors.cyanOf(context); // Aktif temaya uygun su mavisi rengi.

    return InkWell( // Tıklama algılayıcı ve su dalgası (ripple) efekti.
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context), // Kart yüzey rengi.
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceBorderOf(context)),
        ),
        child: Column( // İkon, miktar (+200) ve etiketi (Bardak) alt alta dizer.
          children: [
            Icon(icon, color: cyan, size: 22),
            const SizedBox(height: 4),
            Text(
              '+$amount', // Örn: '+200'.
              style: TextStyle(
                color: cyan,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              label, // Örn: 'Bardak'.
              style: TextStyle(
                color: AppColors.textSecondaryOf(context),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// Kullanıcı _QuickButton'a dokunur -> InkWell onTap'i tetikler -> onAddWater(amount, label) çağrılır
// -> Üst widget'taki WaterTrackerView bu veriyi alıp controller.addWater() metoduna iletir.

// VOIDCALLBACK (void Function()) : Hiçbir parametre almayan basit tıklama olayları için kullanılır
//  VS
// PARAMETRELİ CALLBACK (void Function(int, String)) : Tıklanan öğenin verilerini (miktar ve etiket) üst katmana taşımak için kullanılır
