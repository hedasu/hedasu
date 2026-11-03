// -bu kod bloğunda kazanılan ve kilitli olan tüm rozetlerin istatistik başlığı ve 2 sütunlu ızgara (GridView) halinde ekranda gösterildiği BadgeView arayüzü anlatılıyor.-
// GridView.builder: Elemanları satır ve sütunlar halinde (ızgara/tablo düzeninde) çizen widget.
// shrinkWrap & NeverScrollableScrollPhysics: Bir ListView (kaydırılabilir liste) içine başka bir kaydırılabilir GridView koyduğumuzda, iki kaydırma alanının çakışmaması için içteki GridView'ın kendi kaydırmasını kapatıp boyunu içeriğine göre sarmalama tekniği.
// SliverGridDelegateWithFixedCrossAxisCount: Izgarada yan yana kaç sütun (crossAxisCount) olacağını ve aralarındaki boşlukları belirleyen düzenleyici.

import 'package:flutter/material.dart'; // Flutter UI bileşenleri.
import '../../../../core/constants/app_colors.dart'; // Renk sabitleri.
import '../controllers/badge_controller.dart'; // Rozet durum kontrolcüsü.
import '../models/badge_model.dart'; // Rozet veri modeli.
import '../widgets/badge_card.dart'; // Tekil rozet kartı widget'ı.
import '../widgets/badge_stats_header.dart'; // Üstteki ilerleme çubuklu özet kartı widget'ı.

/// Rozet Vitrini Görünümü (Stateless & ValueListenableBuilder)
class BadgeView extends StatelessWidget { // Durumu BadgeController üzerinden dinlediği için StatelessWidget kullanılır.
  final BadgeController controller;

  const BadgeView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<BadgeModel>>( // controller.badges listesini dinler, bir rozet açıldığında ekranı otomatik yeniler.
      valueListenable: controller.badges,
      builder: (context, badgeList, _) { // badgeList: O anki güncel List<BadgeModel>.
        final unlocked = controller.unlockedCount; // Açılan rozet sayısı.
        final total = controller.totalCount; // Toplam rozet sayısı.
        final progress = controller.progress; // İlerleme oranı (0.0 - 1.0).

        return ListView( // Tüm sayfanın dikey olarak kaydırılabilmesini sağlar.
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            BadgeStatsHeader( // Üst kısımdaki "Kazanılan Rozetler 2 / 5" ilerleme kartı.
              unlockedCount: unlocked,
              totalCount: total,
              progress: progress,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tüm Rozetler', // Bölüm başlığı.
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _BadgeGrid(badges: badgeList), // Rozetleri 2'li sütunlar halinde dizen alt widget.
          ],
        );
      },
    );
  }
}

class _BadgeGrid extends StatelessWidget { // build() metodunu kısa ve temiz tutmak için ayrılmış özel (private) ızgara widget'ı.
  final List<BadgeModel> badges;

  const _BadgeGrid({required this.badges});

  @override
  Widget build(BuildContext context) {
    return GridView.builder( // Listedeki eleman sayısı kadar dinamik ızgara kutusu oluşturur.
      shrinkWrap: true, // ÖNEMLİ: GridView'ın sonsuz yükseklik istemesini engeller, sadece içindeki rozetlerin kapladığı yer kadar yüksekliğe bürünmesini sağlar.
      physics: const NeverScrollableScrollPhysics(), // GridView'ın kendi başına kaydırılmasını kapatır; böylece dıştaki ana ListView ile birlikte tek parça halinde kayar.
      itemCount: badges.length, // Çizilecek toplam kart sayısı.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( // Sabit sütun sayılı ızgara düzeni.
        crossAxisCount: 2, // Yan yana 2 rozet kartı gösterilir.
        crossAxisSpacing: 12, // Yan yana olan kartlar arasındaki yatay boşluk (12 piksel).
        mainAxisSpacing: 12, // Alt alta olan kartlar arasındaki dikey boşluk (12 piksel).
        childAspectRatio: 0.95, // Kartların genişlik / yükseklik oranı (0.95: yüksekliği genişliğinden çok az daha uzun, kareye yakın).
      ),
      itemBuilder: (context, index) { // Her bir sıradaki (index) rozet için çalışır ve BadgeCard döndürür.
        return BadgeCard(badge: badges[index]);
      },
    );
  }
}

// ÇALIŞMA MANTIĞI:
// BadgeView açılır -> ValueListenableBuilder controller.badges'i dinler -> Üstte BadgeStatsHeader çizilir
// -> Altta _BadgeGrid içinde GridView.builder çalışır -> Her bir BadgeModel için BadgeCard oluşturulup 2 sütunlu vitrinde gösterilir.

// LISTVIEW : Elemanları tek sütunda alt alta dizer
//  VS
// GRIDVIEW : Elemanları hem satır hem sütun kullanarak çoklu ızgara (vitrin/galeri) düzeninde dizer
