// -bu dosyada gün içinde yapılan su ekleme ve azaltma kayıtlarını saatleriyle birlikte listeleyen veya henüz kayıt yoksa "boş durum (empty state)" gösteren WaterLogHistory bileşeni anlatılıyor.-
// Empty State (Boş Durum Tasarımı) : Bir liste henüz boşken (`logs.isEmpty`) ekranda bomboş karanlık bir alan bırakmak yerine, kullanıcıya durumu açıklayan şık bir ikon ve bilgilendirme metni gösterme UX (Kullanıcı Deneyimi) prensibidir.
// ListView.separated : Dinamik uzunluktaki bir listeyi ve her elemanın arasındaki boşluğu (`separatorBuilder`) oluşturan listeleyicidir.

import 'package:flutter/material.dart'; // Flutter Material bileşenleri.
import '../../../core/constants/app_colors.dart'; // Uygulama renk sabitleri.
import '../models/water_log.dart'; // Su kaydı veri modeli (WaterLog).

/// Günlük su tüketim geçmişini listeleyen widget.
class WaterLogHistory extends StatelessWidget { // StatelessWidget : Kendisine verilen `logs` listesini ekrana çizen ve silme tıklamalarını `onDeleteLog` ile üst katmana ileten bileşen.
  const WaterLogHistory({
    super.key,
    required this.logs, // Gösterilecek olan su kayıtları listesi.
    required this.onDeleteLog, // Bir kaydın sağındaki 'X' (sil) butonuna basıldığında kayıt ID'sini ileten callback.
  });

  final List<WaterLog> logs; // final : Su kayıtları listesi.
  final void Function(String logId) onDeleteLog; // final : Silinecek kaydın String ID'sini alan fonksiyon.

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) { // Eğer bugün henüz hiç su kaydı eklenmemişse (liste boşsa):
      return _buildEmptyState(); // Kullanıcıya "Henüz su tüketimi kaydedilmedi." kutusunu göster.
    }

    return ListView.separated( // Kayıt varsa listeyi oluştur:
      shrinkWrap: true, // Dıştaki SingleChildScrollView içinde kendi içeriği kadar yer kaplamasını sağlar.
      physics: const NeverScrollableScrollPhysics(), // Liste içi ayrı kaydırmayı kapatır, sayfa bütün olarak kayar.
      itemCount: logs.length, // Listedeki kayıt sayısı kadar satır oluşturur.
      separatorBuilder: (context, index) => const SizedBox(height: 8), // Her iki kayıt satırı arasına 8 piksel dikey boşluk koyar.
      itemBuilder: (context, index) { // Sıradaki (index) kaydı alıp görsel satıra dönüştürür:
        final log = logs[index];
        return _buildLogItem(log); // Her bir satırın tasarımını yardımcı metoda delege eder.
      },
    );
  }

  Widget _buildEmptyState() { // _buildEmptyState : Liste boşken gösterilecek bilgilendirme kutusu.
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.5)),
      ),
      child: const Column(
        children: [
          Icon(Icons.opacity_rounded, color: AppColors.textMuted, size: 28), // Su damlası ikonu.
          SizedBox(height: 8),
          Text(
            'Henüz su tüketimi kaydedilmedi.',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(WaterLog log) { // _buildLogItem : Tek bir su kaydını (pozitif ekleme veya negatif azaltma) görselleştiren satır.
    final isDecrease = log.amountMl < 0; // Kayıt miktarı 0'dan küçükse bu bir "yanlış ekleme düzeltmesi (azaltma)" kaydıdır.
    final amountText = isDecrease ? '${log.amountMl} ml' : '+${log.amountMl} ml'; // Negatifse kendi eksisiyle ("-200 ml"), pozitifse başına '+' koyarak ("+200 ml") metinleştirir.
    final accentColor = isDecrease ? AppColors.neonOrange : AppColors.neonCyan; // Azaltma kaydıysa turuncu, normal su eklemeyse mavi (Neon Cyan) vurgu rengi seçer.
    final itemIcon = isDecrease ? Icons.remove_circle_outline_rounded : Icons.water_drop_rounded; // Azaltmaysa eksi ikonu, eklemeyse su damlası ikonu seçer.

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row( // Soldan sağa : İkon -> Miktar ve Etiket -> Saat -> Silme (X) Butonu.
        children: [
          Container( // Sol baştaki yuvarlak ikon kutusu.
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12), // Vurgu renginin %12 opaklığında arka plan.
              shape: BoxShape.circle,
            ),
            child: Icon(
              itemIcon,
              color: accentColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded( // Orta alan : Miktar ("+200 ml") ve altında etiket ("Bardak").
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amountText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDecrease ? AppColors.neonOrange : AppColors.textPrimary, // Azaltma ise turuncu, ekleme ise beyaz yazı.
                  ),
                ),
                Text(
                  log.label, // Örn: 'Bardak', 'Matara' veya 'Yanlış Ekleme Düzeltmesi'.
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            log.formattedTime, // Modelin içindeki getter'dan gelen "14:30" formatındaki saat bilgisi.
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton( // Sağdaki kayıt silme (X) butonu.
            icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textMuted),
            onPressed: () => onDeleteLog(log.id), // Tıklandığında bu kaydın benzersiz `id` değerini `onDeleteLog` callback'i ile controller'a gönderir.
            splashRadius: 18, // Tıklama dalgasının yarıçapı.
          ),
        ],
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI: logs listesi kontrol edilir -> Boşsa _buildEmptyState() çizilir -> Doluysa ListView.separated her kayıt için _buildLogItem(log) çağırır -> log.amountMl işaretine (+ / -) göre renk ve ikon belirlenir -> Sağdaki 'X' butonuna basılırsa onDeleteLog(log.id) ile o kayıt silinir.

// POZİTİF KAYIT (`log.amountMl > 0`) : Başında '+' işareti, mavi su damlası ikonu ve beyaz metinle "su eklendiğini" gösterir.
//  VS
// NEGATİF KAYIT (`log.amountMl < 0`) : Başında '-' işareti, turuncu çıkarma ikonu ve turuncu metinle "düzeltme/azaltma yapıldığını" şeffafça gösterir.
