import 'package:flutter/material.dart';
import '../controller/coupon_controller.dart';

/// Sadakat Kuponu İlerleme Kartı (CouponProgressCard)
///
/// Kullanıcıya "Her 3 kiralamada %20 indirim kuponu" kuralını hatırlatır,
/// mevcut kiralama adedine göre ilerleme çubuğunu ve bir sonraki kupon için
/// kaç kiralama kaldığını dinamik olarak gösterir.
class CouponProgressCard extends StatelessWidget {
  const CouponProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: couponController,
      builder: (context, _) {
        final progress = couponController.couponProgress;
        final needed = couponController.rentalsNeededForNextCoupon;
        final theme = Theme.of(context);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFC0B09A), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık ve yüzde göstergesi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sadakat Kuponu İlerlemesi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    '%${(progress * 100).toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC0B09A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Şampanya tonlu ilerleme çubuğu
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: const Color(0xFFC0B09A),
              ),
              const SizedBox(height: 10),
              // Kalan kiralama sayısı bilgilendirmesi
              Text(
                'Tamamlanan her 3 kiralama için %20 kupon kazanırsınız. Sonraki kupon için $needed kiralama kaldı!',
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        );
      },
    );
  }
}
