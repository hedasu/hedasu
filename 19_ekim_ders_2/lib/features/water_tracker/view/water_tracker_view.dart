// -bu kod bloğunda Su Takibi sekmesinin ana ekran görünümü (WaterTrackerView) ve alt widget'ların (ilerleme kartı, geri alma bölümü, hızlı ekleme butonları) birleştirilmesi anlatılıyor.-
// İç İçe ValueListenableBuilder: Birden fazla ValueNotifier'ı (hem currentWater hem history) aynı anda dinleyerek herhangi biri değiştiğinde ekranı güncelleyen yapı.
// ScaffoldMessenger.of(context).showSnackBar(): İşlem sonrası (Örn: Geri Alma) ekranın alt kısmında kullanıcıya geri bildirim mesajı gösteren yapı.

import 'package:flutter/material.dart'; // Flutter UI bileşenleri.
import '../controllers/water_tracker_controller.dart'; // Su takip kontrolcüsü.
import '../models/water_entry_model.dart'; // Su kaydı modeli.
import '../widgets/quick_add_buttons.dart'; // Hızlı su ekleme butonları (+200, +330, +500, +1000 ml).
import '../widgets/water_progress_card.dart'; // Dairesel su ilerleme kartı.
import '../widgets/water_undo_section.dart'; // Son eklenen suyu geri alma (Undo) bölümü.

/// Su Takibi Ana Görünümü (Stateless & ValueListenableBuilder)
class WaterTrackerView extends StatelessWidget { // Durum kontrolcüde tutulduğu için StatelessWidget olarak tasarlanmıştır.
  final WaterTrackerController controller;

  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>( // 1. Dinleyici: Toplam içilen su miktarını (currentWater) dinler.
      valueListenable: controller.currentWater,
      builder: (context, currentWater, _) {
        return ValueListenableBuilder<List<WaterEntryModel>>( // 2. Dinleyici: Su geçmişi listesini (history) dinler.
          valueListenable: controller.history,
          builder: (context, history, _) {
            return ListView( // Ekran küçüldüğünde veya yatay çevrildiğinde taşma (overflow) olmaması için kaydırılabilir liste.
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                WaterProgressCard( // Üstteki büyük dairesel su ilerleme halkası.
                  currentWater: currentWater,
                  dailyGoal: controller.dailyGoalWater,
                ),
                const SizedBox(height: 16),
                WaterUndoSection( // Ortadaki son eklenen suyu gösteren ve 'Geri Al' butonu sunan kart (history boşsa gizlenir).
                  history: history,
                  onUndo: () => _handleUndo(context),
                ),
                const SizedBox(height: 20),
                QuickAddButtons( // Alttaki hızlı su ekleme butonları.
                  onAddWater: (amount, label) { // Butonlardan birine basıldığında miktar ve etiketi kontrolcüye iletir.
                    controller.addWater(amount, label: label);
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }

  void _handleUndo(BuildContext context) { // Geri Al butonuna tıklandığında çalışan metot.
    final success = controller.undoLastWater(); // Son su kaydını geri almayı dener.
    if (success) { // Geri alma başarılıysa kullanıcıya bilgi mesajı gösterir.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Son su tüketimi başarıyla geri alındı.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

// ÇALIŞMA MANTIĞI:
// WaterTrackerView çizilir -> QuickAddButtons'dan bir butona basılır -> controller.addWater() çalışır
// -> currentWater ve history güncellenir -> ValueListenableBuilder'lar tetiklenir
// -> WaterProgressCard yeni su miktarını çizer ve WaterUndoSection son eklenen suyu ekranda gösterir.

// COLUMN : İçindeki elemanlar ekrana sığmazsa sarı-siyah şeritli taşma hatası (Bottom Overflowed) verir
//  VS
// LISTVIEW : İçindeki elemanlar ekran boyunu aşarsa otomatik olarak dikey kaydırma (scroll) özelliği kazandırır, taşma hatasını önler
