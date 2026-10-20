import 'package:flutter/material.dart';
import '../controller/profile_controller.dart';

/// otoVia Kiralama İstatistikleri Ekranı (StatisticsView)
///
/// Kullanıcının hesap geçmişindeki tamamlanan kiralama adedini, toplam kiralama
/// gün sayısını, kullanılan ve hak edilen indirim kuponlarını 2x2 şık kartlarla sergiler.
class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kiralama İstatistiklerim')),
      body: ListenableBuilder(
        listenable: profileController,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 1. Satır: Tamamlanan Kiralama & Kiralama Gün Sayısı
                Row(
                  children: [
                    _buildStatCard(context, 'Tamamlanan Kiralama', '${profileController.totalCompletedRentals}', Icons.done_all),
                    const SizedBox(width: 14),
                    _buildStatCard(context, 'Kiralama Gün Sayısı', '${profileController.totalRentalDays} Gün', Icons.calendar_today),
                  ],
                ),
                const SizedBox(height: 14),
                // 2. Satır: Kullanılan Kupon & Kazanılan Kupon
                Row(
                  children: [
                    _buildStatCard(context, 'Kullanılan Kupon', '${profileController.usedCouponsCount}', Icons.local_offer_outlined),
                    const SizedBox(width: 14),
                    _buildStatCard(context, 'Kazanılan Kupon', '${profileController.earnedCouponsCount}', Icons.stars_outlined),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Tekil bir istatistik kartı (ikon, büyük değer ve açıklama başlığı)
  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: const Color(0xFFC0B09A)),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
