// -bu dosyada hızlı su ekleme (+200, +350, +500, +1000 ml) ve yanlışlıkla eklenen suyu azaltma/geri alma (-100, -200, -350 ml, Son Kayıt İptal) butonlarını barındıran QuickWaterActions bileşeni anlatılıyor.-
// VoidCallback : Parametre almayan ve geriye değer döndürmeyen (`void Function()`) fonksiyon tipi için Flutter'ın sunduğu kısa takma addır (typedef).
// InkWell : Normalde tıklama özelliği olmayan bir `Container` veya `Column` widget'ına dokunma algılama (`onTap`) ve Material su dalgası (ripple) efekti kazandıran sarmalayıcıdır.
// Material(color: Colors.transparent) : `InkWell`'in dalga efektinin (`ripple`) görünür olabilmesi için altında bir `Material` yüzeyi gerekir; şeffaf bir Material ile sarmalanarak dalganın kutu üzerinde çizilmesi sağlanır.

import 'package:flutter/material.dart'; // Flutter Material bileşenleri.
import '../../../core/constants/app_colors.dart'; // Uygulama renk sabitleri.

/// Hızlı su ekleme ve yanlışlıkla ekleme durumu için azaltma/geri alma butonları.
class QuickWaterActions extends StatelessWidget { // StatelessWidget : Veriyi değiştirmek yerine kullanıcı tıklamalarını üst katmana (WaterTrackerView -> Controller) bildiren sunum bileşeni.
  const QuickWaterActions({
    super.key,
    required this.onAddWater, // Su ekleme butonlarına basıldığında miktar (int) ve etiket (String) gönderen fonksiyon.
    required this.onDecreaseWater, // Azaltma butonlarına basıldığında miktar (int) ve etiket (String) gönderen fonksiyon.
    required this.onUndoLast, // "Geri Al" veya "Son Kayıt İptal Et" butonuna basıldığında çalışan fonksiyon.
    required this.onReset, // "Sıfırla" butonuna basıldığında çalışan fonksiyon.
    required this.canDecrease, // İçilen su miktarı 0'dan büyük mü? (Azaltma/Geri alma butonlarının aktiflik durumu).
  });

  final void Function(int amountMl, String label) onAddWater; // İki parametreli (miktar ve etiket) su ekleme callback tanımı.
  final void Function(int amountMl, String label) onDecreaseWater; // İki parametreli su azaltma callback tanımı.
  final VoidCallback onUndoLast; // Parametresiz geri alma callback'i.
  final VoidCallback onReset; // Parametresiz sıfırlama callback'i.
  final bool canDecrease; // true ise azaltma butonları tıklanabilir ve turuncu yanar; false ise tıklanamaz (null) ve gri görünür.

  @override
  Widget build(BuildContext context) { // build() : Ana yapıyı 3 yardımcı metoda (_buildHeader, _buildAddPresets, _buildDecreaseSection) bölerek temiz tutar.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alt elemanları sola hizalar.
      children: [
        _buildHeader(), // 1. Üst satır : "Hızlı Ekle" başlığı ile sağdaki "Geri Al" ve "Sıfırla" metin butonları.
        const SizedBox(height: 10),
        _buildAddPresets(context), // 2. Orta satır : +200, +350, +500, +1000 ml hızlı ekleme kartları.
        const SizedBox(height: 14),
        _buildDecreaseSection(context), // 3. Alt bölüm : Yanlış ekleme durumları için -100, -200, -350 ml ve Son Kayıt İptal kartları.
      ],
    );
  }

  Widget _buildHeader() { // _buildHeader : Başlık ve hızlı aksiyon (Geri Al / Sıfırla) satırını oluşturur.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Başlığı sola, butonları sağa yaslar.
      children: [
        const Text(
          'Hızlı Ekle',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        Row( // Sağ üstteki "Geri Al" ve "Sıfırla" butonlarını yan yana tutar.
          children: [
            TextButton.icon( // TextButton.icon : Yanında ikon bulunan çerçevesiz metin butonu.
              onPressed: canDecrease ? onUndoLast : null, // ÖNEMLİ: Flutter'da bir butonun `onPressed` parametresine `null` verilirse buton otomatik olarak DEVRE DIŞI (disabled / tıklanamaz) olur.
              icon: Icon(
                Icons.undo_rounded, // Geri al (sola kıvrık ok) ikonu.
                size: 16,
                color: canDecrease ? AppColors.neonOrange : AppColors.textMuted, // Aktifse turuncu, pasifse soluk gri.
              ),
              label: Text(
                'Geri Al',
                style: TextStyle(
                  fontSize: 12,
                  color: canDecrease ? AppColors.neonOrange : AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(width: 4),
            TextButton.icon(
              onPressed: onReset, // Tüm günlük su kayıtlarını sıfırlayan fonksiyonu tetikler.
              icon: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.textMuted),
              label: const Text(
                'Sıfırla',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddPresets(BuildContext context) { // _buildAddPresets : 4 adet pozitif su ekleme butonunu yan yana eşit genişlikte dizer.
    return Row(
      children: [
        _buildPresetButton( // 1. Buton : 1 su bardağı (+200 ml).
          amount: 200,
          title: '+200 ml',
          icon: Icons.local_drink_outlined,
          label: 'Bardak',
          color: AppColors.neonCyan,
          onTap: () => onAddWater(200, 'Bardak'), // Tıklandığında 200 ml ve 'Bardak' etiketini gönderir.
        ),
        const SizedBox(width: 8), // Butonlar arası 8 piksel yatay boşluk.
        _buildPresetButton( // 2. Buton : Büyük kupa (+350 ml).
          amount: 350,
          title: '+350 ml',
          icon: Icons.coffee_outlined,
          label: 'Büyük Kupa',
          color: AppColors.neonCyan,
          onTap: () => onAddWater(350, 'Büyük Kupa'),
        ),
        const SizedBox(width: 8),
        _buildPresetButton( // 3. Buton : Sporcu matarası (+500 ml).
          amount: 500,
          title: '+500 ml',
          icon: Icons.sports_gymnastics_rounded,
          label: 'Matara',
          color: AppColors.neonCyan,
          onTap: () => onAddWater(500, 'Matara'),
        ),
        const SizedBox(width: 8),
        _buildPresetButton( // 4. Buton : Sürahi / Büyük şişe (+1000 ml).
          amount: 1000,
          title: '+1000 ml',
          icon: Icons.battery_charging_full_rounded,
          label: 'Sürahi',
          color: AppColors.neonCyan,
          onTap: () => onAddWater(1000, 'Sürahi'),
        ),
      ],
    );
  }

  Widget _buildDecreaseSection(BuildContext context) { // _buildDecreaseSection : Yanlışlıkla fazla su eklendiğinde kullanılan azaltma ve iptal etme bölümü.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Yanlış Ekleme / Azaltma',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Row( // 3 adet miktar azaltma butonu (-100, -200, -350) ve 1 adet "Son Kayıt İptal Et" butonu.
          children: [
            _buildPresetButton( // -100 ml azaltma butonu.
              amount: 100,
              title: '-100 ml',
              icon: Icons.remove_circle_outline_rounded,
              label: 'Azalt',
              color: canDecrease ? AppColors.neonOrange : AppColors.textMuted, // Su > 0 ise turuncu, 0 ise gri.
              onTap: canDecrease ? () => onDecreaseWater(100, 'Yanlış Ekleme Düzeltmesi') : null, // Su 0 ise `null` verilerek tıklanması engellenir.
            ),
            const SizedBox(width: 8),
            _buildPresetButton( // -200 ml azaltma butonu.
              amount: 200,
              title: '-200 ml',
              icon: Icons.remove_circle_outline_rounded,
              label: 'Düzelt',
              color: canDecrease ? AppColors.neonOrange : AppColors.textMuted,
              onTap: canDecrease ? () => onDecreaseWater(200, 'Yanlış Ekleme Düzeltmesi') : null,
            ),
            const SizedBox(width: 8),
            _buildPresetButton( // -350 ml azaltma butonu.
              amount: 350,
              title: '-350 ml',
              icon: Icons.remove_circle_outline_rounded,
              label: 'Düzelt',
              color: canDecrease ? AppColors.neonOrange : AppColors.textMuted,
              onTap: canDecrease ? () => onDecreaseWater(350, 'Yanlış Ekleme Düzeltmesi') : null,
            ),
            const SizedBox(width: 8),
            Expanded( // 4. Kutu : Son yapılan kaydı doğrudan silen özel "Son Kayıt İptal Et" kartı.
              child: Material(
                color: Colors.transparent, // InkWell dalga efektinin görünmesi için şeffaf Material katmanı.
                child: InkWell(
                  onTap: canDecrease ? onUndoLast : null, // Aktifse son kaydı geri alır.
                  borderRadius: BorderRadius.circular(16), // Dalga efektinin köşelerden taşmaması için yuvarlatma.
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: canDecrease
                            ? AppColors.neonOrange.withValues(alpha: 0.5) // Aktifken yarı saydam turuncu çerçeve.
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          color: canDecrease ? AppColors.neonOrange : AppColors.textMuted,
                          size: 20,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Son Kayıt',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: canDecrease ? AppColors.textPrimary : AppColors.textMuted,
                          ),
                        ),
                        Text(
                          'İptal Et',
                          style: TextStyle(
                            fontSize: 10,
                            color: canDecrease ? AppColors.neonOrange : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetButton({ // _buildPresetButton : Hem ekleme hem azaltma butonları için kod tekrarını önleyen ortak buton şablonu.
    required int amount,
    required String title,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap, // VoidCallback? : Sonundaki `?` bu parametrenin `null` olabileceğini (nullable - buton pasifken) belirtir.
  }) {
    return Expanded( // Expanded : Row içindeki 4 butonun ekran genişliğini 4 eşit parçaya bölüp paylaşmasını sağlar.
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap, // null gelirse InkWell tıklamayı ve dalga efektini otomatik kapatır.
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column( // İkon, miktar başlığı ('+200 ml') ve alt etiketi ('Bardak') alt alta dizer.
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: onTap != null ? AppColors.textPrimary : AppColors.textMuted, // Tıklanabilirse beyaz, pasifse (null) soluk gri.
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI: Kullanıcı '+500 ml Matara' kartına dokunur -> InkWell onTap tetiklenir -> onAddWater(500, 'Matara') callback'i çalışır -> WaterTrackerController.addWater() çağrılır -> currentIntakeMl > 0 olduğu için canDecrease true olur ve alt satırdaki azaltma butonları turuncu renkte aktifleşir.

// AZALTMA (`decreaseWater`) : Geçmiş listesine "-200 ml (Yanlış Ekleme Düzeltmesi)" şeklinde yeni bir negatif kayıt ekleyerek toplamı düşürür; yapılan düzeltmenin izi geçmişte görünür.
//  VS
// GERİ ALMA (`undoLast`) : Geçmiş listesinin en üstündeki (en son yapılan) kaydı listeden tamamen siler; son tıklamayı hiç yapılmamış gibi geri alır.
