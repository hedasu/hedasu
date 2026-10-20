import 'package:flutter/material.dart';

/// Rezervasyon Akışı Adım İlerleme Göstergesi (ReservationStepIndicator)
///
/// Rezervasyon akışında (Tarih/Saat -> Güvence & Ek Hizmetler -> Sürücü & Ehliyet -> Ödeme)
/// kullanıcının hangi aşamada olduğunu lineer ilerleme çubuğu (LinearProgressIndicator)
/// ve adım başlığıyla gösterir.
class ReservationStepIndicator extends StatelessWidget {
  const ReservationStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  });

  /// Mevcut adım indeksi (0 tabanlı)
  final int currentStep;

  /// Toplam adım sayısı
  final int totalSteps;

  /// Adımların Türkçe başlık listesi
  final List<String> stepTitles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // İlerleme oranı (0.0 ile 1.0 arası)
    final double progress = (currentStep + 1) / totalSteps;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 'Adım X / Y' bilgisi
              Text(
                'Adım ${currentStep + 1} / $totalSteps',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC0B09A),
                ),
              ),
              // Seçili adımın adı
              Text(
                stepTitles[currentStep],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // İlerleme çubuğu
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
            minHeight: 4,
          ),
        ],
      ),
    );
  }
}
