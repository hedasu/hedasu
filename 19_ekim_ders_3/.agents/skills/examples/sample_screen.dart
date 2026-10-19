import 'package:flutter/material.dart';

// ============================================================================
// 1. MODEL KATMANI (Immutable, copyWith, fromJson, toJson standartlarına uygun)
// project.md & SKILL.md Adım 3 kuralı: Modeller kesinlikle immutable olmalıdır.
// ============================================================================

/// Su tüketim kaydını temsil eden değişmez (immutable) veri modeli.
class SampleWaterEntry {
  final String id;
  final int amountMl;
  final DateTime timestamp;
  final String label;

  const SampleWaterEntry({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    required this.label,
  });

  SampleWaterEntry copyWith({
    String? id,
    int? amountMl,
    DateTime? timestamp,
    String? label,
  }) {
    return SampleWaterEntry(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      label: label ?? this.label,
    );
  }

  factory SampleWaterEntry.fromJson(Map<String, dynamic> json) {
    return SampleWaterEntry(
      id: json['id'] as String? ?? '',
      amountMl: json['amountMl'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      label: json['label'] as String? ?? 'Bardak Su',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
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
class SampleWaterTrackerController {
  final int dailyGoalWater;

  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final ValueNotifier<List<SampleWaterEntry>> history =
      ValueNotifier<List<SampleWaterEntry>>([]);
  final ValueNotifier<bool> isGoalReached = ValueNotifier<bool>(false);

  SampleWaterTrackerController({
    this.dailyGoalWater = 2500, // Standart günlük hedef: 2500 ml
  });

  bool get canUndo => history.value.isNotEmpty;

  double get progressRatio =>
      dailyGoalWater > 0 ? (currentWater.value / dailyGoalWater).clamp(0.0, 1.0) : 0.0;

  /// Su tüketim kaydı ekler ve rozet hedefini kontrol eder.
  void addWater(int amountMl, {String label = 'Bardak Su'}) {
    if (amountMl <= 0) return;

    final entry = SampleWaterEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
      label: label,
    );

    currentWater.value += amountMl;
    history.value = [...history.value, entry];

    if (currentWater.value >= dailyGoalWater && !isGoalReached.value) {
      isGoalReached.value = true;
    }
  }

  /// Son eklenen kaydı geri alır (Undo mekanizması).
  bool undoLastWater() {
    if (history.value.isEmpty) return false;

    final updated = List<SampleWaterEntry>.from(history.value);
    final removed = updated.removeLast();

    currentWater.value = (currentWater.value - removed.amountMl).clamp(0, 99999);
    history.value = updated;

    if (currentWater.value < dailyGoalWater && isGoalReached.value) {
      isGoalReached.value = false;
    }
    return true;
  }

  /// Durumu sıfırlar.
  void resetWater() {
    currentWater.value = 0;
    history.value = [];
    isGoalReached.value = false;
  }

  /// Bellek sızıntılarını önlemek için ValueNotifier dinleyicilerini serbest bırakır.
  void dispose() {
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
class SampleWaterTrackerView extends StatelessWidget {
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
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Sıfırla',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.resetWater,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            SampleWaterProgressCard(controller: controller),
            const SizedBox(height: 16),
            SampleWaterGoalBadgeBanner(isGoalReached: controller.isGoalReached),
            const SizedBox(height: 16),
            SampleWaterUndoSection(
              history: controller.history,
              onUndo: () => _handleUndo(context),
            ),
            const SizedBox(height: 20),
            SampleWaterQuickAddGrid(
              onAdd: (amount, label) => controller.addWater(amount, label: label),
            ),
          ],
        ),
      ),
    );
  }

  void _handleUndo(BuildContext context) {
    final success = controller.undoLastWater();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Son su kaydı başarıyla geri alındı.'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ValueListenableBuilder<int>(
      valueListenable: controller.currentWater,
      builder: (context, currentWater, _) {
        final ratio = controller.progressRatio;
        final percentage = (ratio * 100).toInt();

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                _CircularProgressIndicatorWithText(
                  ratio: ratio,
                  currentWater: currentWater,
                  percentage: percentage,
                  primaryColor: colorScheme.primary,
                ),
                const SizedBox(height: 14),
                Text(
                  'Hedef: ${controller.dailyGoalWater} ml',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
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
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: ratio,
            strokeWidth: 12,
            strokeCap: StrokeCap.round,
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
          Column(
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
    return ValueListenableBuilder<bool>(
      valueListenable: isGoalReached,
      builder: (context, reached, _) {
        if (!reached) return const SizedBox.shrink();

        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.emoji_events_rounded, color: colorScheme.primary, size: 28),
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
  final VoidCallback onUndo;

  const SampleWaterUndoSection({
    super.key,
    required this.history,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SampleWaterEntry>>(
      valueListenable: history,
      builder: (context, items, _) {
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        final lastEntry = items.last;
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
                OutlinedButton.icon(
                  onPressed: onUndo,
                  icon: const Icon(Icons.undo_rounded, size: 16),
                  label: const Text('Geri Al'),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
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
  final void Function(int amount, String label) onAdd;

  const SampleWaterQuickAddGrid({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
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

class _QuickAddButton extends StatelessWidget {
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
