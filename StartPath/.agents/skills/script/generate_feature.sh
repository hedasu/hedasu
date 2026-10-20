#!/usr/bin/env bash
# ==============================================================================
# StartPath Feature Scaffold Generator
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
  echo -e "${CYAN}${BOLD}StartPath Feature Scaffold Üretici (startpath-feature-scaffold)${NC}"
  echo -e "Bu script, project.md ve SKILL.md kurallarına tam uyumlu özellik (feature) modülü üretir.\n"
  echo -e "${YELLOW}Kullanım:${NC}"
  echo -e "  $0 <feature_name> [hedef_dizin]\n"
  echo -e "${YELLOW}Örnekler:${NC}"
  echo -e "  $0 mentor_matching"
  echo -e "  $0 team_matching"
  echo -e "  $0 legal_roadmap lib/features\n"
  echo -e "${YELLOW}Üretilen Yapı:${NC}"
  echo -e "  lib/features/<feature_name>/"
  echo -e "    ├── controller/<feature_name>_controller.dart (ValueNotifier, dispose)"
  echo -e "    ├── models/<feature_name>_model.dart (Immutable, copyWith, fromJson, toJson)"
  echo -e "    ├── view/<feature_name>_view.dart (StatelessWidget, ValueListenableBuilder, <40 satır build)"
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
SNAKE_NAME=$(echo "$RAW_NAME" | tr '-' '_' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]//g')
PASCAL_NAME=$(echo "$SNAKE_NAME" | awk -F '_' '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1' OFS='')

FEATURE_DIR="${TARGET_BASE}/${SNAKE_NAME}"
TEST_DIR="test/features/${SNAKE_NAME}"

echo -e "${BLUE}==>${NC} ${BOLD}StartPath:${NC} ${BOLD}${PASCAL_NAME}${NC} (${SNAKE_NAME}) özelliği kuruluyor..."
echo -e "${BLUE}==>${NC} Hedef Dizin: ${CYAN}${FEATURE_DIR}${NC}"

# 1. Dizinleri Oluştur
mkdir -p "${FEATURE_DIR}/controller"
mkdir -p "${FEATURE_DIR}/models"
mkdir -p "${FEATURE_DIR}/view"
mkdir -p "${FEATURE_DIR}/widgets"
mkdir -p "${TEST_DIR}/controller"
mkdir -p "${TEST_DIR}/view"

# 2. Model Dosyası
MODEL_FILE="${FEATURE_DIR}/models/${SNAKE_NAME}_model.dart"
cat <<EOF > "$MODEL_FILE"
/// ${PASCAL_NAME} Veri Modeli (Immutable)
/// project.md ve SKILL.md standartlarına tam uyumludur.
class ${PASCAL_NAME}Model {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isActive;

  const ${PASCAL_NAME}Model({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isActive,
  });

  ${PASCAL_NAME}Model copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return ${PASCAL_NAME}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  factory ${PASCAL_NAME}Model.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_NAME}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
EOF

# 3. Controller Dosyası
CONTROLLER_FILE="${FEATURE_DIR}/controller/${SNAKE_NAME}_controller.dart"
cat <<EOF > "$CONTROLLER_FILE"
import 'package:flutter/foundation.dart';
import '../models/${SNAKE_NAME}_model.dart';

/// ${PASCAL_NAME} Durum Kontrolcüsü
/// Ağır setState yasaktır; ValueNotifier ile reaktif durum yönetilir.
class ${PASCAL_NAME}Controller {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);
  final ValueNotifier<List<${PASCAL_NAME}Model>> items =
      ValueNotifier<List<${PASCAL_NAME}Model>>([]);
  final ValueNotifier<String> filter = ValueNotifier<String>('Tümü');

  List<${PASCAL_NAME}Model> get filteredItems {
    if (filter.value == 'Tümü') return items.value;
    return items.value.where((item) => item.title.contains(filter.value)).toList();
  }

  void updateFilter(String newFilter) {
    filter.value = newFilter;
  }

  void clearError() {
    errorMessage.value = null;
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      items.value = [
        ${PASCAL_NAME}Model(
          id: '1',
          title: '${PASCAL_NAME} Başlangıç Öğesi',
          description: 'StartPath ekosisteminde otomatik oluşturuldu.',
          createdAt: DateTime.now(),
          isActive: true,
        ),
      ];
    } catch (e) {
      errorMessage.value = 'Veriler yüklenirken bir hata oluştu.';
    } finally {
      isLoading.value = false;
    }
  }

  void addItem({required String title, required String description}) {
    final newItem = ${PASCAL_NAME}Model(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      isActive: true,
    );
    items.value = [...items.value, newItem];
  }

  void dispose() {
    isLoading.dispose();
    errorMessage.dispose();
    items.dispose();
    filter.dispose();
  }
}
EOF

# 4. View Dosyası (<40 satır build kuralı)
VIEW_FILE="${FEATURE_DIR}/view/${SNAKE_NAME}_view.dart"
cat <<EOF > "$VIEW_FILE"
import 'package:flutter/material.dart';
import '../controller/${SNAKE_NAME}_controller.dart';
import '../widgets/${SNAKE_NAME}_card.dart';

/// ${PASCAL_NAME} Ana Ekranı
/// project.md kuralı: 40 satırı geçen build metotları yasaktır.
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
        title: const Text('${PASCAL_NAME} Modülü'),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.fetchItems,
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.isLoading,
          builder: (context, loading, _) {
            if (loading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            return _ContentBody(controller: controller);
          },
        ),
      ),
    );
  }
}

class _ContentBody extends StatelessWidget {
  final ${PASCAL_NAME}Controller controller;

  const _ContentBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([controller.items, controller.filter]),
      builder: (context, _) {
        final list = controller.filteredItems;
        if (list.isEmpty) {
          return const Center(child: Text('Kayıtlı veri bulunamadı.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ${PASCAL_NAME}Card(item: list[index]);
          },
        );
      },
    );
  }
}
EOF

# 5. Widget Dosyası
WIDGET_FILE="${FEATURE_DIR}/widgets/${SNAKE_NAME}_card.dart"
cat <<EOF > "$WIDGET_FILE"
import 'package:flutter/material.dart';
import '../models/${SNAKE_NAME}_model.dart';

/// ${PASCAL_NAME} Modüler Kart Bileşeni
/// project.md kuralı: const yapıcı ve tema kullanımı esastır.
class ${PASCAL_NAME}Card extends StatelessWidget {
  final ${PASCAL_NAME}Model item;
  final VoidCallback? onTap;

  const ${PASCAL_NAME}Card({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(Icons.hub_rounded, color: colorScheme.onPrimaryContainer),
        ),
        title: Text(
          item.title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          item.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
EOF

# 6. Test Dosyaları (Birim ve Widget Testleri)
CONTROLLER_TEST_FILE="${TEST_DIR}/controller/${SNAKE_NAME}_controller_test.dart"
cat <<EOF > "$CONTROLLER_TEST_FILE"
import 'package:flutter_test/flutter_test.dart';
import 'package:startpath/features/${SNAKE_NAME}/controller/${SNAKE_NAME}_controller.dart';

void main() {
  group('${PASCAL_NAME}Controller Testleri', () {
    late ${PASCAL_NAME}Controller controller;

    setUp(() {
      controller = ${PASCAL_NAME}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumu sıfır/boş olmalıdır', () {
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, isNull);
      expect(controller.items.value.isEmpty, true);
      expect(controller.filter.value, 'Tümü');
    });

    test('addItem yeni öğeyi listeye eklemelidir', () {
      controller.addItem(title: 'Yeni Başlık', description: 'Yeni Açıklama');
      expect(controller.items.value.length, 1);
      expect(controller.items.value.first.title, 'Yeni Başlık');
    });

    test('fetchItems verileri doldurmalıdır', () async {
      await controller.fetchItems();
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, isNull);
      expect(controller.items.value.isNotEmpty, true);
    });
  });
}
EOF

VIEW_TEST_FILE="${TEST_DIR}/view/${SNAKE_NAME}_view_test.dart"
cat <<EOF > "$VIEW_TEST_FILE"
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startpath/features/${SNAKE_NAME}/controller/${SNAKE_NAME}_controller.dart';
import 'package:startpath/features/${SNAKE_NAME}/view/${SNAKE_NAME}_view.dart';

void main() {
  testWidgets('${PASCAL_NAME}View başlangıçta boş listeyi doğru göstermelidir', (tester) async {
    final controller = ${PASCAL_NAME}Controller();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: ${PASCAL_NAME}View(controller: controller),
      ),
    );

    expect(find.text('${PASCAL_NAME} Modülü'), findsOneWidget);
    expect(find.text('Kayıtlı veri bulunamadı.'), findsOneWidget);
  });
}
EOF

chmod +x "$0" 2>/dev/null || true

echo -e "\n${GREEN}${BOLD}✓ StartPath modülü başarıyla oluşturuldu!${NC}"
echo -e "  ├── ${CYAN}${MODEL_FILE}${NC}"
echo -e "  ├── ${CYAN}${CONTROLLER_FILE}${NC}"
echo -e "  ├── ${CYAN}${VIEW_FILE}${NC}"
echo -e "  ├── ${CYAN}${WIDGET_FILE}${NC}"
echo -e "  ├── ${CYAN}${CONTROLLER_TEST_FILE}${NC}"
echo -e "  └── ${CYAN}${VIEW_TEST_FILE}${NC}"
echo -e "\n${YELLOW}${BOLD}Doğrulama Adımı:${NC}"
echo -e "Şimdi ${BOLD}flutter analyze${NC} ve ${BOLD}flutter test${NC} ile kontrol edebilirsin.\n"
