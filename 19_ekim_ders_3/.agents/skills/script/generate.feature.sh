#!/usr/bin/env bash
# ==============================================================================
# Susadım & Flutter Feature Scaffold Generator
# project.md ve .agents/skills/SKILL.md standartlarına uygun modüler iskelet üretici
# ==============================================================================

set -euo pipefail

# Renk Tanımlamaları
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

# Yardım Mesajı
show_help() {
  echo -e "${CYAN}${BOLD}Flutter Feature Scaffold Üretici (flutter-feature-scaffold)${NC}"
  echo -e "Bu script, project.md ve SKILL.md kurallarına tam uyumlu özellik (feature) modülü üretir.\n"
  echo -e "${YELLOW}Kullanım:${NC}"
  echo -e "  $0 <feature_name> [hedef_dizin]\n"
  echo -e "${YELLOW}Örnekler:${NC}"
  echo -e "  $0 water_tracker"
  echo -e "  $0 workout"
  echo -e "  $0 badges lib/features\n"
  echo -e "${YELLOW}Üretilen Yapı:${NC}"
  echo -e "  lib/features/<feature_name>/"
  echo -e "    ├── controllers/<feature_name>_controller.dart (ValueNotifier, Undo, dispose)"
  echo -e "    ├── models/<feature_name>_model.dart (Immutable, copyWith, fromJson, toJson)"
  echo -e "    ├── view/<feature_name>_view.dart (StatelessWidget, ValueListenableBuilder, <40 satır)"
  echo -e "    └── widgets/<feature_name>_card.dart (StatelessWidget, const, Tema uyumlu)"
  echo -e "  test/features/<feature_name>/<feature_name>_controller_test.dart (Birim Testleri)"
  exit 0
}

# Argüman Kontrolü
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  show_help
fi

RAW_NAME="$1"
TARGET_BASE="${2:-lib/features}"

# İsim Dönüşümleri (snake_case & PascalCase)
# Örn: water_tracker -> water_tracker ve WaterTracker
SNAKE_NAME=$(echo "$RAW_NAME" | tr '-' '_' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]//g')

# PascalCase hesaplama
PASCAL_NAME=$(echo "$SNAKE_NAME" | awk -F '_' '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1' OFS='')

FEATURE_DIR="${TARGET_BASE}/${SNAKE_NAME}"
TEST_DIR="test/features/${SNAKE_NAME}"

echo -e "${BLUE}==>${NC} ${BOLD}${PASCAL_NAME}${NC} (${SNAKE_NAME}) özelliği için modüler yapı kuruluyor..."
echo -e "${BLUE}==>${NC} Hedef Dizin: ${CYAN}${FEATURE_DIR}${NC}"

# 1. Dizinleri Oluştur
mkdir -p "${FEATURE_DIR}/controllers"
mkdir -p "${FEATURE_DIR}/models"
mkdir -p "${FEATURE_DIR}/view"
mkdir -p "${FEATURE_DIR}/widgets"
mkdir -p "${TEST_DIR}"

# 2. Model Dosyası (Immutable, copyWith, fromJson, toJson)
MODEL_FILE="${FEATURE_DIR}/models/${SNAKE_NAME}_model.dart"
cat <<EOF > "$MODEL_FILE"
/// ${PASCAL_NAME} Veri Modeli (Immutable)
/// project.md & SKILL.md kurallarına tam uyumludur.
class ${PASCAL_NAME}Model {
  final String id;
  final String title;
  final DateTime timestamp;
  final int value;

  const ${PASCAL_NAME}Model({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.value,
  });

  ${PASCAL_NAME}Model copyWith({
    String? id,
    String? title,
    DateTime? timestamp,
    int? value,
  }) {
    return ${PASCAL_NAME}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      value: value ?? this.value,
    );
  }

  factory ${PASCAL_NAME}Model.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_NAME}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      value: json['value'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'timestamp': timestamp.toIso8601String(),
      'value': value,
    };
  }
}
EOF

# 3. Controller Dosyası (ValueNotifier, Undo desteği, dispose)
CONTROLLER_FILE="${FEATURE_DIR}/controllers/${SNAKE_NAME}_controller.dart"
cat <<EOF > "$CONTROLLER_FILE"
import 'package:flutter/foundation.dart';
import '../models/${SNAKE_NAME}_model.dart';

/// ${PASCAL_NAME} Durum Kontrolcüsü
/// Ağır setState yasaktır; ValueNotifier ile reaktif durum ve geri alma (Undo) yönetilir.
class ${PASCAL_NAME}Controller {
  final ValueNotifier<int> totalValue = ValueNotifier<int>(0);
  final ValueNotifier<List<${PASCAL_NAME}Model>> history =
      ValueNotifier<List<${PASCAL_NAME}Model>>([]);

  bool get canUndo => history.value.isNotEmpty;

  /// Yeni etkinlik ekler
  void addItem({required String title, required int amount}) {
    if (amount <= 0) return;

    final entry = ${PASCAL_NAME}Model(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      timestamp: DateTime.now(),
      value: amount,
    );

    totalValue.value += amount;
    history.value = [...history.value, entry];
  }

  /// Eklenen son etkinliği geri alır (Undo)
  bool undoLastItem() {
    if (history.value.isEmpty) return false;

    final updatedList = List<${PASCAL_NAME}Model>.from(history.value);
    final removed = updatedList.removeLast();

    totalValue.value = (totalValue.value - removed.value).clamp(0, 999999);
    history.value = updatedList;

    return true;
  }

  /// Durumu sıfırlar
  void reset() {
    totalValue.value = 0;
    history.value = [];
  }

  /// Bellek sızıntılarını önlemek için dinleyicileri serbest bırakır
  void dispose() {
    totalValue.dispose();
    history.dispose();
  }
}
EOF

# 4. View Dosyası (StatelessWidget, ValueListenableBuilder, <40 satır build)
VIEW_FILE="${FEATURE_DIR}/view/${SNAKE_NAME}_view.dart"
cat <<EOF > "$VIEW_FILE"
import 'package:flutter/material.dart';
import '../controllers/${SNAKE_NAME}_controller.dart';
import '../widgets/${SNAKE_NAME}_card.dart';

/// ${PASCAL_NAME} Ana Görünümü (Clean UI & Scoped Reactive Re-render)
/// project.md kuralı: Sayfa düzeyinde ağır setState yasaktır. Build metodu 40 satırı geçemez.
class ${PASCAL_NAME}View extends StatelessWidget {
  final ${PASCAL_NAME}Controller controller;

  const ${PASCAL_NAME}View({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${PASCAL_NAME} Takibi'),
        actions: [
          IconButton(
            tooltip: 'Sıfırla',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.reset,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            ${PASCAL_NAME}Card(controller: controller),
            const SizedBox(height: 16),
            _UndoSection(
              controller: controller,
              onUndo: () => _handleUndo(context),
            ),
          ],
        ),
      ),
    );
  }

  void _handleUndo(BuildContext context) {
    final success = controller.undoLastItem();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Son işlem başarıyla geri alındı.'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _UndoSection extends StatelessWidget {
  final ${PASCAL_NAME}Controller controller;
  final VoidCallback onUndo;

  const _UndoSection({
    required this.controller,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.history,
      builder: (context, history, _) {
        if (history.isEmpty) return const SizedBox.shrink();
        final last = history.last;

        return Card(
          child: ListTile(
            leading: const Icon(Icons.history_rounded),
            title: Text('Son: \${last.title} (+\${last.value})'),
            trailing: OutlinedButton.icon(
              onPressed: onUndo,
              icon: const Icon(Icons.undo_rounded, size: 16),
              label: const Text('Geri Al'),
            ),
          ),
        );
      },
    );
  }
}
EOF

# 5. Widget Dosyası (StatelessWidget, const, Tema Uyumlu)
WIDGET_FILE="${FEATURE_DIR}/widgets/${SNAKE_NAME}_card.dart"
cat <<EOF > "$WIDGET_FILE"
import 'package:flutter/material.dart';
import '../controllers/${SNAKE_NAME}_controller.dart';

/// ${PASCAL_NAME} Özet Kartı
/// project.md kuralı: const kurucu zorunludur ve tema renkleri kullanılır.
class ${PASCAL_NAME}Card extends StatelessWidget {
  final ${PASCAL_NAME}Controller controller;

  const ${PASCAL_NAME}Card({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder<int>(
          valueListenable: controller.totalValue,
          builder: (context, total, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Toplam Değer',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$total',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    controller.addItem(title: 'Hızlı Ekleme', amount: 100);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('+100 Ekle'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
EOF

# 6. Birim Test İskeleti (Unit Test)
TEST_FILE="${TEST_DIR}/${SNAKE_NAME}_controller_test.dart"
cat <<EOF > "$TEST_FILE"
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/${SNAKE_NAME}/controllers/${SNAKE_NAME}_controller.dart';

void main() {
  group('${PASCAL_NAME}Controller Testleri', () {
    late ${PASCAL_NAME}Controller controller;

    setUp(() {
      controller = ${PASCAL_NAME}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumu sıfır ve boş olmalı', () {
      expect(controller.totalValue.value, 0);
      expect(controller.history.value.isEmpty, true);
      expect(controller.canUndo, false);
    });

    test('addItem değeri artırmalı ve geçmişe eklemeli', () {
      controller.addItem(title: 'Test', amount: 150);

      expect(controller.totalValue.value, 150);
      expect(controller.history.value.length, 1);
      expect(controller.canUndo, true);
    });

    test('undoLastItem işlemi son eklemeyi geri almalı', () {
      controller.addItem(title: 'Adım 1', amount: 100);
      controller.addItem(title: 'Adım 2', amount: 200);
      expect(controller.totalValue.value, 300);

      final undone = controller.undoLastItem();
      expect(undone, true);
      expect(controller.totalValue.value, 100);
      expect(controller.history.value.length, 1);
    });
  });
}
EOF

# Çalıştırma İznini Ayarla
chmod +x "$0" 2>/dev/null || true

echo -e "\n${GREEN}${BOLD}✓ Modül başarıyla oluşturuldu!${NC}"
echo -e "  ├── ${CYAN}${MODEL_FILE}${NC}"
echo -e "  ├── ${CYAN}${CONTROLLER_FILE}${NC}"
echo -e "  ├── ${CYAN}${VIEW_FILE}${NC}"
echo -e "  ├── ${CYAN}${WIDGET_FILE}${NC}"
echo -e "  └── ${CYAN}${TEST_FILE}${NC}"
echo -e "\n${YELLOW}${BOLD}Doğrulama Adımı:${NC}"
echo -e "Şimdi ${BOLD}flutter analyze${NC} ve ${BOLD}flutter test${NC} ile kontrol edebilirsin.\n"
