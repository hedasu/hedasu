// -bu kod bloğunda tek bir dosya içinde örnek bir Su Takip özelliğinin 4 katmanlı mimarisi (Model, Controller, View ve Modüler Widget'lar) anlatılıyor.-
// Immutable (Değişmez) Model: Oluşturulduktan sonra içindeki alanları (final) değiştirilemeyen, değişiklik gerektiğinde copyWith() ile yeni kopyası üretilen güvenli veri sınıfı.
// factory Kurucu (Constructor): Her çağrıldığında yeni bir nesne üretmek zorunda olmayan, JSON gibi dış verileri işleyip sınıf nesnesine dönüştürerek döndüren özel kurucu.
// ValueNotifier & ValueListenableBuilder: setState() kullanmadan sadece değişen veriyi dinleyen UI parçalarını güncelleyen reaktif durum yönetimi ikilisi.
// Undo (Geri Alma) Mekanizması: Yapılan işlemleri bir geçmiş (history) listesinde tutup, son elemanı listeden çıkararak önceki duruma dönme yapısı.

import 'package:flutter/material.dart'; // Flutter Material Design bileşenlerini içe aktarır.

// ============================================================================
// 1. MODEL KATMANI (Immutable, copyWith, fromJson, toJson standartlarına uygun)
// project.md & SKILL.md Adım 3 kuralı: Modeller kesinlikle immutable olmalıdır.
// ============================================================================

/// Su tüketim kaydını temsil eden değişmez (immutable) veri modeli.
class SampleWaterEntry { // Her bir su içme işleminin bilgilerini tutan veri şablonu.
  final String id; // Kaydın benzersiz kimliği (unique ID). | final: Sonradan değiştirilemez.
  final int amountMl; // İçilen su miktarı (mililitre cinsinden tam sayı).
  final DateTime timestamp; // Suyun içildiği tarih ve saat bilgisi.
  final String label; // İçilen suyun etiketi (Örn: 'Bardak Su', 'Matara').

  const SampleWaterEntry({ // const: Tüm alanları final olduğu için derleme zamanında sabit nesne oluşturulmasına izin verir.
    required this.id, // required: Nesne oluşturulurken bu alanların doldurulması zorunludur.
    required this.amountMl,
    required this.timestamp,
    required this.label,
  });

  SampleWaterEntry copyWith({ // copyWith(): Mevcut nesneyi bozmadan, sadece seçilen özelliklerini değiştirerek YENİ bir SampleWaterEntry nesnesi üretir.
    String? id, // ?: Parametrelerin gönderilmesi isteğe bağlıdır (null gelebilir).
    int? amountMl,
    DateTime? timestamp,
    String? label,
  }) {
    return SampleWaterEntry(
      id: id ?? this.id, // ??: Null-coalescing operatörü. Yeni 'id' verilmişse onu kullan, null ise mevcut nesnenin değerini (this.id) koru.
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      label: label ?? this.label,
    );
  }

  factory SampleWaterEntry.fromJson(Map<String, dynamic> json) { // fromJson(): API'den veya yerel depolamadan gelen Map (JSON) verisini SampleWaterEntry nesnesine çevirir.
    return SampleWaterEntry(
      id: json['id'] as String? ?? '', // JSON'daki 'id' alanını String olarak alır, eğer null ise varsayılan olarak boş metin ('') atar.
      amountMl: json['amountMl'] as int? ?? 0, // 'amountMl' null ise 0 kabul eder.
      timestamp: json['timestamp'] != null // Tarih verisi varsa String'den DateTime'a dönüştürür (DateTime.parse), yoksa şu anki zamanı (DateTime.now) verir.
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      label: json['label'] as String? ?? 'Bardak Su', // Etiket yoksa varsayılan 'Bardak Su' olur.
    );
  }

  Map<String, dynamic> toJson() { // toJson(): Nesneyi kaydedilmek veya gönderilmek üzere JSON (anahtar-değer Map) formatına dönüştürür.
    return {
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(), // toIso8601String(): DateTime nesnesini uluslararası standart metin formatına (Örn: "2026-10-19T14:30:00.000") çevirir.
      'label': label,
    };
  }
}

// ============================================================================
// 2. CONTROLLER KATMANI (ValueNotifier tabanlı Reaktif Durum Yönetimi)
// project.md & SKILL.md Adım 2 kuralı: Ağır setState yasaktır, ValueNotifier kullanılır.
// Geri alma (Undo) ve bellek temizliği (dispose) zorunludur.
// ============================================================================

/// Su Takip Ekranı Durum Kontrolcüsü.
class SampleWaterTrackerController { // İş mantığını (Business Logic) ve ekranın durumunu (State) arayüzden (UI) ayıran kontrolcü sınıf.
  final int dailyGoalWater; // Günlük hedeflenen su miktarı (ml).

  final ValueNotifier<int> currentWater = ValueNotifier<int>(0); // Anlık toplam içilen su miktarını tutar, başlangıç değeri 0'dır.
  final ValueNotifier<List<SampleWaterEntry>> history =
      ValueNotifier<List<SampleWaterEntry>>([]); // İçilen suların geçmiş kayıt listesini tutar, başlangıçta boş listedir ([]).
  final ValueNotifier<bool> isGoalReached = ValueNotifier<bool>(false); // Günlük hedefe ulaşılıp ulaşılmadığını tutan bayrak (true/false).

  SampleWaterTrackerController({
    this.dailyGoalWater = 2500, // Varsayılan (default) parametre: Çağrılırken değer verilmezse hedef otomatik 2500 ml olur.
  });

  bool get canUndo => history.value.isNotEmpty; // get: Getter özelliği. Geçmiş listesi boş değilse geri alma (undo) yapılabilir (true döner).

  double get progressRatio => // İlerleme çubuğu için 0.0 ile 1.0 arasında oran hesaplar.
      dailyGoalWater > 0 ? (currentWater.value / dailyGoalWater).clamp(0.0, 1.0) : 0.0; // clamp(0.0, 1.0): Oranın 0'ın altına düşmesini veya 1'in (yüzde 100'ün) üstüne çıkmasını engeller.

  /// Su tüketim kaydı ekler ve rozet hedefini kontrol eder.
  void addWater(int amountMl, {String label = 'Bardak Su'}) { // Yeni su ekleme fonksiyonu.
    if (amountMl <= 0) return; // Koruma kontrolü (Guard Clause): Eklenecek miktar 0 veya negatifse işlemi hemen durdurur.

    final entry = SampleWaterEntry( // Yeni su kaydı nesnesi oluşturulur.
      id: DateTime.now().microsecondsSinceEpoch.toString(), // O anki mikrosaniye değerini benzersiz ID olarak kullanır.
      amountMl: amountMl,
      timestamp: DateTime.now(),
      label: label,
    );

    currentWater.value += amountMl; // Toplam su miktarını artırır -> currentWater'ı dinleyen widget'lar otomatik güncellenir.
    history.value = [...history.value, entry]; // ... (Spread operatörü): Eski listedeki tüm elemanları yeni bir listeye kopyalar ve sonuna 'entry' ekler.
    // ÖNEMLİ: history.value.add(entry) YAZILMAZ! Çünkü aynı liste referansına ekleme yapılırsa ValueNotifier değişimi fark etmez ve UI güncellenmez. Yeni liste atanmalıdır.

    if (currentWater.value >= dailyGoalWater && !isGoalReached.value) { // Toplam su hedefe ulaştıysa VE daha önce hedefe ulaşıldı bilgisi verilmediyse:
      isGoalReached.value = true; // Hedef durumunu true yapar -> Rozet kutusu ekranda belirir.
    }
  }

  /// Son eklenen kaydı geri alır (Undo mekanizması).
  bool undoLastWater() { // Son işlemi geri alır, başarılıysa true, geçmiş boşsa false döndürür.
    if (history.value.isEmpty) return false; // Geçmişte kayıt yoksa geri alınacak bir şey yoktur, false döner.

    final updated = List<SampleWaterEntry>.from(history.value); // Mevcut geçmiş listesinin değiştirilebilir yeni bir kopyasını oluşturur.
    final removed = updated.removeLast(); // removeLast(): Listenin en sonundaki elemanı listeden çıkarır ve çıkarılan elemanı 'removed' değişkenine verir.

    currentWater.value = (currentWater.value - removed.amountMl).clamp(0, 99999); // Çıkarılan su miktarını toplamdan düşer, negatif olmaması için 0 ile sınırlar.
    history.value = updated; // Güncellenmiş yeni listeyi ValueNotifier'a atar -> UI güncellenir.

    if (currentWater.value < dailyGoalWater && isGoalReached.value) { // Geri alma sonrası su miktarı hedefin altına düştüyse:
      isGoalReached.value = false; // Rozet kazanma durumunu geri çeker (false yapar).
    }
    return true; // Geri alma işlemi başarıyla tamamlandı.
  }

  /// Durumu sıfırlar.
  void resetWater() { // Tüm su verilerini başlangıç durumuna döndürür.
    currentWater.value = 0;
    history.value = [];
    isGoalReached.value = false;
  }

  /// Bellek sızıntılarını önlemek için ValueNotifier dinleyicilerini serbest bırakır.
  void dispose() { // Ekran kapandığında tüm ValueNotifier nesnelerini bellekten temizler.
    currentWater.dispose();
    history.dispose();
    isGoalReached.dispose();
  }
}

// ============================================================================
// 3. VIEW KATMANI (StatelessWidget & Scoped ValueListenableBuilder)
// project.md & SKILL.md Adım 4 kuralı: Build metodu 40 satırı geçemez.
// Alt parçalar özel widget'lara bölünür.
// ============================================================================

/// Örnek Su Takip Ekranı Görünümü.
class SampleWaterTrackerView extends StatelessWidget { // Durumu dışarıdan (controller ile) aldığı için StatelessWidget olarak tanımlanır.
  final SampleWaterTrackerController controller;

  const SampleWaterTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Susadım - Su Takibi'),
        centerTitle: true, // Başlığı AppBar'ın ortasına hizalar.
        actions: [
          IconButton( // Sağ üstteki sıfırlama ikonu butonu.
            tooltip: 'Sıfırla', // Butona uzun basıldığında çıkan açıklama metni.
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.resetWater, // Tıklandığında tüm verileri sıfırlar.
          ),
        ],
      ),
      body: SafeArea( // SafeArea: Ekranın çentik (notch), durum çubuğu ve alt sistem çubuğu gibi alanlarına taşmasını önler.
        child: ListView( // ListView: İçeriğin dikey olarak kaydırılabilmesini (scroll) sağlar, küçük ekranlarda taşmayı önler.
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            SampleWaterProgressCard(controller: controller), // Dairesel ilerleme kartı.
            const SizedBox(height: 16),
            SampleWaterGoalBadgeBanner(isGoalReached: controller.isGoalReached), // Hedefe ulaşılınca çıkan tebrik afişi.
            const SizedBox(height: 16),
            SampleWaterUndoSection( // Son işlemi gösteren ve geri alma butonu sunan bölüm.
              history: controller.history,
              onUndo: () => _handleUndo(context),
            ),
            const SizedBox(height: 20),
            SampleWaterQuickAddGrid( // Hızlı su ekleme butonları (+200, +250, +500 ml).
              onAdd: (amount, label) => controller.addWater(amount, label: label),
            ),
          ],
        ),
      ),
    );
  }

  void _handleUndo(BuildContext context) { // Geri al butonuna basıldığında çalışan yardımcı metot.
    final success = controller.undoLastWater(); // Kontrolcü üzerinden son kaydı geri alır.
    if (success) { // Eğer geri alma başarılıysa kullanıcıya bilgi çubuğu gösterir.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Son su kaydı başarıyla geri alındı.'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating, // floating: SnackBar'ı ekranın altına yapıştırmak yerine havada asılı (kenarları boşluklu) gösterir.
        ),
      );
    }
  }
}

// ============================================================================
// 4. MODÜLER WIDGET KATMANI
// project.md & SKILL.md Adım 5 kuralı: const zorunludur, tema duyarlı olmalıdır.
// ============================================================================

/// Dairesel su ilerleme durumunu gösteren kart widget'ı.
class SampleWaterProgressCard extends StatelessWidget {
  final SampleWaterTrackerController controller;

  const SampleWaterProgressCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Mevcut aktif tema verilerine erişir.
    final colorScheme = theme.colorScheme; // Temanın renk şemasını alır.

    return ValueListenableBuilder<int>( // Sadece currentWater değiştiğinde bu kartı yeniden çizer.
      valueListenable: controller.currentWater,
      builder: (context, currentWater, _) {
        final ratio = controller.progressRatio; // Güncel ilerleme oranı (0.0 - 1.0).
        final percentage = (ratio * 100).toInt(); // Oranı yüzdelik tam sayıya çevirir (Örn: 0.5 -> %50).

        return Card(
          elevation: 2, // Kartın gölge yüksekliği.
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                _CircularProgressIndicatorWithText( // Dairesel çubuk ve içindeki yazıyı gösteren alt widget.
                  ratio: ratio,
                  currentWater: currentWater,
                  percentage: percentage,
                  primaryColor: colorScheme.primary,
                ),
                const SizedBox(height: 14),
                Text(
                  'Hedef: ${controller.dailyGoalWater} ml',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7), // withValues(alpha: 0.7): Renge %70 opaklık (hafif saydamlık) verir.
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Dairesel gösterge ve iç metin ayrımı (Build satır sınırını korur).
class _CircularProgressIndicatorWithText extends StatelessWidget {
  final double ratio;
  final int currentWater;
  final int percentage;
  final Color primaryColor;

  const _CircularProgressIndicatorWithText({
    required this.ratio,
    required this.currentWater,
    required this.percentage,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox( // Dairesel göstergenin genişlik ve yüksekliğini 170x170 piksel olarak sınırlar.
      width: 170,
      height: 170,
      child: Stack( // Stack: Widget'ları üst üste (Z ekseninde) dizmek için kullanılır (Altta halka, üstte tam ortada yazılar).
        alignment: Alignment.center, // Üst üste binen elemanları merkeze hizalar.
        children: [
          CircularProgressIndicator( // Dairesel doluluk göstergesi.
            value: ratio, // 0.0 (boş) ile 1.0 (tam dolu) arasındaki değer. (null verilirse sürekli dönen yükleme animasyonu olur).
            strokeWidth: 12, // Halkanın çizgi kalınlığı.
            strokeCap: StrokeCap.round, // Çizginin uçlarını küt değil yuvarlak yapar.
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor), // Halkanın doluluk rengini sabitler.
          ),
          Column( // Halkanın ortasındaki damla ikonu, ml ve yüzde yazılarını alt alta dizer.
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.water_drop_rounded, color: primaryColor, size: 36),
              const SizedBox(height: 4),
              Text(
                '$currentWater ml',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                '%$percentage',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Günlük hedefe ulaşıldığında gösterilen rozet kutusu (Gamification).
class SampleWaterGoalBadgeBanner extends StatelessWidget {
  final ValueNotifier<bool> isGoalReached;

  const SampleWaterGoalBadgeBanner({
    super.key,
    required this.isGoalReached,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>( // isGoalReached durumunu dinler.
      valueListenable: isGoalReached,
      builder: (context, reached, _) {
        if (!reached) return const SizedBox.shrink(); // Hedefe henüz ulaşılmadıysa (reached == false), ekranda hiç yer kaplamayan (0x0 piksel) boş bir kutu döndürür.

        final colorScheme = Theme.of(context).colorScheme;
        return Container( // Hedefe ulaşıldığında gösterilecek kutlama afişi.
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.emoji_events_rounded, color: colorScheme.primary, size: 28), // Kupa ikonu.
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tebrikler! Günlük su hedefini tamamladın ve "Hidrasyon Ustası" rozetini kazandın!',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Geri alma (Undo) aksiyon alanı.
class SampleWaterUndoSection extends StatelessWidget {
  final ValueNotifier<List<SampleWaterEntry>> history;
  final VoidCallback onUndo; // VoidCallback: Parametre almayan ve değer döndürmeyen fonksiyon tipi (void Function()).

  const SampleWaterUndoSection({
    super.key,
    required this.history,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SampleWaterEntry>>( // Geçmiş listesini dinler.
      valueListenable: history,
      builder: (context, items, _) {
        if (items.isEmpty) { // Liste boşsa geri alma kartını gizler.
          return const SizedBox.shrink();
        }

        final lastEntry = items.last; // items.last: Listedeki en son eklenen su kaydını alır.
        final theme = Theme.of(context);

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Son: +${lastEntry.amountMl} ml (${lastEntry.label})',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                OutlinedButton.icon( // İkonlu ve çerçeveli geri alma butonu.
                  onPressed: onUndo,
                  icon: const Icon(Icons.undo_rounded, size: 16),
                  label: const Text('Geri Al'),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact, // Butonun iç boşluklarını daraltarak daha kompakt görünmesini sağlar.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Hızlı su ekleme butonları kılavuzu.
class SampleWaterQuickAddGrid extends StatelessWidget {
  final void Function(int amount, String label) onAdd; // Miktar ve etiket parametrelerini üst katmana ileten fonksiyon.

  const SampleWaterQuickAddGrid({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row( // 3 hızlı ekleme butonunu yan yana eşit genişlikte dizer.
      children: [
        Expanded( // Expanded: Satırdaki mevcut alanı diğer Expanded kardeşleriyle eşit paylaşır (1/3 oranında).
          child: _QuickAddButton(
            icon: Icons.local_cafe_rounded,
            title: '+200 ml',
            subtitle: 'Çay / Kahve',
            onTap: () => onAdd(200, 'Çay / Kahve'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _QuickAddButton(
            icon: Icons.water_drop_rounded,
            title: '+250 ml',
            subtitle: 'Su Bardağı',
            onTap: () => onAdd(250, 'Su Bardağı'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _QuickAddButton(
            icon: Icons.sports_gymnastics_rounded,
            title: '+500 ml',
            subtitle: 'Matara',
            onTap: () => onAdd(500, 'Matara'),
          ),
        ),
      ],
    );
  }
}

class _QuickAddButton extends StatelessWidget { // Tek bir hızlı ekleme butonunun tasarımını tutan özel (private) widget.
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell( // Tıklama ve dalga efekti sağlar.
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink( // Ink: InkWell'in dalga efektinin arka plan renginin ÜSTÜNDE görünmesini sağlayan özel kutu (Container kullanılsaydı dalga efekti rengin altında kalabilirdi).
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: colorScheme.primary, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 1, // En fazla 1 satır göster.
              overflow: TextOverflow.ellipsis, // Sığmazsa sonuna üç nokta (...) koy.
            ),
          ],
        ),
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// Kullanıcı _QuickAddButton'a tıklar -> onAdd callback'i ile controller.addWater() çağrılır
// -> SampleWaterEntry oluşturulur -> currentWater ve history ValueNotifier'ları güncellenir
// -> Sadece bu değerleri dinleyen SampleWaterProgressCard, SampleWaterUndoSection ve (hedef geçildiyse) SampleWaterGoalBadgeBanner yeniden çizilir.

// MUTABLE (DEĞİŞTİRİLEBİLİR) MODEL : Nesnenin alanları doğrudan değiştirilir, hangi katmanın veriyi ne zaman değiştirdiğini takip etmek zordur ve ValueNotifier değişimi algılamayabilir
//  VS
// IMMUTABLE (DEĞİŞMEZ) MODEL : Tüm alanlar final'dır, değişiklik için copyWith veya yeni liste referansı üretilir; güvenli, öngörülebilir ve reaktif mimariye tam uyumludur
