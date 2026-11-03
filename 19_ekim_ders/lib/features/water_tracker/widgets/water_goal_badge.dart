// -bu dosyada günlük su hedefi tamamlandığında parlayan "ROZET KAZANILDI!" kartını, henüz tamamlanmadığında ise kalan su miktarını gösteren kilitli rozet bandını (WaterGoalBadge) anlatılıyor.-
// Koşullu Render (Conditional Rendering) : `build` metodu içinde bir `bool` duruma (`isAchieved`) bakarak tamamen farklı iki görsel tasarımdan (`_buildUnlockedBadge` veya `_buildLockedBadge`) birini döndürme tekniğidir.

import 'package:flutter/material.dart'; // Flutter Material bileşenleri.
import '../../../core/constants/app_colors.dart'; // Uygulama renk sabitleri.

/// Hedef tamamlandığında kullanıcıya verilen başarı rozeti widget'ı.
class WaterGoalBadge extends StatelessWidget { // StatelessWidget : Sadece dışarıdan aldığı hedef başarı durumuna göre uygun rozet görünümünü çizer.
  const WaterGoalBadge({
    super.key,
    required this.isAchieved, // Günlük su hedefi tamamlandı mı? (true: Kazanıldı, false: Kilitli).
    required this.badgeTitle, // Rozetin adı ('Hidrasyon Şampiyonu').
    required this.remainingMl, // Hedefe ulaşmak için geriye kalan su miktarı (ml).
  });

  final bool isAchieved; // final : Başarı durumu.
  final String badgeTitle; // final : Rozet başlığı.
  final int remainingMl; // final : Kalan ml miktarı.

  @override
  Widget build(BuildContext context) {
    if (isAchieved) { // Eğer kullanıcı günlük su hedefini tamamladıysa (isAchieved == true):
      return _buildUnlockedBadge(); // Neon yeşil parlayan ödül kartını döndür.
    }
    return _buildLockedBadge(); // Henüz tamamlamadıysa kilit ikonlu ve kalan miktarı yazan bilgi kartını döndür.
  }

  Widget _buildUnlockedBadge() { // _buildUnlockedBadge : Hedef başarıldığında gösterilen kutlama tasarımını oluşturur.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neonLime, width: 1.5), // Parlak Neon Lime çerçeve.
        boxShadow: [ // Kartın etrafına başarı hissini güçlendiren yeşil neon ışık (glow) yayar.
          BoxShadow(
            color: AppColors.neonLime.withValues(alpha: 0.2), // %20 opaklıkta yeşil parlama.
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row( // Solda madalya ikonu, sağda tebrik metinleri.
        children: [
          Container( // Madalya ikonunun dairesel arka planı.
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.neonLime.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.military_tech_rounded, // Madalya ikonu.
              color: AppColors.neonLime,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded( // Yazıların sağdaki alanı taşmadan doldurmasını sağlar.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ROZET KAZANILDI! 🏅',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.neonLime,
                    letterSpacing: 0.8, // Harf aralığını açarak vurguyu artırır.
                  ),
                ),
                Text(
                  badgeTitle, // 'Hidrasyon Şampiyonu'
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  'Tebrikler! Günlük su hedefini başarıyla tamamladın.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedBadge() { // _buildLockedBadge : Hedef henüz tamamlanmadığında kullanıcıyı motive eden kilitli tasarım.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.35), // Daha sönük, yarı saydam arka plan.
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.6)), // İnce soluk çerçeve.
      ),
      child: Row( // Solda kilit ikonu, sağda kalan su miktarı bilgisi.
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded, // Kilit ikonu.
              color: AppColors.textMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Günün Rozeti: $badgeTitle',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Rozeti açmak için $remainingMl ml daha su içmelisin.', // Kullanıcı her su eklediğinde `remainingMl` azalır ve buradaki sayı canlı olarak düşer.
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI: WaterTrackerView her güncellendiğinde isAchieved ve remainingMl değerlerini bu widget'a gönderir -> isAchieved false ise _buildLockedBadge() çalışır ve kalan ml yazılır -> Toplam su 2500 ml'ye ulaştığı anda isAchieved true olur -> _buildUnlockedBadge() devreye girer ve neon yeşil ödül kartı ekranda parlar.

// AYRI METOTLARLA KOŞULLU ÇİZİM (`_buildUnlockedBadge` / `_buildLockedBadge`) : İki durumun tasarımı birbirinden çok farklı olduğunda kodu iki ayrı metoda bölmek okunabilirliği çok temiz tutar.
//  VS
// TEK WIDGET İÇİNDE TERNARY (`isAchieved ? ... : ...`) : Sadece 1-2 özellik (örneğin sadece renk) değişiyorsa pratiktir, ancak tüm ikon, metin sayısı ve gölgeler değişiyorsa iç içe karmaşa yaratır.
