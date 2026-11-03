// -bu kod bloğunda tek bir rozetin kilitli veya kazanılmış (açık) durumuna göre renk, çerçeve, parlama (glow) ve ikon değiştiren BadgeCard widget'ı anlatılıyor.-
// switch - case: Bir değişkenin (iconName) alabileceği farklı değerlere göre hangi işlemin/ikonun seçileceğini belirleyen karar yapısı.
// BoxShadow: Kutunun arkasına gölge veya neon parlama (glow) efekti eklemek için kullanılan sınıf.
// TextOverflow.ellipsis: Metin kutuya sığmadığında taşma hatası (overflow) vermek yerine metnin sonuna üç nokta (...) koyarak kesen özellik.

import 'package:flutter/material.dart'; // Flutter görsel bileşenleri.
import '../../../../core/constants/app_colors.dart'; // Dinamik tema renkleri.
import '../models/badge_model.dart'; // BadgeModel veri sınıfı.

/// Tekil Rozet Kartı Widget'ı (Temaya Duyarlı)
class BadgeCard extends StatelessWidget {
  final BadgeModel badge; // Kartın göstereceği rozet verisi.

  const BadgeCard({
    super.key,
    required this.badge,
  });

  IconData _resolveIcon(String iconName) { // Modelde String olarak tutulan ikon adını gerçek Flutter IconData nesnesine dönüştüren yardımcı metot.
    switch (iconName) { // iconName değerini kontrol et:
      case 'water_drop':
        return Icons.water_drop_rounded; // Su damlası ikonu.
      case 'verified':
        return Icons.verified_rounded; // Onay/Şampiyonluk rozeti ikonu.
      case 'fitness_center':
        return Icons.fitness_center_rounded; // Dambıl ikonu.
      case 'local_fire_department':
        return Icons.local_fire_department_rounded; // Ateş/Kalori ikonu.
      case 'military_tech':
      default: // Yukarıdakilerden hiçbiri değilse (varsayılan olarak) madalya ikonu döndür.
        return Icons.military_tech_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked; // Rozet açık mı? (true / false).
    final gold = AppColors.goldOf(context); // Temaya uygun altın rengi.
    final border = AppColors.surfaceBorderOf(context); // Kilitli durum için standart çerçeve rengi.
    final isDark = AppColors.isDark(context); // Karanlık mod kontrolü.

    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.surfaceLightOf(context) : AppColors.surfaceOf(context), // Rozet açıksa daha aydınlık/vurgulu yüzey, kilitliyse standart yüzey rengi.
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? gold : border, // Açıksa altın sarısı çerçeve, kilitliyse soluk gri çerçeve.
          width: isUnlocked ? 1.5 : 1, // Açıksa çerçeveyi biraz daha kalın (1.5 piksel) yap.
        ),
        boxShadow: isUnlocked // Rozet açıksa altın rengi parlama (glow) gölgesi ekle, kilitliyse gölge verme (null).
            ? [
                BoxShadow(
                  color: isDark ? AppColors.neonGoldGlow : const Color(0x22FFD700), // Karanlık ve aydınlık moda uygun saydam altın parlaması.
                  blurRadius: 10, // Gölgenin dağılma/yumuşaklık yarıçapı.
                  offset: const Offset(0, 3), // Gölgeyi yatayda 0, dikeyde 3 piksel aşağı kaydırır.
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // İçeriği dikeyde kartın ortasına hizalar.
        children: [
          _BadgeIcon( // Yuvarlak ikon kutusu alt widget'ı.
            icon: _resolveIcon(badge.iconName),
            isUnlocked: isUnlocked,
          ),
          const SizedBox(height: 10),
          Text(
            badge.title, // Rozet başlığı.
            textAlign: TextAlign.center,
            maxLines: 1, // Başlık en fazla 1 satır olabilir.
            overflow: TextOverflow.ellipsis, // Sığmazsa '...' ile kısalt.
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isUnlocked
                  ? AppColors.textPrimaryOf(context) // Açıksa parlak/net ana metin rengi.
                  : AppColors.textMutedOf(context), // Kilitliyse soluk (muted) metin rengi.
            ),
          ),
          const SizedBox(height: 4),
          Text(
            badge.description, // Rozet açıklaması.
            textAlign: TextAlign.center,
            maxLines: 2, // Açıklama en fazla 2 satır olabilir.
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondaryOf(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget { // Rozetin ortasındaki dairesel ikon alanını çizen alt widget.
  final IconData icon;
  final bool isUnlocked;

  const _BadgeIcon({
    required this.icon,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final gold = AppColors.goldOf(context);
    final isDark = AppColors.isDark(context);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Kutuyu tam daire şeklinde yapar.
        color: isUnlocked
            ? (isDark ? AppColors.neonGoldGlow : const Color(0x25FFD700)) // Açıksa altın parlamalı zemin.
            : AppColors.surfaceBorderOf(context), // Kilitliyse gri zemin.
      ),
      child: Icon(
        icon,
        size: 26,
        color: isUnlocked ? gold : AppColors.textMutedOf(context), // Açıksa altın ikonu, kilitliyse soluk gri ikon.
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// BadgeCard bir BadgeModel alır -> _resolveIcon() ile String isimden gerçek ikonu bulur
// -> badge.isUnlocked true ise altın çerçeve, parlak gölge ve canlı renkler uygular / false ise soluk ve gölgesiz çizer.

// IF - ELSE ZİNCİRİ : Çok sayıda sabit metin karşılaştırmasında kodu uzatır ve okunabilirliği düşürür
//  VS
// SWITCH - CASE : Tek bir değişkenin ('iconName') birden fazla sabit değerle eşleşmesini temiz, hızlı ve okunaklı şekilde yönetir
