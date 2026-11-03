// -bu kod bloğunda kullanıcının eklediği son su kaydını gösteren ve yanlış eklemeleri tek tıkla geri almayı (Undo) sağlayan WaterUndoSection widget'ı anlatılıyor.-
// SizedBox.shrink(): Boyutu 0x0 olan tamamen görünmez boş bir widget. Bir koşul sağlanmadığında (Örn: geçmiş listesi boşken) ekranda hiçbir şey göstermemek için kullanılır.
// history.last: Bir listedeki en son elemanı (en güncel eklenen kaydı) getiren Dart liste özelliği.

import 'package:flutter/material.dart'; // Flutter UI bileşenleri.
import '../../../../core/constants/app_colors.dart'; // Renk sabitleri.
import '../models/water_entry_model.dart'; // Su kaydı modeli.

/// Son Su Tüketimi ve Geri Alma (Undo) Butonu Widget'ı (Temaya Duyarlı)
class WaterUndoSection extends StatelessWidget {
  final List<WaterEntryModel> history; // İçilen suların geçmiş listesi.
  final VoidCallback onUndo; // 'Geri Al' butonuna basıldığında çalışacak fonksiyon.

  const WaterUndoSection({
    super.key,
    required this.history,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) { // Eğer henüz hiç su eklenmemişse (liste boşsa):
      return const SizedBox.shrink(); // Ekranda boşluk bile kaplamayan görünmez widget döndür.
    }

    final lastEntry = history.last; // Listedeki son eklenen su kaydını alır. (DİKKAT: Liste boşken .last çağrılırsa StateError verir, bu yüzden üstteki isEmpty kontrolü ŞARTTIR).
    final cyan = AppColors.cyanOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLightOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorderOf(context)),
      ),
      child: Row( // Onay ikonu, son eklenen su bilgisi ve Geri Al butonunu yan yana dizer.
        children: [
          Icon(Icons.check_circle_rounded, color: cyan, size: 24), // Sol taraftaki mavi onay ikonu.
          const SizedBox(width: 12),
          Expanded( // Ortadaki yazı alanının kalan tüm boşluğu doldurmasını sağlar (butonu en sağa iter).
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Son Eklenen: +${lastEntry.amountMl} ml', // Örn: 'Son Eklenen: +200 ml'.
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryOf(context),
                    fontSize: 14,
                  ),
                ),
                Text(
                  lastEntry.label, // Örn: 'Bardak (200ml)'.
                  style: TextStyle(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon( // Sağ taraftaki turuncu çerçeveli 'Geri Al' butonu.
            onPressed: onUndo, // Tıklandığında üst widget'taki _handleUndo metodunu tetikler.
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceOf(context),
              foregroundColor: AppColors.neonOrange, // İkon ve yazı rengini dikkat çekici neon turuncu yapar.
              side: const BorderSide(color: AppColors.neonOrange), // Turuncu kenarlık.
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: const Icon(Icons.undo_rounded, size: 18),
            label: const Text('Geri Al', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// history listesi kontrol edilir -> Boşsa SizedBox.shrink() ile gizlenir -> Doluysa history.last ile son kayıt alınır
// -> Miktar ve etiket ekrana yazılır -> Kullanıcı 'Geri Al' butonuna basarsa onUndo() tetiklenir ve son kayıt silinir.

// VISIBILITY / OPACITY (0.0) : Widget'ı görünmez yapar ama bazen ağaçta veya ekranda hala yer kaplamaya devam edebilir
//  VS
// IF (ISEMPTY) RETURN SIZEDBOX.SHRINK() : Koşul sağlanmadığında widget'ı hiç oluşturmaz ve ekranda 0 piksel yer kaplar (en performanslı gizleme yöntemidir)
