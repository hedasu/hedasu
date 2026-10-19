import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dunce_gunluk/main.dart';
import 'package:dunce_gunluk/core/constants/app_strings.dart';
import 'package:dunce_gunluk/features/diary/controller/diary_controller.dart';
import 'package:dunce_gunluk/features/diary/models/diary_entry.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('DiaryController Testleri', () {
    test('formatDateKey doğru formatta tarih anahtarı üretmeli', () {
      final date = DateTime(2026, 10, 19);
      expect(DiaryController.formatDateKey(date), equals('2026-10-19'));
    });

    test('Yeni anı kaydedilebilmeli ve okunabilmeli', () async {
      final controller = DiaryController();
      final dateKey = '2026-10-19';
      final entry = DiaryEntry(
        id: '1',
        dateKey: dateKey,
        title: 'Bugünün Düşüncesi',
        content: 'Nostaljik bir sonbahar günü...',
        mood: 'thoughtful',
      );

      await controller.saveEntry(entry);

      expect(controller.hasEntryOnDate(DateTime(2026, 10, 19)), isTrue);
      expect(controller.getEntryForDate(DateTime(2026, 10, 19))?.title,
          equals('Bugünün Düşüncesi'));
    });

    test('Anı silme işlemi başarılı olmalı', () async {
      final controller = DiaryController();
      final dateKey = '2026-10-19';
      final entry = DiaryEntry(
        id: '1',
        dateKey: dateKey,
        title: 'Silinecek Anı',
        content: 'Test içeriği',
      );

      await controller.saveEntry(entry);
      expect(controller.hasEntryOnDate(DateTime(2026, 10, 19)), isTrue);

      await controller.deleteEntry(dateKey);
      expect(controller.hasEntryOnDate(DateTime(2026, 10, 19)), isFalse);
    });
  });

  group('Uygulama Arayüz Testleri', () {
    testWidgets('DunceApp açılış ekranını göstermeli ve ana ekrana geçebilmeli',
        (WidgetTester tester) async {
      await tester.pumpWidget(const DunceApp());
      await tester.pumpAndSettle();

      // Açılış ekranı başlığı ve "Defteri Aç" butonu var mı?
      expect(find.text(AppStrings.appName), findsWidgets);
      expect(find.text(AppStrings.startJournaling), findsOneWidget);

      // "Defteri Aç" butonuna basınca ana ekrana geçişi doğrula
      await tester.tap(find.text(AppStrings.startJournaling));
      await tester.pumpAndSettle();

      // Ana ekran öğelerini doğrula (Ajanda & Defter, Görünüm & Ayarlar)
      expect(find.text('Ajanda & Defter'), findsOneWidget);
      expect(find.text('Görünüm & Ayarlar'), findsOneWidget);
    });
  });
}
